from __future__ import annotations
import argparse, json, shutil, sys
from dataclasses import dataclass, asdict
from datetime import datetime
from pathlib import Path

TEXT_EXTENSIONS={".dart",".cs",".csproj",".sln",".json",".xml",".md",".txt",".yaml",".yml",".ps1",".bat",".cmd",".html",".cshtml",".sql",".props",".targets",".gradle",".kts",".properties"}
SKIP_DIRS={".git",".vs",".idea",".vscode","bin","obj","build",".dart_tool",".gradle","node_modules","Pods","DerivedData",".pub-cache","coverage","artifacts","TestResults","dist"}
SUSPICIOUS=("Ãƒ","Ã‚","Ã","Â","â€","â€“","â€”","â€œ","â€","â€™","â€˜","â€¦","ï»¿","\ufffd")
EXACT={
"CÃƒÂ³digo":"Código","CÃƒÆ’Ã‚Â³digo":"Código","ConfiguraciÃƒÂ³n":"Configuración","ConfiguraciÃƒÆ’Ã‚Â³n":"Configuración",
"TelÃƒÂ©fono":"Teléfono","TelÃƒÆ’Ã‚Â©fono":"Teléfono","ContraseÃƒÂ±a":"Contraseña","ContraseÃƒÆ’Ã‚Â±a":"Contraseña",
"InformaciÃƒÂ³n":"Información","InformaciÃƒÆ’Ã‚Â³n":"Información","DescripciÃƒÂ³n":"Descripción","DescripciÃƒÆ’Ã‚Â³n":"Descripción",
"UbicaciÃƒÂ³n":"Ubicación","UbicaciÃƒÆ’Ã‚Â³n":"Ubicación","DirecciÃƒÂ³n":"Dirección","DirecciÃƒÆ’Ã‚Â³n":"Dirección",
"CategorÃƒÂ­a":"Categoría","CategorÃƒÆ’Ã‚Â­a":"Categoría","NÃƒÂºmero":"Número","NÃƒÆ’Ã‚Âºmero":"Número",
"PaÃƒÂ­s":"País","PaÃƒÆ’Ã‚Â­s":"País","PiyÃƒÂ­":"Piyí","PiyÃƒÆ’Ã‚Â­":"Piyí","PiyÃ­":"Piyí",
"Correo electronico":"Correo electrónico","Iniciar sesion":"Iniciar sesión","Cerrar sesion":"Cerrar sesión",
"Contrasena":"Contraseña","Telefono":"Teléfono","Aun no tienes mascotas":"Aún no tienes mascotas",
"Aun no tienes notificaciones":"Aún no tienes notificaciones","Aun no hay reportes":"Aún no hay reportes","Anadir":"Añadir"
}
@dataclass
class FileResult:
    path:str; changed:bool; before_score:int; after_score:int; replacements:int; error:str|None=None

def score(text):
    return sum(text.count(t)*10 for t in SUSPICIOUS)+sum(5 for ch in text if 0x80<=ord(ch)<=0x9F)

def candidate(text, enc):
    try: return text.encode(enc).decode("utf-8")
    except Exception: return None

def repair(text):
    cur=text
    for _ in range(6):
        opts=[cur]
        for enc in ("cp1252","latin1"):
            c=candidate(cur,enc)
            if c is not None: opts.append(c)
        best=min(opts,key=score)
        if best==cur or score(best)>=score(cur): break
        cur=best
    for bad in sorted(EXACT,key=len,reverse=True):
        cur=cur.replace(bad,EXACT[bad])
    return cur

def should_skip(path,root):
    rel=path.relative_to(root)
    if any(p in SKIP_DIRS for p in rel.parts): return True
    return path.suffix.lower() not in TEXT_EXTENSIONS and path.name not in {".gitignore",".dockerignore"}

def read_text(path):
    raw=path.read_bytes()
    if raw.startswith(b"\xef\xbb\xbf"): return raw[3:].decode("utf-8")
    for enc in ("utf-8","cp1252","latin1"):
        try:return raw.decode(enc)
        except UnicodeDecodeError: pass
    return raw.decode("utf-8","replace")

def process(path,root,backup,apply):
    try:
        original=read_text(path)
        fixed=repair(original)
        if path.name=="strings.xml" and 'name="app_name"' in fixed:
            import re
            fixed=re.sub(r'<string\s+name="app_name">.*?</string>','<string name="app_name">Piy&#237;</string>',fixed,flags=re.S)
        if path.name=="piyi_brand.dart":
            fixed=fixed.replace("displayName = 'Piyí'",r"displayName = 'Piy\u00ed'")
        changed=fixed!=original
        if changed and apply:
            dest=backup/path.relative_to(root);dest.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(path,dest)
            path.write_text(fixed,encoding="utf-8",newline="")
        return FileResult(str(path.relative_to(root)),changed,score(original),score(fixed),0)
    except Exception as e:
        return FileResult(str(path.relative_to(root)),False,0,0,0,f"{type(e).__name__}: {e}")

def main():
    ap=argparse.ArgumentParser();ap.add_argument("--root",default=".");ap.add_argument("--apply",action="store_true");args=ap.parse_args()
    root=Path(args.root).resolve();stamp=datetime.now().strftime("%Y%m%d_%H%M%S");backup=root/"encoding_backup"/stamp
    reportdir=root/"docs"/"audits";reportdir.mkdir(parents=True,exist_ok=True)
    results=[]
    for p in root.rglob("*"):
        if p.is_file() and not should_skip(p,root):
            r=process(p,root,backup,args.apply);results.append(r)
            if r.changed: print(f"CHANGE {r.path} ({r.before_score}->{r.after_score})")
            if r.error: print(f"ERROR {r.path}: {r.error}")
    suspicious=[r for r in results if r.after_score>0 and not r.error];errors=[r for r in results if r.error];changed=[r for r in results if r.changed]
    report={"generatedAt":datetime.now().isoformat(),"mode":"apply" if args.apply else "audit","filesReviewed":len(results),"filesChanged":len(changed),"filesWithErrors":len(errors),"filesStillSuspicious":len(suspicious),"backupDirectory":str(backup) if args.apply else None,"results":[asdict(r) for r in results]}
    (reportdir/f"Encoding_Audit_Report_{stamp}.json").write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding="utf-8")
    lines=[f"Piyí Sprint 23 - Encoding Audit","",f"Archivos revisados: {len(results)}",f"Archivos modificados: {len(changed)}",f"Archivos con error: {len(errors)}",f"Archivos aún sospechosos: {len(suspicious)}",""]
    lines+=["MODIFICADOS"]+[r.path for r in changed]+["","SOSPECHOSOS"]+[f"{r.path} score={r.after_score}" for r in suspicious]+["","ERRORES"]+[f"{r.path}: {r.error}" for r in errors]
    txt=reportdir/f"Encoding_Audit_Report_{stamp}.txt";txt.write_text("\n".join(lines)+"\n",encoding="utf-8")
    print(f"\nReporte: {txt}")
    if args.apply: print(f"Respaldo: {backup}")
    return 1 if errors else (2 if suspicious else 0)
if __name__=="__main__": sys.exit(main())
