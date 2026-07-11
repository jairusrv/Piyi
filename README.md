# Piyí — Sprint 23B

## Aplicar

```powershell
cd C:\Users\jairo\Documents\Piyi
.\tools\Apply-Sprint-23B.bat
```

## Publicar

```powershell
git add .
git commit -m "Sprint 23B encoding and pet catalog database seed"
git push
```

En Render:

```text
Manual Deploy → Clear build cache & deploy
```

## Verificar catálogo publicado

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\Verify-Pet-Catalog-23B.ps1
```
