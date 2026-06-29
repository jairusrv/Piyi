# Piyí - Modelo de Dominio v1

## Objetivo

Definir el modelo base del MVP antes de generar la migración inicial definitiva.

---

# Núcleo del sistema

## Users

Representa una persona que usa Piyí.

Campos principales:

- Id
- FirstName
- LastName
- Email
- PhoneNumber
- PasswordHash
- Role
- Status
- ProfilePhotoUrl
- CreatedAt
- UpdatedAt
- IsDeleted

Relaciones:

- Un usuario puede estar relacionado con muchas mascotas por medio de `PetUsers`.
- Un usuario puede administrar muchos negocios por medio de `BusinessUsers`.
- Un usuario puede crear reseñas.
- Un usuario puede tener suscripción Pro.

---

## AuthProviders

Permite login con correo, Google o Apple.

Campos:

- Id
- UserId
- ProviderType: EMAIL, GOOGLE, APPLE
- ProviderUserId
- Email
- CreatedAt

---

# Mascotas

## Pets

Representa la identidad digital de una mascota.

Campos:

- Id
- Name
- SpeciesId
- BreedId
- BirthDate
- ApproximateAge
- Sex
- WeightKg
- PrimaryColorId
- SecondaryColorId
- SizeId
- IsSterilized
- MicrochipNumber
- Status: ACTIVE, LOST, DECEASED
- CreatedAt
- UpdatedAt
- IsDeleted

Relaciones:

- Muchos usuarios por `PetUsers`.
- Una especie.
- Una raza.
- Muchos recordatorios.
- Muchas vacunas.
- Muchas fotos.
- Un QR activo.
- Puede tener reportes de pérdida.

---

## PetUsers

Relaciona usuarios con mascotas.

Campos:

- Id
- PetId
- UserId
- Role: OWNER, FAMILY, CARETAKER, VIEWER
- CanEdit
- CanManageQr
- CanManageReminders
- IsPrimaryOwner
- CreatedAt

Regla:

Una mascota debe tener al menos un propietario principal.

---

## Species

Catálogo de especies.

Ejemplos:

- Perro
- Gato
- Conejo
- Ave
- Tortuga
- Caballo
- Otro

Campos:

- Id
- Name
- Code
- Icon
- SortOrder
- IsActive

---

## Breeds

Catálogo de razas por especie.

Campos:

- Id
- SpeciesId
- Name
- SizeId
- IsActive

---

## PetColors

Catálogo de colores.

Campos:

- Id
- Name
- HexColor
- IsActive

---

## PetSizes

Catálogo de tamaños.

Ejemplos:

- Mini
- Pequeño
- Mediano
- Grande
- Gigante

Campos:

- Id
- Name
- Code
- SortOrder
- IsActive

---

## PetPhotos

Galería de fotos de la mascota.

Campos:

- Id
- PetId
- PhotoUrl
- IsPrimary
- SortOrder
- CreatedAt

---

## PetQrCodes

Código QR público de la mascota.

Campos:

- Id
- PetId
- Code
- PublicUrl
- IsActive
- ScanCount
- LastScannedAt
- ShowOwnerName
- ShowOwnerPhone
- ShowMedicalAlerts
- CreatedAt

Regla:

Solo debe existir un QR activo por mascota.

---

## PetVaccines

Vacunas aplicadas o pendientes.

Campos:

- Id
- PetId
- VaccineTypeId
- Name
- AppliedDate
- NextDueDate
- VeterinaryName
- Notes
- CreatedAt

---

## VaccineTypes

Catálogo de vacunas por especie.

Campos:

- Id
- SpeciesId
- Name
- IsCore
- DefaultValidityMonths
- IsActive

---

## PetReminders

Recordatorios para el dueño.

Campos:

- Id
- PetId
- Title
- Type
- ReminderDate
- RepeatType
- IsCompleted
- Notes
- CreatedAt

Tipos:

