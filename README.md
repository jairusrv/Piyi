# Piyí - BETA Sprint 16

## Perfil Público Profesional del Negocio

Este sprint convierte cada negocio/proveedor en una ficha pública más completa dentro de Piyí.

## Incluye Backend

- Entity `BusinessProfile`
- EF Configuration
- DTOs
- IBusinessProfileService
- BusinessProfileService
- BusinessProfilesController

## Incluye Flutter

- BusinessProfile model
- BusinessProfileRepository
- BusinessProfileController
- BusinessProfileScreen
- Patch para router
- Patch para abrir perfil desde BusinessDetail

## Aplicar Backend

Extraer sobre:

```powershell
C:\Users\jairo\Documents\Piyi
```

Aplicar parches manuales indicados:

```text
src/Piyi.Infrastructure/DependencyInjection.BUSINESS_PROFILE_PATCH.txt
src/Piyi.Infrastructure/Data/PiyiDbContext.BUSINESS_PROFILE_PATCH.txt
```

Luego:

```powershell
dotnet build
dotnet ef migrations add BetaBusinessPublicProfile --project .\src\Piyi.Infrastructure --startup-project .\src\Piyi.API
dotnet ef database update --project .\src\Piyi.Infrastructure --startup-project .\src\Piyi.API
```

## Aplicar Flutter

Los archivos dentro de `piyi_mobile` van sobre:

```powershell
C:\Users\jairo\Documents\Piyi\piyi_mobile
```

Luego aplicar:

```text
piyi_mobile/lib/src/app/app_router.business_profile_patch.txt
```

Después:

```powershell
flutter pub get
flutter run
```
