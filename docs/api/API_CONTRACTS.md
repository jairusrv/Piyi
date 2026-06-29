# API Contracts - Piyí MVP

## Base URL local

```text
https://localhost:7105/api
```

## Convenciones generales

### Autenticación
Los endpoints protegidos usan JWT:

```http
Authorization: Bearer <token>
```

### Formato estándar de respuesta

```json
{
  "success": true,
  "message": "Operación realizada correctamente.",
  "data": {},
  "errors": []
}
```

### Formato estándar de error

```json
{
  "success": false,
  "message": "No se pudo completar la operación.",
  "data": null,
  "errors": [
    "Detalle del error"
  ]
}
```

## Versionado

Para el MVP usaremos rutas simples:

```text
/api/auth
/api/users
/api/pets
```

Más adelante podremos agregar versionado:

```text
/api/v1/pets
```

## Idioma de mensajes
Los mensajes públicos de la API estarán inicialmente en español.

## Fechas
Todas las fechas se manejarán en UTC a nivel de backend.

## IDs
Todos los IDs serán UUID/GUID.

## Soft delete
Los registros principales no se eliminarán físicamente; se marcarán como eliminados.
