# Piyí - Sprint 03.05 Admin Developer Tools

## Objetivo

Agregar herramientas temporales de desarrollo para poder probar endpoints de administrador.

Incluye:

- Promover usuario a Admin por correo.
- Endpoint solo disponible en Development.

## Endpoint

```text
POST /api/dev/users/promote-admin
```

Body:

```json
{
  "email": "tu-correo@correo.com"
}
```

## Importante

Este controller queda protegido para ambiente Development. No debe usarse en producción.

## Cómo aplicar

Extraer sobre:

```powershell
C:\Users\jairo\Documents\Piyi
```

Luego:

```powershell
dotnet restore
dotnet build
dotnet run --project .\src\Piyi.API\Piyi.API.csproj
```

## Flujo de prueba

1. Registrar usuario.
2. Ejecutar `POST /api/dev/users/promote-admin`.
3. Hacer login nuevamente.
4. Usar token nuevo.
5. Probar endpoints `/api/admin/...`.
