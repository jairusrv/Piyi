# BETA Sprint 12 - Sesión persistente

## Objetivo

Que Piyí se comporte como Uber/DiDi:

- Si ya estoy logueado, entro directo.
- Si cierro sesión, vuelvo al login.
- No debo escribir credenciales cada vez que abro la app.

## Archivos

- auth_token_store.dart
- session_manager.dart
- splash_screen.dart

## Pendiente recomendado

Agregar endpoint backend:

```text
GET /api/auth/me
```

para validar token contra servidor.

## Definition of Done

- Login exitoso guarda token.
- Cerrar y abrir app entra directo al Home.
- Cerrar sesión borra token.
- Después de cerrar sesión vuelve al Login.
