# Piyí - Sprint 01.01.1 Auth Users Fix

## Objetivo

Corregir errores detectados en Sprint 01.01:

- `User` no tenía `PhoneNumber`.
- `User` no tenía `IsActive`.
- `CreatedAt` usa `DateTimeOffset` y el DTO esperaba `DateTime`.
- `ReviewConfiguration` tenía `HasCheckConstraint` obsoleto.

## Cómo aplicar

Extraer este ZIP sobre:

```powershell
C:\Users\jairo\Documents\Piyi
```

Luego ejecutar:

```powershell
dotnet restore
dotnet build
```

Si compila, continuamos con migración inicial.
