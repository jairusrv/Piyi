# Piyí - BETA Hotfix 09.1 Compile Fix

Corrige errores después de aplicar Maps + Uploads.

## Corrige

- map_markers_controller.dart faltante.
- map_repository.dart faltante.
- map_marker_models.dart faltante.
- petsProvider alias.
- breedsBySpeciesProvider alias.
- createPet con photoUrl.
- DioExceptionType.transformTimeout.

## Aplicar

Extraer sobre:

```powershell
C:\Users\jairo\Documents\Piyi\piyi_mobile
```

Luego:

```powershell
flutter clean
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
flutter pub get
flutter run
```
