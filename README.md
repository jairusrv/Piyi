# Piyí - Sprint 03.03.1 Business Domain Fix

## Objetivo

Corregir inconsistencia detectada en negocios:

```text
Business no contiene una definición para IsActive
```

## Qué corrige

- Agrega `IsActive` a `Business`.
- Deja `Business` alineado con el directorio público y Admin.
- Actualiza `BusinessStatus`.
- Actualiza `BusinessConfiguration`.

## Cómo aplicar

Extraer sobre:

```powershell
C:\Users\jairo\Documents\Piyi
```

Luego:

```powershell
dotnet restore
dotnet build
```

Si ya tienes migraciones creadas, después de compilar crea migración:

```powershell
dotnet ef migrations add AddBusinessIsActive `
  --project .\src\Piyi.Infrastructure\Piyi.Infrastructure.csproj `
  --startup-project .\src\Piyi.API\Piyi.API.csproj `
  --output-dir Data\Migrations
```
