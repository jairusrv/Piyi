# Piyí - Sprint 00.05.1 Foundation

Este paquete reinicia la solución con una estructura limpia y profesional.

## Requisitos

- .NET 8 SDK
- Visual Studio 2022 / VS Code / Rider
- Docker Desktop opcional para PostgreSQL

## Instalación recomendada

1. Respaldar la carpeta actual `C:\Users\jairo\Documents\Piyi`.
2. Crear una carpeta limpia: `C:\Users\jairo\Documents\Piyi`.
3. Copiar el contenido de este ZIP dentro de esa carpeta.
4. Abrir PowerShell en `C:\Users\jairo\Documents\Piyi`.
5. Ejecutar:

```powershell
dotnet restore
dotnet build
dotnet run --project .\src\Piyi.API\Piyi.API.csproj
```

Swagger debe abrir en:

```text
https://localhost:7105/swagger
```

Endpoint de prueba:

```text
https://localhost:7105/health
https://localhost:7105/api/system/ping
```

## PostgreSQL opcional

```powershell
cd docker
docker compose up -d
```

## Nota importante

Este sprint NO contiene todavía las entidades completas. Su objetivo es dejar la base limpia y compilable.
El siguiente sprint será `00.06 Core Domain`, construido sobre esta estructura.
