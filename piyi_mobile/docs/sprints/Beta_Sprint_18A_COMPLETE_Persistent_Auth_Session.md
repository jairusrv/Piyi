# BETA Sprint 18A COMPLETO - Sesión persistente

## Archivos reemplazados

- lib/src/core/storage/secure_storage_service.dart
- lib/src/core/network/api_client.dart
- lib/src/features/auth/data/auth_repository.dart
- lib/src/features/auth/data/auth_session.dart
- lib/src/features/auth/data/auth_session_manager.dart
- lib/src/features/splash/presentation/splash_screen.dart

## Sin parches manuales

Este ZIP no trae `.patch.txt`.

## Definition of Done

- Login guarda token en varias claves compatibles.
- Splash revisa token guardado.
- Si hay token, va al Home.
- Si no hay token, va al Login.
- Logout borra todas las claves.
- Dio agrega Authorization Bearer automáticamente.
