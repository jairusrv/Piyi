# Piyí - Sprint 02.05 Pet Appointments

## Objetivo

Agregar citas para mascotas: veterinaria, grooming, hotel, paseo, entrenamiento u otro servicio.

## Endpoints

```text
GET    /api/pets/{petId}/appointments
GET    /api/pets/{petId}/appointments/{appointmentId}
POST   /api/pets/{petId}/appointments
PUT    /api/pets/{petId}/appointments/{appointmentId}
DELETE /api/pets/{petId}/appointments/{appointmentId}
PUT    /api/pets/{petId}/appointments/{appointmentId}/complete
PUT    /api/pets/{petId}/appointments/{appointmentId}/cancel
```

Todos requieren JWT.

## Nota de dominio

Este sprint agrega una nueva entidad:

```text
PetAppointment
```

Si ya tienes migración inicial creada, debes crear una nueva migración:

```powershell
dotnet ef migrations add AddPetAppointments `
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
