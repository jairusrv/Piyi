# Render + Neon Free Deploy

## Objetivo

Publicar el API de Piyí en Render usando Docker y PostgreSQL gratis en Neon.

## Render

Crear un **Web Service** desde el repositorio de GitHub.

Configuracion recomendada:

- Runtime: `Docker`
- Root Directory: vacio / raiz del repo
- Dockerfile Path: `Dockerfile`
- Instance type: `Free`
- Health check path: `/health`

Si Render muestra este error:

```text
failed to read dockerfile: open Dockerfile: no such file or directory
```

significa que el servicio esta apuntando a una carpeta donde no existe el `Dockerfile`. En este repo el `Dockerfile` debe estar en la raiz.

## Variables de entorno

Configurar en Render:

```text
ASPNETCORE_ENVIRONMENT=Production
ConnectionStrings__DefaultConnection=Host=...;Port=5432;Database=...;Username=...;Password=...;SSL Mode=Require;Trust Server Certificate=true
Jwt__Issuer=Piyi.API
Jwt__Audience=Piyi.Mobile
Jwt__SecretKey=CAMBIAR_POR_UN_SECRETO_LARGO_DE_AL_MENOS_32_CARACTERES
Jwt__ExpirationMinutes=1440
```

Importante: usar `Jwt__SecretKey`, no `Jwt__Key`.

La app mobile beta debe apuntar a:

```text
https://piyi.onrender.com
```

## Neon

Crear un proyecto PostgreSQL en Neon y copiar el connection string.

Para EF Core/Npgsql en Render, usar formato:

```text
Host=HOST_NEON;Port=5432;Database=DB;Username=USER;Password=PASSWORD;SSL Mode=Require;Trust Server Certificate=true
```

## Migraciones

Desde una maquina local con acceso al connection string:

```powershell
dotnet ef database update --project .\src\Piyi.Infrastructure --startup-project .\src\Piyi.API
```

## Prueba

Cuando Render termine el deploy:

```text
https://TU-SERVICIO.onrender.com/health
```

Debe responder:

```json
{
  "service": "Piyí API",
  "status": "OK"
}
```
