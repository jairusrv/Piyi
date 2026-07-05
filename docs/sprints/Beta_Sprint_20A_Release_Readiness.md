# Beta Sprint 20A - Release Readiness

## Objetivo

Preparar Piyí para una primera ronda de testers sin agregar features nuevas.

El foco de este sprint es reducir friccion antes de distribuir el APK:

- configuracion del API por ambiente;
- herramientas dev ocultas por defecto;
- textos visibles limpios;
- errores mas amigables;
- version beta identificable;
- checklist claro de publicacion.

## Cambios incluidos

- Agrega `AppConfig` con nombre tecnico, nombre visual y flag `PIYI_ENABLE_DEV_TOOLS`.
- Cambia `ApiConfig.baseUrl` para usar `--dart-define=PIYI_API_BASE_URL=...`.
- Oculta rutas de dispositivos y diagnostico push salvo que se active `PIYI_ENABLE_DEV_TOOLS=true`.
- Actualiza version Flutter a `0.2.0+20`.
- Cambia Android `applicationId` a `com.piyi.mobile`.
- Limpia textos de login, registro, splash, home y configuracion.
- Mejora mensajes de error para evitar excepciones tecnicas visibles a testers.
- Mantiene `usesCleartextTraffic=true` para permitir pruebas locales, pero recomienda API HTTPS para testers externos.

## Comandos

Desarrollo local:

```powershell
cd piyi_mobile
flutter pub get
flutter run --dart-define=PIYI_API_BASE_URL=http://127.0.0.1:5105
```

APK beta contra API publicado:

```powershell
cd piyi_mobile
flutter pub get
flutter build apk --release --dart-define=PIYI_API_BASE_URL=https://TU-API-PUBLICA
```

APK beta con herramientas dev visibles:

```powershell
flutter build apk --release `
  --dart-define=PIYI_API_BASE_URL=https://TU-API-PUBLICA `
  --dart-define=PIYI_ENABLE_DEV_TOOLS=true
```

## Pendiente antes de testers externos

- Publicar API y PostgreSQL en staging.
- Confirmar CORS y JWT en ambiente staging.
- Reemplazar `REEMPLAZAR_GOOGLE_MAPS_API_KEY` si se probaran mapas.
- Definir firma real de Android antes de Play Internal Testing.
- Probar flujo completo en telefono fisico.
