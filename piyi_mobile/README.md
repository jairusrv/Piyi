# Piyí - Sprint 05.13 Flutter Firebase Base

## Objetivo

Preparar Flutter para Firebase Cloud Messaging sin romper desarrollo local.

## Incluye

- Dependencias Firebase.
- Inicialización segura de Firebase.
- Servicio para obtener token FCM.
- Fallback a token DEV si Firebase no está configurado.
- Registro de dispositivo actualizado.

## Importante

Este sprint compila aunque Firebase aún no esté configurado oficialmente, porque tiene fallback.

Más adelante agregaremos:
- firebase_options.dart generado por FlutterFire CLI.
- google-services.json.
- permisos Android.
- recepción de notificaciones en foreground/background.

## Aplicar

Extraer sobre:

C:\Users\jairo\Documents\Piyi\piyi_mobile

Luego:

flutter pub get
flutter run
