# Sprint 01.03 - User Profile

## Definition of Done

- `dotnet build` correcto.
- Swagger levanta.
- Usuario puede consultar su perfil.
- Usuario puede actualizar su perfil.
- Usuario puede cambiar contraseña.

## Endpoints

```text
GET /api/users/me
PUT /api/users/me
PUT /api/users/change-password
```

## Ejemplo PUT /api/users/me

```json
{
  "firstName": "Jairo",
  "lastName": "Rivera",
  "phoneNumber": "88888888",
  "photoUrl": null,
  "language": "es",
  "country": "Costa Rica",
  "timeZone": "America/Costa_Rica"
}
```

## Ejemplo PUT /api/users/change-password

```json
{
  "currentPassword": "Piyi12345!",
  "newPassword": "Piyi123456!"
}
```
