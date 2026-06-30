# Piyí - Sprint 04.04 Location Alerts Base

## Objetivo

Preparar la base de alertas por zona para mascotas perdidas.

Este sprint NO envía push notifications todavía. Deja lista la estructura para:

- Guardar zona de alerta del usuario.
- Activar/desactivar alertas.
- Consultar configuración actual.
- Detectar usuarios candidatos a recibir alerta por cercanía.
- Endpoint admin/dev para simular candidatos.

## Endpoints protegidos

Usuario:

```text
GET /api/users/me/alert-settings
PUT /api/users/me/alert-settings
```

Admin/Dev:

```text
GET /api/dev/lost-pets/{lostPetId}/alert-candidates
```

## Nueva entidad

```text
UserAlertSetting
```

## Si ya tienes migraciones

Crear migración:

```powershell
dotnet ef migrations add AddUserAlertSettings `
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
