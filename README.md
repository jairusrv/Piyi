# Piyí - BETA Sprint 19A COMPLETO

## Notificaciones inteligentes por zona

Base para alertar cuando existan mascotas perdidas cerca de la zona segura del usuario.

## Aplicar

Extraer sobre:

```powershell
C:\Users\jairo\Documents\Piyi
```

Backend:

```powershell
dotnet build
dotnet ef migrations add BetaSmartZoneNotifications --project .\src\Piyi.Infrastructure --startup-project .\src\Piyi.API
dotnet ef database update --project .\src\Piyi.Infrastructure --startup-project .\src\Piyi.API
```

Flutter:

```powershell
cd C:\Users\jairo\Documents\Piyi\piyi_mobile
flutter pub get
flutter run
```
