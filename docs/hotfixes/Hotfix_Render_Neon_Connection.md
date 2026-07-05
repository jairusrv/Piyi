# Hotfix - Render API + Neon Database

## Objetivo

Conectar la app mobile beta a:

```text
https://piyi.onrender.com
```

y preparar el API para usar PostgreSQL en Neon mediante variables de entorno.

## Cambios incluidos

- `ApiConfig.baseUrl` ahora apunta por defecto a `https://piyi.onrender.com`.
- `appsettings.json` usa `Jwt:SecretKey`, que es la propiedad real esperada por `JwtSettings`.
- `Program.cs` registra `AddAuthorization()`.
- La base de datos Neon fue inicializada con las migraciones EF existentes.

## Migraciones aplicadas en Neon

```text
20260630005343_InitialCreate
20260630233648_BetaSchemaUpdate_Notifications_Businesses
20260701040301_BetaCatalogInformationalPro
20260701052458_BetaBusinessReviewsRatings
20260704071344_BetaSmartZoneNotifications
```

## Variables requeridas en Render

Configurar estas variables en el servicio API de Render:

```text
ASPNETCORE_ENVIRONMENT=Production
ConnectionStrings__DefaultConnection=Host=...;Port=5432;Database=...;Username=...;Password=...;SSL Mode=Require;Trust Server Certificate=true
Jwt__Issuer=Piyi.API
Jwt__Audience=Piyi.Mobile
Jwt__SecretKey=UN_SECRETO_LARGO_DE_32+_CARACTERES
Jwt__ExpirationMinutes=1440
```

No guardar la connection string real en el repositorio.
