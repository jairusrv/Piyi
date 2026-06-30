# Sprint 02.01 - Pets Base

## Definition of Done

- Build correcto.
- Swagger levanta.
- Endpoints protegidos por JWT.
- Usuario puede crear mascota.
- Usuario puede listar solo sus mascotas.
- Usuario puede editar solo sus mascotas.
- Usuario puede eliminar solo sus mascotas con soft delete.

## Ejemplo CreatePetRequest

```json
{
  "name": "Piyí",
  "speciesId": "REEMPLAZAR_GUID_ESPECIE",
  "breedId": null,
  "color": "Café",
  "birthDate": "2023-01-15",
  "sex": "Female",
  "weightKg": 8.5,
  "isSterilized": true,
  "microchipNumber": null,
  "photoUrl": null
}
```
