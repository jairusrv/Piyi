# Piyí - Hotfix 16.1

Corrige:

- BusinessProfileService.cs error `List<string> ?? string[]`
- PiyiPageScaffold SafeArea.minimum con EdgeInsetsGeometry

## Aplicar

Extraer sobre:

```powershell
C:\Users\jairo\Documents\Piyi
```

Luego:

Backend:

```powershell
dotnet build
dotnet ef migrations add BetaBusinessPublicProfile --project .\src\Piyi.Infrastructure --startup-project .\src\Piyi.API
dotnet ef database update --project .\src\Piyi.Infrastructure --startup-project .\src\Piyi.API
```

Flutter:

```powershell
cd C:\Users\jairo\Documents\Piyi\piyi_mobile
flutter pub get
flutter run
```
