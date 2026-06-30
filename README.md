# Piyí - Sprint 02.02 Pet Catalogs

## Objetivo

Agregar catálogos básicos para el registro de mascotas.

Incluye:

- Listar especies.
- Listar razas por especie.
- Endpoint público para catálogos.

## Endpoints

```text
GET /api/catalogs/species
GET /api/catalogs/species/{speciesId}/breeds
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

Estos endpoints no requieren JWT porque la pantalla de registro de mascota necesita cargar catálogos de forma simple.
