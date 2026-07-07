# Piyí - Hotfix 22-1 RC1 Analyze Errors Fix

Corrige los errores reales de `flutter analyze`:

- `getRefreshToken` faltante.
- `saveRefreshToken` faltante.
- `saveUserData` faltante.
- `clearAllSession` faltante.
- `PiyiLogoHeader(size:)` inválido.
- Import innecesario/autorreferenciado en `piyi_app_back_button.dart`.

## Aplicar

```powershell
cd C:\Users\jairo\Documents\Piyi
powershell -ExecutionPolicy Bypass -File .\tools\Apply-Hotfix-22-1.ps1
```

## Validar

```powershell
cd C:\Users\jairo\Documents\Piyi\piyi_mobile
flutter analyze --no-fatal-infos
flutter run --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com
```
