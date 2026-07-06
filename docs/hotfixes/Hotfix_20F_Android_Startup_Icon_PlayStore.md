# Hotfix 20F - Android Startup + Icon + Play Store

## Incluye

- Íconos Android generados desde la imagen aprobada.
- Ícono Play Store 512x512.
- Feature graphic 1024x500.
- Promo graphic 180x120.
- Textos para Play Store.
- `strings.xml` con `app_name = Piyí`.
- `AndroidManifest.xml` usando `@string/app_name`.
- Firebase desactivado por defecto en beta para evitar bloqueo de arranque.
- `gradle.properties` limpio sin flags viejos.

## Firebase

Por defecto queda desactivado:

```text
PIYI_ENABLE_FIREBASE=false
```

Para activarlo más adelante:

```powershell
flutter run --dart-define=PIYI_ENABLE_FIREBASE=true
```

## API

Usar:

```powershell
flutter run --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com
```
