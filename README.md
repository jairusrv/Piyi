# Piyí - Sprint 02.03 Pet QR Base

## Objetivo

Implementar QR base para mascotas.

Incluye:

- Generar QR único para una mascota.
- Consultar QR de una mascota.
- Endpoint público para escaneo.
- Incrementar contador de escaneos.

## Endpoints

Protegidos con JWT:

```text
POST /api/pets/{petId}/qr
GET  /api/pets/{petId}/qr
```

Público:

```text
GET /api/public/pets/qr/{code}
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

Este sprint asume que existe la entidad `PetQrCode` y DbSet `PetQrCodes`.
