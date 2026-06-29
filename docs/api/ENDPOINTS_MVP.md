# Endpoints MVP - Piyí

## 1. Auth

| Método | Ruta | Protegido | Descripción |
|---|---|---:|---|
| POST | `/api/auth/register` | No | Registrar usuario |
| POST | `/api/auth/login` | No | Iniciar sesión |
| POST | `/api/auth/refresh-token` | Sí | Renovar token, futuro |
| GET | `/api/auth/me` | Sí | Obtener usuario autenticado |

---

## 2. Users

| Método | Ruta | Protegido | Descripción |
|---|---|---:|---|
| GET | `/api/users/me` | Sí | Perfil del usuario actual |
| PUT | `/api/users/me` | Sí | Actualizar perfil del usuario actual |
| DELETE | `/api/users/me` | Sí | Desactivar cuenta |

---

## 3. Pets

| Método | Ruta | Protegido | Descripción |
|---|---|---:|---|
| GET | `/api/pets` | Sí | Listar mis mascotas |
| POST | `/api/pets` | Sí | Crear mascota |
| GET | `/api/pets/{id}` | Sí | Obtener detalle de mascota |
| PUT | `/api/pets/{id}` | Sí | Actualizar mascota |
| DELETE | `/api/pets/{id}` | Sí | Eliminar mascota |
| POST | `/api/pets/{id}/share` | Sí | Compartir mascota con otro usuario, futuro |
| GET | `/api/pets/{id}/qr` | Sí | Obtener QR de la mascota |

---

## 4. Pet Vaccines

| Método | Ruta | Protegido | Descripción |
|---|---|---:|---|
| GET | `/api/pets/{petId}/vaccines` | Sí | Listar vacunas |
| POST | `/api/pets/{petId}/vaccines` | Sí | Agregar vacuna |
| PUT | `/api/pets/{petId}/vaccines/{id}` | Sí | Actualizar vacuna |
| DELETE | `/api/pets/{petId}/vaccines/{id}` | Sí | Eliminar vacuna |

---

## 5. Pet Reminders

| Método | Ruta | Protegido | Descripción |
|---|---|---:|---|
| GET | `/api/pets/{petId}/reminders` | Sí | Listar recordatorios |
| POST | `/api/pets/{petId}/reminders` | Sí | Crear recordatorio |
| PUT | `/api/pets/{petId}/reminders/{id}` | Sí | Actualizar recordatorio |
| POST | `/api/pets/{petId}/reminders/{id}/complete` | Sí | Marcar como completado |
| DELETE | `/api/pets/{petId}/reminders/{id}` | Sí | Eliminar recordatorio |

---

## 6. Businesses

| Método | Ruta | Protegido | Descripción |
|---|---|---:|---|
| GET | `/api/businesses/search` | No | Buscar negocios |
| GET | `/api/businesses/{id}` | No | Ver negocio |
| POST | `/api/businesses` | Sí | Crear/reclamar negocio |
| PUT | `/api/businesses/{id}` | Sí | Actualizar negocio propio |
| GET | `/api/business-types` | No | Listar tipos de negocio |

---

## 7. Reviews

| Método | Ruta | Protegido | Descripción |
|---|---|---:|---|
| GET | `/api/businesses/{businessId}/reviews` | No | Listar reseñas aprobadas |
| POST | `/api/businesses/{businessId}/reviews` | Sí | Crear reseña |
| DELETE | `/api/businesses/{businessId}/reviews/{id}` | Sí | Eliminar reseña propia |

---

## 8. Lost Pets

| Método | Ruta | Protegido | Descripción |
|---|---|---:|---|
| GET | `/api/lost-pets` | No | Listar mascotas perdidas activas |
| POST | `/api/lost-pets` | Sí | Reportar mascota perdida |
| GET | `/api/lost-pets/{id}` | No | Ver reporte |
| PUT | `/api/lost-pets/{id}` | Sí | Actualizar reporte propio |
| POST | `/api/lost-pets/{id}/mark-found` | Sí | Marcar como encontrada |
| DELETE | `/api/lost-pets/{id}` | Sí | Cerrar reporte |

---

## 9. Catalogs

| Método | Ruta | Protegido | Descripción |
|---|---|---:|---|
| GET | `/api/catalogs/species` | No | Listar especies |
| GET | `/api/catalogs/breeds?speciesId={id}` | No | Listar razas por especie |
| GET | `/api/catalogs/colors` | No | Listar colores, futuro |
