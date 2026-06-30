# Piyí - Sprint 04.02 Lost Pet Photos + Filters

## Objetivo

Mejorar mascotas perdidas con fotos adicionales y filtros.

## Endpoints públicos

```text
GET /api/lost-pets?city=Cartago&region=Cartago&latitude=9.86&longitude=-83.91&radiusKm=10
GET /api/lost-pets/{id}
```

## Endpoints protegidos

```text
POST   /api/lost-pets/{lostPetId}/photos
DELETE /api/lost-pets/{lostPetId}/photos/{photoId}
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
