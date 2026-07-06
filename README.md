# Piyí - Hotfix 21A-5 Final Logo Correcto

Este hotfix usa exactamente el logo final enviado por el usuario:

- perro y gato
- texto Piyí
- acento correcto
- sin usar capturas de error ni imágenes anteriores

## Aplicar

Extraer sobre:

```powershell
C:\Users\jairo\Documents\Piyi
```

Ejecutar:

```powershell
cd C:\Users\jairo\Documents\Piyi
powershell -ExecutionPolicy Bypass -File .\tools\Apply-Hotfix-21A-5.ps1
```

## Probar

```powershell
cd C:\Users\jairo\Documents\Piyi\piyi_mobile
flutter clean
flutter pub get
adb uninstall com.piyi.mobile
flutter run --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com
```

## Archivos incluidos

```text
piyi_mobile\assets\brand\piyi_logo.png
piyi_mobile\assets\brand\piyi_logo_square.png
piyi_mobile\android\app\src\main\res\mipmap-*\ic_launcher.png
piyi_mobile\android\app\src\main\res\mipmap-*\ic_launcher_round.png
docs\release\play_store\app_icon_512.png
docs\release\play_store\app_icon_1024_source.png
docs\release\play_store\feature_graphic_1024x500.png
docs\release\play_store\promo_graphic_180x120.png
```
