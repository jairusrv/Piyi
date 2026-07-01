# Hotfix 11A.1

## Problema

Piyi.Contracts estaba importando Piyi.Domain.Enums.

Eso rompe porque Contracts no referencia Domain.

## Solución

- Crear `BusinessCatalogItemTypeDto` dentro de Piyi.Contracts.
- Usar ese enum en DTOs.
- Convertir explícitamente en Infrastructure:

```csharp
Type = (BusinessCatalogItemType)request.Type
```

y

```csharp
(BusinessCatalogItemTypeDto)x.Type
```
