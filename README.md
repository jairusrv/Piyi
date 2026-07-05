# Piyí - Hotfix 20C Clean Build

Corrige dependencias Flutter para resolver conflicto device_info_plus / flutter_secure_storage / win32.

## Aplicar

Extraer sobre:

C:\Users\jairo\Documents\Piyi

## Validar API

cd C:\Users\jairo\Documents\Piyi
dotnet build /warnaserror

## Validar Flutter

cd C:\Users\jairo\Documents\Piyi\piyi_mobile
flutter clean
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
Remove-Item pubspec.lock -Force -ErrorAction SilentlyContinue
flutter pub get
flutter analyze --no-fatal-infos
flutter test
flutter build apk --release --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com
