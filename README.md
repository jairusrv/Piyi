# Piyí - Sprint 01.03 User Profile

## Objetivo

Completar el módulo base de usuario autenticado.

Incluye:

- `GET /api/users/me`
- `PUT /api/users/me`
- `PUT /api/users/change-password`

## Cómo aplicar

Extraer este ZIP sobre:

```powershell
C:\Users\jairo\Documents\Piyi
```

Luego ejecutar:

```powershell
dotnet restore
dotnet build
dotnet run --project .\src\Piyi.API\Piyi.API.csproj
```

## Pruebas

1. Registrar usuario en `/api/auth/register`.
2. Iniciar sesión en `/api/auth/login`.
3. Copiar token.
4. En Swagger usar `Authorize` con:

```text
Bearer TU_TOKEN
```

5. Probar:

```text
GET /api/users/me
PUT /api/users/me
PUT /api/users/change-password
```

## Nota

Este sprint depende de que Sprint 01.01.1 ya esté aplicado.
