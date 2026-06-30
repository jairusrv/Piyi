# Piyí - Sprint 03.01 Business Directory Base

## Objetivo

Agregar la primera versión pública del directorio de negocios.

Incluye:

- Listar tipos de negocio.
- Buscar negocios por texto.
- Ver detalle básico de negocio.

## Endpoints públicos

```text
GET /api/catalogs/business-types
GET /api/businesses
GET /api/businesses/{id}
```

## Ejemplos

```text
GET /api/businesses?search=veterinaria
GET /api/businesses?businessTypeId=GUID
```

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

## Nota

Este sprint es intencionalmente simple y público. La creación/edición/aprobación de negocios quedará para el Admin.
