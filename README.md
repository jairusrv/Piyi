# Piyí - Sprint 04.03 Lost Pet Sightings

## Objetivo

Agregar avistamientos para mascotas perdidas.

Permite que un usuario reporte que cree haber visto una mascota perdida, incluyendo ubicación, comentario y foto opcional.

## Endpoints públicos/protegidos

Crear avistamiento:

```text
POST /api/lost-pets/{lostPetId}/sightings
```

Listar avistamientos:

```text
GET /api/lost-pets/{lostPetId}/sightings
```

Administrar avistamiento por dueño del reporte:

```text
PUT /api/lost-pets/{lostPetId}/sightings/{sightingId}/confirm
PUT /api/lost-pets/{lostPetId}/sightings/{sightingId}/discard
DELETE /api/lost-pets/{lostPetId}/sightings/{sightingId}
```

## Nueva entidad

```text
LostPetSighting
```

## Si ya tienes migraciones

Crear migración:

```powershell
dotnet ef migrations add AddLostPetSightings `
  --project .\src\Piyi.Infrastructure\Piyi.Infrastructure.csproj `
  --startup-project .\src\Piyi.API\Piyi.API.csproj `
  --output-dir Data\Migrations

dotnet ef database update `
  --project .\src\Piyi.Infrastructure\Piyi.Infrastructure.csproj `
  --startup-project .\src\Piyi.API\Piyi.API.csproj
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
