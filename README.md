# Piyí - Hotfix 20F

## Android Startup + Icon + Play Store

Aplicar sobre:

```powershell
C:\Users\jairo\Documents\Piyi
```

Luego:

```powershell
cd C:\Users\jairo\Documents\Piyi
powershell -ExecutionPolicy Bypass -File .\tools\Apply-Hotfix-20F.ps1

cd C:\Users\jairo\Documents\Piyi\piyi_mobile
flutter clean
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
flutter pub get
flutter run --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com
```

## Build APK testers

```powershell
flutter build apk --release --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com
```

APK esperado:

```text
android\app\build\outputs\apk\release\app-release.apk
```

## Play Store assets

```text
docs\release\play_store\app_icon_512.png
docs\release\play_store\feature_graphic_1024x500.png
docs\release\play_store\promo_graphic_180x120.png
docs\release\play_store\listing_es_CR.txt
docs\release\play_store\release_notes_beta_es_CR.txt
```
