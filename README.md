# Piyí - Hotfix 21B Logo/Login/Icon

## Corrige

- El ícono del escritorio Android se veía como icono genérico de Android.
- Login mostraba huella + texto Piyí.
- Ahora login usa el logo oficial de Piyí.
- Agrega adaptive icon Android.
- Regenera mipmap icons.
- Agrega assets del logo en Flutter.

## Aplicar

Extraer sobre:

```powershell
C:\Users\jairo\Documents\Piyi
```

Ejecutar:

```powershell
cd C:\Users\jairo\Documents\Piyi
powershell -ExecutionPolicy Bypass -File .\tools\Apply-Hotfix-21B-Logo-Login-Icon.ps1
```

## Probar

```powershell
cd C:\Users\jairo\Documents\Piyi\piyi_mobile
flutter clean
Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
flutter pub get
adb uninstall com.piyi.mobile
flutter run --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com
```

## Archivos incluidos

```text
piyi_mobile\assets\brand\piyi_logo.png
piyi_mobile\assets\brand\piyi_logo_square.png
piyi_mobile\assets\images\logo.png
piyi_mobile\android\app\src\main\res\mipmap-*\ic_launcher.png
piyi_mobile\android\app\src\main\res\mipmap-anydpi-v26\ic_launcher.xml
piyi_mobile\android\app\src\main\res\drawable-*\ic_launcher_foreground.png
piyi_mobile\android\app\src\main\res\drawable\ic_launcher_background.xml
```