- Vaccine
- Deworming
- Medication
- Appointment
- Grooming
- Other

---

## PetMedications

Medicamentos de uso actual o histórico simple.

Campos:

- Id
- PetId
- Name
- Dosage
- Frequency
- StartDate
- EndDate
- IsActive
- Notes
- CreatedAt

---

## PetAllergies

Alertas importantes visibles opcionalmente desde QR.

Campos:

- Id
- PetId
- Name
- Severity: LOW, MEDIUM, HIGH
- Notes
- CreatedAt

---

# Negocios

## Businesses

Representa veterinarias, groomers, tiendas, hoteles, entrenadores, paseadores o refugios.

Campos:

- Id
- BusinessTypeId
- Name
- Description
- PhoneNumber
- WhatsAppNumber
- Email
- WebsiteUrl
- FacebookUrl
- InstagramUrl
- TikTokUrl
- Country
- Region
- City
- Address
- Latitude
- Longitude
- LogoUrl
- Status: PENDING, ACTIVE, SUSPENDED
- IsVerified
- CreatedAt
- UpdatedAt
- IsDeleted

Relaciones:

- Muchos usuarios administradores por `BusinessUsers`.
- Muchas fotos.
- Muchos servicios.
- Muchos horarios.
- Muchas reseñas.

---

## BusinessUsers

Relaciona usuarios con negocios.

Campos:

- Id
- BusinessId
- UserId
- Role: OWNER, ADMIN, STAFF
- CanEditProfile
- CanManagePhotos
- CanRespondReviews
- CreatedAt

---

## BusinessTypes

Catálogo de tipos de negocio.

Ejemplos:

- Veterinaria
- Grooming
- Tienda
- Hotel
- Paseador
- Entrenador
- Refugio

Campos:

- Id
- Name
- Code
- Icon
- SortOrder
- IsActive

---

## BusinessPhotos

Fotos del negocio.

Campos:

- Id
- BusinessId
- PhotoUrl
- SortOrder
- CreatedAt

---

## BusinessServices

Servicios visibles en el perfil del negocio.

Campos:

- Id
- BusinessId
- Name
- Description
- PriceFrom
- PriceTo
- IsActive

---

## BusinessSchedules

Horario semanal.

Campos:

- Id
- BusinessId
- DayOfWeek
- OpensAt
- ClosesAt
- IsClosed

---

## Reviews

Reseñas de usuarios a negocios.

Campos:

- Id
- BusinessId
- UserId
- Rating
- Comment
- IsApproved
- CreatedAt

Regla:

Rating debe estar entre 1 y 5.

---

# Mascotas perdidas

## LostPets

Reporte de mascota perdida.

Campos:

- Id
- PetId
- CreatedByUserId
- Title
- Description
- LastSeenAddress
- LastSeenLatitude
- LastSeenLongitude
- LostDate
- Status: ACTIVE, FOUND, CLOSED
- ContactPhone
- RewardAmount
- CreatedAt
- UpdatedAt

---

## LostPetPhotos

Fotos específicas del reporte.

Campos:

- Id
- LostPetId
- PhotoUrl
- CreatedAt

---

# Monetización

## Subscriptions

Suscripción Piyí Pro.

Campos:

- Id
- UserId
- Plan: FREE, PRO
- Status: ACTIVE, EXPIRED, CANCELLED
- StartedAt
- ExpiresAt
- Provider: GOOGLE_PLAY, APP_STORE, MANUAL
- ExternalPaymentId
- CreatedAt

---

## AdEvents

Eventos básicos de publicidad sin guardar datos sensibles.

Campos:

- Id
- UserId
- Placement
- AdProvider
- EventType: IMPRESSION, CLICK
- CreatedAt

---

# Futuro no MVP

Estas entidades quedan fuera del MVP inicial:

- InsuranceLeads
- QrPlateOrders
- Payments
- Documents
- Notifications advanced
- Push tokens
- Marketplace orders
- Appointment booking

