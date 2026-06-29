# API Status Codes - Piyí

## Códigos principales

| Código | Uso |
|---:|---|
| 200 | Operación exitosa |
| 201 | Recurso creado |
| 400 | Validación fallida |
| 401 | No autenticado |
| 403 | No autorizado |
| 404 | Recurso no encontrado |
| 409 | Conflicto, por ejemplo email ya registrado |
| 500 | Error interno |

## Ejemplos

### 400 Bad Request

```json
{
  "success": false,
  "message": "La solicitud contiene errores de validación.",
  "data": null,
  "errors": [
    "El correo electrónico es requerido.",
    "La contraseña debe tener al menos 8 caracteres."
  ]
}
```

### 404 Not Found

```json
{
  "success": false,
  "message": "No se encontró el recurso solicitado.",
  "data": null,
  "errors": []
}
```

### 409 Conflict

```json
{
  "success": false,
  "message": "Ya existe un usuario registrado con este correo.",
  "data": null,
  "errors": []
}
```
