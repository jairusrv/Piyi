FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY Directory.Build.props Directory.Packages.props global.json Piyi.sln ./
COPY src/Piyi.API/Piyi.API.csproj src/Piyi.API/
COPY src/Piyi.Application/Piyi.Application.csproj src/Piyi.Application/
COPY src/Piyi.Contracts/Piyi.Contracts.csproj src/Piyi.Contracts/
COPY src/Piyi.Domain/Piyi.Domain.csproj src/Piyi.Domain/
COPY src/Piyi.Infrastructure/Piyi.Infrastructure.csproj src/Piyi.Infrastructure/
COPY src/Piyi.Shared/Piyi.Shared.csproj src/Piyi.Shared/

RUN dotnet restore src/Piyi.API/Piyi.API.csproj

COPY src ./src
RUN dotnet publish src/Piyi.API/Piyi.API.csproj -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

ENV ASPNETCORE_ENVIRONMENT=Production

COPY --from=build /app/publish .

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "dotnet Piyi.API.dll --urls http://0.0.0.0:${PORT:-8080}"]
