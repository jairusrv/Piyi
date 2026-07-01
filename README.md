# Piyí - BETA Sprint 17

## Sistema de Calificaciones y Reseñas

Incluye backend + Flutter base para reseñas de negocios.

## Funciones

- Calificación 1 a 5 estrellas.
- Comentario.
- Fotos opcionales.
- Respuesta del negocio.
- Reportar reseña inapropiada.
- Promedio automático por negocio.
- Listado público de reseñas.

## Aplicar Backend

Extraer sobre:

```powershell
C:\Users\jairo\Documents\Piyi
```

Agregar parches:

```text
src/Piyi.Infrastructure/DependencyInjection.REVIEWS_PATCH.txt
src/Piyi.Infrastructure/Data/PiyiDbContext.REVIEWS_PATCH.txt
```

Luego:

```powershell
dotnet build
dotnet ef migrations add BetaBusinessReviewsRatings --project .\src\Piyi.Infrastructure --startup-project .\src\Piyi.API
dotnet ef database update --project .\src\Piyi.Infrastructure --startup-project .\src\Piyi.API
```

## Aplicar Flutter

Los archivos dentro de `piyi_mobile` van sobre:

```powershell
C:\Users\jairo\Documents\Piyi\piyi_mobile
```

Aplicar patch:

```text
piyi_mobile/lib/src/features/business_profiles/presentation/business_profile_reviews_patch.txt
```

Luego:

```powershell
flutter pub get
flutter run
```
