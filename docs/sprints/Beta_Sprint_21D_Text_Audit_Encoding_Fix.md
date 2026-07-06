# Sprint 21D - Text Audit & Encoding Fix

## Objetivo

Corregir textos corruptos por codificación y textos visibles sin tildes.

## Incluye

- Corrección automática de mojibake común.
- Escritura UTF-8 sin BOM.
- Revisión de `.dart`, `.cs`, `.json`, `.xml`, `.md`, `.yaml`, `.html`.
- Reporte en `docs/audits/Text_Audit_Report_21D.txt`.

## Validación

Después de aplicar:

```powershell
dotnet build /warnaserror
cd .\piyi_mobile
flutter analyze --no-fatal-infos
```
