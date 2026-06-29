# Piyí - Decisiones de Dominio v1

## 1. La mascota es el centro del sistema

Piyí se organiza alrededor de la identidad digital de la mascota. El usuario es propietario, administrador o colaborador, pero el valor principal vive en el perfil de cada mascota.

## 2. Una mascota puede tener varios usuarios relacionados

No se usará únicamente `Pets.UserId` como dueño único. Se agregará una tabla pivote:

`PetUsers`

Esto permite:

- Dueño principal.
- Familiares con acceso.
- Cuidadores temporales.
- Compartir información sin compartir contraseña.

## 3. Un negocio puede tener varios administradores

No se usará únicamente `Businesses.OwnerUserId`. Se agregará:

`BusinessUsers`

Esto permite que una veterinaria, groomer o tienda tenga más de una persona administrando el perfil.

## 4. Piyí no será un CRM veterinario

No se implementarán expedientes clínicos avanzados, facturación, inventario, caja ni agenda interna de veterinarias. Piyí conecta usuarios con servicios y administra la identidad digital de la mascota.

## 5. Catálogos administrables

Las siguientes entidades serán catálogos administrables desde el Admin:

- Species
- Breeds
- PetColors
- PetSizes
- BusinessTypes
- VaccineTypes
- ReminderTypes

Esto evita publicar una nueva versión de la app cada vez que se agregue una especie, raza o categoría.

## 6. Fotos separadas por contexto

No se almacenará una sola foto en `Pets`. Se manejará:

- `PetPhotos` para galería e imagen principal.
- `LostPetPhotos` para reportes de mascotas perdidas.
- `BusinessPhotos` para negocios.

## 7. QR como identidad pública segura

Cada mascota tendrá un QR público, pero no debe exponer información sensible por defecto. El usuario decide qué mostrar.

## 8. Monetización aprobada para MVP

- AdMob en versión gratuita.
- Piyí Pro elimina anuncios.
- Placas QR Piyí como producto físico futuro.
- Seguros queda como alianza tentativa futura.

No se desarrollará Piyí Ads en esta etapa.

## 9. Internacionalización desde base de datos

No usar campos específicos de Costa Rica como Provincia, Cantón o Distrito. Se usará:

- Country
- Region
- City
- Latitude
- Longitude

## 10. Soft delete y auditoría

Todas las entidades importantes deben tener:

- CreatedAt
- CreatedBy
- UpdatedAt
- UpdatedBy
- IsDeleted
- DeletedAt
- DeletedBy

