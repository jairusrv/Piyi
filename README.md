# Piyí - Hotfix 17.1

Corrige:

```text
User no contiene una definición para FullName
```

El sistema de reseñas ahora usa `User.Email` como nombre visible temporal.

## Aplicar

Extraer sobre:

```powershell
C:\Users\jairo\Documents\Piyi
```

Luego:

```powershell
dotnet build
dotnet ef migrations add BetaBusinessReviewsRatings --project .\src\Piyi.Infrastructure --startup-project .\src\Piyi.API
dotnet ef database update --project .\src\Piyi.Infrastructure --startup-project .\src\Piyi.API
```
