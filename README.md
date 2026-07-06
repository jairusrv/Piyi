# Piyí - Hotfix 21A-7 v2

Corrige el error:

```text
[System.IO.Path] no contiene ningún método llamado 'GetRelativePath'
```

## Aplicar

```powershell
cd C:\Users\jairo\Documents\Piyi
powershell -ExecutionPolicy Bypass -File .\tools\Apply-Hotfix-21A-7-v2.ps1
```

Luego:

```powershell
cd C:\Users\jairo\Documents\Piyi\piyi_mobile
flutter clean
flutter pub get
flutter analyze --no-fatal-infos
flutter run --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com
```
