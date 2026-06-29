# Piyí - ERD Mermaid v1

Puedes pegar este contenido en un visor compatible con Mermaid.

```mermaid
erDiagram
    Users ||--o{ AuthProviders : has
    Users ||--o{ PetUsers : owns_or_accesses
    Pets ||--o{ PetUsers : shared_with

    Species ||--o{ Breeds : has
    Species ||--o{ Pets : classifies
    Breeds ||--o{ Pets : classifies
    PetColors ||--o{ Pets : primary_color
    PetSizes ||--o{ Pets : size

    Pets ||--o{ PetPhotos : has
    Pets ||--|| PetQrCodes : has
    Pets ||--o{ PetVaccines : has
    Pets ||--o{ PetReminders : has
    Pets ||--o{ PetMedications : has
    Pets ||--o{ PetAllergies : has
    Pets ||--o{ LostPets : may_have

    VaccineTypes ||--o{ PetVaccines : defines
    Species ||--o{ VaccineTypes : applies_to

    Users ||--o{ BusinessUsers : manages
    Businesses ||--o{ BusinessUsers : has
    BusinessTypes ||--o{ Businesses : classifies
    Businesses ||--o{ BusinessPhotos : has
    Businesses ||--o{ BusinessServices : offers
    Businesses ||--o{ BusinessSchedules : opens
    Businesses ||--o{ Reviews : receives
    Users ||--o{ Reviews : writes

    LostPets ||--o{ LostPetPhotos : has
    Users ||--o{ LostPets : creates

    Users ||--o{ Subscriptions : has
    Users ||--o{ AdEvents : generates
```

## Relaciones clave

- `Pets` no pertenece directamente a un único usuario; se relaciona por `PetUsers`.
- `Businesses` no pertenece directamente a un único usuario; se relaciona por `BusinessUsers`.
- `PetQrCodes` mantiene la identidad pública escaneable.
- Los catálogos evitan valores quemados en código.

