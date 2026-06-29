# Piyí Database - Sprint 00.06

Este sprint agrega el dominio inicial y la infraestructura EF Core para PostgreSQL.

## Entidades incluidas

- Users
- AuthProviders
- Species
- Breeds
- Pets
- PetQrCodes
- PetVaccines
- PetReminders
- BusinessTypes
- Businesses
- BusinessPhotos
- BusinessServices
- BusinessSchedules
- Reviews
- LostPets
- LostPetPhotos
- Subscriptions
- AdEvents

## Decisiones

- Todos los Id son `Guid`.
- Auditoría y soft delete por `BaseEntity`.
- Enums se guardan como texto para mayor claridad.
- `Species` y `BusinessTypes` son catálogos administrables.
- No se implementa CRM veterinario.
