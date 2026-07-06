# Piyí - Hotfix 21B-2 UserName + Phone + Logo/Icon

## Por qué no se veía el código de área

El widget `PiyiCountryPhoneField` estaba importado, pero el campo anterior de teléfono no fue reemplazado en `register_screen.dart`. Por eso `flutter analyze` lo marcaba como `unused_import` y en pantalla seguía viéndose el campo normal `Telefono`.

## Por qué Home mostraba Jairo

El texto estaba quedando como saludo fijo en la pantalla Home. Este hotfix lo reemplaza por un widget que intenta leer el nombre desde sesión/token seguro.

## Qué corrige

- Campo teléfono con bandera y código país.
- Home con nombre dinámico del usuario.
- Logo de login con asset de mayor resolución y `FilterQuality.high`.
- Ícono launcher Android con adaptive icon.
- Assets de logo en alta resolución.

## Aplicar

```powershell
cd C:\Users\jairo\Documents\Piyi
powershell -ExecutionPolicy Bypass -File .\tools\Apply-Hotfix-21B-2.ps1
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
