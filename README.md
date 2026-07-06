# Piyí - Sprint 21C Pet Catalog Seed Data

## Aplicar

```powershell
cd C:\Users\jairo\Documents\Piyi
powershell -ExecutionPolicy Bypass -File .\tools\Apply-Sprint-21C.ps1
dotnet build /warnaserror
```

## Subir a Render

```powershell
git add .
git commit -m "Sprint 21C seed pet species and breeds"
git push
```

Luego en Render:

```text
Manual Deploy -> Clear build cache & deploy
```

Al iniciar el API, Neon quedará precargado con especies y razas.
