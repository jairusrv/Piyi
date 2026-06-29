# Request / Response Examples - Piyí

## POST /api/auth/register

### Request

```json
{
  "firstName": "Jairo",
  "lastName": "Rivera",
  "email": "jairo@example.com",
  "phone": "+50688888888",
  "password": "Password123!"
}
```

### Response

```json
{
  "success": true,
  "message": "Usuario registrado correctamente.",
  "data": {
    "userId": "c4a0c4e2-81a9-4c80-b3ff-b36cb7ec8241",
    "email": "jairo@example.com",
    "token": "jwt-token"
  },
  "errors": []
}
```

---

## POST /api/auth/login

### Request

```json
{
  "email": "jairo@example.com",
  "password": "Password123!"
}
```

### Response

```json
{
  "success": true,
  "message": "Inicio de sesión correcto.",
  "data": {
    "token": "jwt-token",
    "expiresAt": "2026-06-29T23:59:59Z",
    "user": {
      "id": "c4a0c4e2-81a9-4c80-b3ff-b36cb7ec8241",
      "fullName": "Jairo Rivera",
      "email": "jairo@example.com"
    }
  },
  "errors": []
}
```

---

## POST /api/pets

### Request

```json
{
  "name": "Rocky",
  "speciesId": "11111111-1111-1111-1111-111111111111",
  "breedId": null,
  "birthDate": "2022-05-10",
  "sex": "MALE",
  "color": "Café",
  "weightKg": 12.5
}
```

### Response

```json
{
  "success": true,
  "message": "Mascota creada correctamente.",
  "data": {
    "id": "22222222-2222-2222-2222-222222222222",
    "name": "Rocky",
    "qrCode": {
      "code": "PIYI-9K2A7F",
      "publicUrl": "https://piyi.app/p/PIYI-9K2A7F"
    }
  },
  "errors": []
}
```

---

## GET /api/businesses/search?type=VETERINARY&city=Cartago

### Response

```json
{
  "success": true,
  "message": "Negocios encontrados.",
  "data": [
    {
      "id": "33333333-3333-3333-3333-333333333333",
      "name": "Veterinaria Central",
      "businessType": "Veterinaria",
      "city": "Cartago",
      "rating": 4.8,
      "latitude": 9.8644,
      "longitude": -83.9194,
      "phone": "+50622222222",
      "whatsApp": "+50688888888"
    }
  ],
  "errors": []
}
```
