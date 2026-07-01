# BETA Hotfix 09.1 - Compile Fix

## Corrige

- Providers renombrados en pets.
- createPet con photoUrl.
- Archivos faltantes de mapa.
- DioExceptionType.transformTimeout.

## Verificación

```powershell
flutter clean
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
flutter pub get
flutter run
```
