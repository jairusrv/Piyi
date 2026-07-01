# BETA Sprint 09 - Image Uploads

## Definition of Done

- API recibe imagen multipart.
- API guarda imagen en wwwroot/uploads/images.
- API retorna URL pública.
- Flutter permite elegir foto.
- Flutter sube foto antes de crear mascota.
- Mascota queda con photoUrl real.

## Nota

Para servir archivos estáticos, Program.cs debe tener:

```csharp
app.UseStaticFiles();
```

antes de:

```csharp
app.MapControllers();
```
