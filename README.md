# Piyí - BETA Sprint 09

## Subida real de fotografías

Este sprint agrega carga real de imágenes al API y Flutter.

## Incluye

Backend:
- UploadsController
- POST /api/uploads/images
- Guardado local en wwwroot/uploads/images
- Retorna URL pública

Flutter:
- image_picker
- UploadsRepository
- CreatePetScreen con selección/subida de foto

## Aplicar backend

Extraer sobre:

```powershell
C:\Users\jairo\Documents\Piyi
```

IMPORTANTE: revisar Program.cs y agregar:

```csharp
app.UseStaticFiles();
```

Debe ir antes de `app.MapControllers();`.

## Aplicar Flutter

El contenido de `piyi_mobile` se copia sobre:

```powershell
C:\Users\jairo\Documents\Piyi\piyi_mobile
```

Luego:

```powershell
dotnet build
flutter pub get
flutter run
```
