# Piyí - Sprint 02.01 Pets Base

## Objetivo

Implementar el primer módulo central de Piyí: mascotas.

Incluye:

- Crear mascota.
- Listar mis mascotas.
- Ver detalle de mascota.
- Actualizar mascota.
- Eliminar mascota con soft delete.

## Endpoints

```text
GET    /api/pets
GET    /api/pets/{id}
POST   /api/pets
PUT    /api/pets/{id}
DELETE /api/pets/{id}
```

Todos requieren JWT.

## Cómo aplicar

Extraer sobre:

```powershell
C:\Users\jairo\Documents\Piyi
```

Luego:

```powershell
dotnet restore
dotnet build
```

## Prueba manual

1. Registrar usuario.
2. Login.
3. Autorizar Swagger con Bearer Token.
4. Crear una mascota.
5. Listar mascotas.
6. Editar mascota.
7. Eliminar mascota.
