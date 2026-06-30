# Piyí - Sprint 04.01 Lost Pets Base

## Objetivo

Agregar módulo base de mascotas perdidas.

## Endpoints públicos

```text
GET /api/lost-pets
GET /api/lost-pets/{id}
```

## Endpoints protegidos

```text
POST /api/pets/{petId}/lost-pets
PUT  /api/lost-pets/{id}/found
PUT  /api/lost-pets/{id}/close
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
