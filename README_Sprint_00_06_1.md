# Piyí Sprint 00.06.1 - EF Core Fix

Este parche corrige los errores `EntityTypeBuilder<T> no contiene una definición para ToTable`.

## Qué corrige

- Agrega `using Microsoft.EntityFrameworkCore;` a las configuraciones que usan `ToTable()`.
- Fija `Microsoft.EntityFrameworkCore.Relational` en versión `8.0.6` dentro de `Directory.Packages.props` para evitar que NuGet intente usar EF Core 10.

## Cómo aplicar

Extrae este ZIP sobre la raíz del proyecto:

```powershell
C:\Users\jairo\Documents\Piyi
```

Luego ejecuta:

```powershell
dotnet restore
dotnet build
```

## Importante

Si previamente intentaste agregar EF Core Relational con versión 10 y quedó una referencia en el `.csproj`, revisa:

```powershell
src\Piyi.Infrastructure\Piyi.Infrastructure.csproj
```

No debe existir una referencia con versión explícita `10.x`. Si aparece, elimínala o déjala sin versión usando Central Package Management.
