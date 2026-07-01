# Piyí - Hotfix 11A.2

## Corrige

Error:

```text
Business no contiene una definición para IsProviderPro
```

## Aplicar

Extraer sobre:

```powershell
C:\Users\jairo\Documents\Piyi
```

Luego ejecutar:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\Apply-Hotfix-11A-2.ps1
dotnet build
dotnet ef migrations add BetaCatalogInformationalPro --project .\src\Piyi.Infrastructure --startup-project .\src\Piyi.API
dotnet ef database update --project .\src\Piyi.Infrastructure --startup-project .\src\Piyi.API
```
