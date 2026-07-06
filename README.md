# Piyí - Hotfix 20G Minimal Android Startup Recovery

## Objetivo

Corregir el bloqueo al iniciar la app después de instalar el APK.

## Aplicar

Extraer sobre:

```powershell
C:\Users\jairo\Documents\Piyi
```

Ejecutar:

```powershell
cd C:\Users\jairo\Documents\Piyi
powershell -ExecutionPolicy Bypass -File .\tools\Apply-Hotfix-20G.ps1
```

## Probar

```powershell
cd C:\Users\jairo\Documents\Piyi\piyi_mobile
flutter clean
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
flutter pub get
adb uninstall com.piyi.mobile
flutter run --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com
```
