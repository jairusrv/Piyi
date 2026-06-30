# Piyí - Sprint 04.05 Push Device Tokens

## Objetivo

Preparar backend para notificaciones push.

Este sprint NO envía notificaciones todavía. Solo registra tokens de dispositivos.

## Endpoints protegidos

```text
GET    /api/users/me/devices
POST   /api/users/me/devices
PUT    /api/users/me/devices/{deviceId}
DELETE /api/users/me/devices/{deviceId}
```

## Nueva entidad

```text
UserDevice
```

## Si ya tienes migraciones

Crear migración:

```powershell
dotnet ef migrations add AddUserDevices `
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
