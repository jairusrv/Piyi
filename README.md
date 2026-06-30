# Piyí - Sprint 03.04 Admin Business Details

## Objetivo

Permitir que un administrador agregue detalles a los negocios:

- Servicios.
- Fotos.
- Horarios.

## Endpoints Admin

Servicios:

```text
POST   /api/admin/businesses/{businessId}/services
DELETE /api/admin/businesses/{businessId}/services/{serviceId}
```

Fotos:

```text
POST   /api/admin/businesses/{businessId}/photos
DELETE /api/admin/businesses/{businessId}/photos/{photoId}
```

Horarios:

```text
PUT /api/admin/businesses/{businessId}/schedules
```

Todos requieren JWT con rol `Admin`.

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
