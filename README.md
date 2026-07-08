# Piyí - Hotfix 22-4 SecureStorage Provider + Legacy Compat

Corrige:

- `secureStorageServiceProvider` no definido.
- `saveToken` no definido.
- `saveUserProfile` no definido.
- `clearAll` no definido.
- `getToken` no definido.

## Aplicar

```powershell
cd C:\Users\jairo\Documents\Piyi
powershell -ExecutionPolicy Bypass -File .\tools\Apply-Hotfix-22-4.ps1
```

## Validar

```powershell
cd C:\Users\jairo\Documents\Piyi\piyi_mobile
flutter clean
Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
flutter pub get
flutter analyze --no-fatal-infos
flutter build apk --release --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com
```
