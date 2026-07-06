# Piyí - Hotfix 21D-2 Text Audit JSON Fix

Corrige el error del script anterior usando un JSON ASCII con escapes Unicode.

## Aplicar

```powershell
cd C:\Users\jairo\Documents\Piyi
powershell -ExecutionPolicy Bypass -File .\tools\Apply-Hotfix-21D-2-Text-Audit.ps1
```

## Validar

```powershell
dotnet build /warnaserror

cd .\piyi_mobile
flutter analyze --no-fatal-infos
flutter run --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com
```

Reporte:

```text
docs\audits\Text_Audit_Report_21D_2.txt
```
