# Piyí - Sprint 02.02.1 Pet Catalogs Fix

## Corrección

Corrige error:

```text
Breed no contiene una definición para SortOrder
```

## Cambio aplicado

- `CatalogService` ya no ordena razas por `SortOrder`.
- `BreedResponse.SortOrder` se mantiene en `0` temporalmente.
- Las razas se ordenan por `Name`.

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
