# Piyí - Hotfix 21A-3 UI Compile Fix

Corrige errores del Sprint 21A:

- Widgets exportados pero faltantes.
- `PiyiTheme.dark` inexistente.
- `PiyiColors.secondary` inexistente.
- `PiyiColors.subtitle` inexistente.

## Aplicar

Extraer sobre:

```powershell
C:\Users\jairo\Documents\Piyi
```

Ejecutar:

```powershell
cd C:\Users\jairo\Documents\Piyi
powershell -ExecutionPolicy Bypass -File .\tools\Apply-Hotfix-21A-3.ps1
```

Luego:

```powershell
cd C:\Users\jairo\Documents\Piyi\piyi_mobile
flutter clean
flutter pub get
flutter run --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com
```
