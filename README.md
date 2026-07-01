# Piyí - Sprint 08B

## Marcadores de mascotas y negocios

Incluye:
- Endpoints backend /api/map/lost-pets y /api/map/businesses
- DTOs
- Service
- Controller
- Repository Flutter
- Marcadores en Google Maps

Aplicar backend sobre:
C:\Users\jairo\Documents\Piyi

Aplicar Flutter sobre:
C:\Users\jairo\Documents\Piyi\piyi_mobile

Luego:
dotnet build
dotnet ef migrations add BetaMapEndpoints --project .\src\Piyi.Infrastructure --startup-project .\src\Piyi.API
dotnet ef database update --project .\src\Piyi.Infrastructure --startup-project .\src\Piyi.API
flutter pub get
flutter run
