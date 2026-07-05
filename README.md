# Piyí - Hotfix 20E API WarnAsError Fix

## Corrige

- `LostPetService.cs`: quita `#nullable disable`, agrega `#nullable enable` y suprime solo `CS8601`.
- `BusinessReviewConfiguration.cs`: reemplaza el archivo completo para eliminar el `HasCheckConstraint` obsoleto.
- `android/build.gradle`: si no existe, lo crea para forzar `compileSdk 36` en subproyectos Android.

## Aplicar

Extraer sobre:

```powershell
C:\Users\jairo\Documents\Piyi
```

Ejecutar:

```powershell
cd C:\Users\jairo\Documents\Piyi
powershell -ExecutionPolicy Bypass -File .\tools\Apply-Hotfix-20E.ps1
dotnet build /warnaserror
```

Luego Flutter:

```powershell
cd C:\Users\jairo\Documents\Piyi\piyi_mobile
flutter clean
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
flutter pub get
flutter build apk --release --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com
```
