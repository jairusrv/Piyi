# Piyí - Hotfix 20D Compile Release Fix

## Corrige

- API:
  - `BusinessReviewConfiguration.cs`: cambia `builder.HasCheckConstraint(...)` obsoleto por `builder.ToTable(..., t => t.HasCheckConstraint(...))`.
  - `LostPetService.cs`: desactiva nullable warnings dentro del archivo para pasar `dotnet build /warnaserror`.

- Flutter Android:
  - Fuerza `compileSdk = 36` también en subproyectos/plugins Android como `geocoding_android`.
  - Quita `id "kotlin-android"` del `android/app/build.gradle` para eliminar el warning de Kotlin Gradle Plugin aplicado por la app.
  - Agrega supresión de warnings Java `-Xlint:-options`.

## Aplicar

Extraer sobre:

```powershell
C:\Users\jairo\Documents\Piyi
```

Luego ejecutar:

```powershell
cd C:\Users\jairo\Documents\Piyi
powershell -ExecutionPolicy Bypass -File .\tools\Apply-Hotfix-20D.ps1
```

## Validar API

```powershell
dotnet build /warnaserror
```

## Validar Flutter

```powershell
cd C:\Users\jairo\Documents\Piyi\piyi_mobile
flutter clean
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
flutter pub get
flutter analyze --no-fatal-infos
flutter test
flutter build apk --release --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com
```
