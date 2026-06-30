# Piyí - Sprint 02.04 Pet Vaccines + Reminders

## Objetivo

Agregar gestión básica de vacunas y recordatorios para mascotas.

## Endpoints

Vacunas:

```text
GET  /api/pets/{petId}/vaccines
POST /api/pets/{petId}/vaccines
```

Recordatorios:

```text
GET /api/pets/{petId}/reminders
POST /api/pets/{petId}/reminders
PUT /api/pets/{petId}/reminders/{reminderId}/complete
```

Todos requieren JWT.

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
