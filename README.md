# Piyí - Hotfix 20H Neon Connection Resolver

## Objetivo

Corregir Render para que el API use Neon y no `localhost:5432`.

## Aplicar

Extraer sobre:

```powershell
C:\Users\jairo\Documents\Piyi
```

Ejecutar:

```powershell
cd C:\Users\jairo\Documents\Piyi
powershell -ExecutionPolicy Bypass -File .\tools\Apply-Hotfix-20H.ps1
dotnet build /warnaserror
```

## Render Environment

Configura en Render:

```text
DATABASE_URL=postgresql://neondb_owner:TU_PASSWORD@ep-patient-queen-aiq482o8-pooler.c-4.us-east-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require
ASPNETCORE_ENVIRONMENT=Production
PIYI_ENABLE_SWAGGER=true
Jwt__Issuer=Piyi.API
Jwt__Audience=Piyi.Mobile
Jwt__SecretKey=PiyiBeta2026_SecretKey_Muy_Larga_Para_JWT_123456
Jwt__ExpirationMinutes=1440
```

Luego:

```text
Manual Deploy -> Clear build cache & deploy
```
