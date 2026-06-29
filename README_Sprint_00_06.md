# Piyí - Sprint 00.06 Core Domain + Infrastructure

## Cómo aplicar este paquete

Extrae el ZIP sobre la raíz actual del proyecto:

```powershell
C:\Users\jairo\Documents\Piyi
```

Acepta reemplazar archivos cuando Windows lo solicite.

## Validar compilación

```powershell
cd C:\Users\jairo\Documents\Piyi
dotnet restore
dotnet build
```

## Levantar PostgreSQL local

```powershell
cd C:\Users\jairo\Documents\Piyi\docker
docker compose up -d
```

## Crear primera migración

Si no tienes la herramienta EF instalada:

```powershell
dotnet tool install --global dotnet-ef
```

Luego ejecuta desde la raíz:

```powershell
dotnet ef migrations add InitialCreate --project .\src\Piyi.Infrastructure\Piyi.Infrastructure.csproj --startup-project .\src\Piyi.API\Piyi.API.csproj --output-dir Data\Migrations
```

## Aplicar migración

```powershell
dotnet ef database update --project .\src\Piyi.Infrastructure\Piyi.Infrastructure.csproj --startup-project .\src\Piyi.API\Piyi.API.csproj
```

## Ejecutar API

```powershell
dotnet run --project .\src\Piyi.API\Piyi.API.csproj
```

Swagger:

```text
https://localhost:7105/swagger
```
