# BETA Sprint 18A - Autenticación y sesión persistente

## Objetivo

Que el usuario no tenga que iniciar sesión cada vez que abre la app.

## Flujo

Splash -> existe token -> Home  
Splash -> no existe token -> Login  
Logout -> borra token -> Login

## Definition of Done

- Login guarda token.
- Cerrar app y abrir vuelve al Home.
- Logout borra sesión.
- Después de logout vuelve al Login.
- Dio agrega Authorization automáticamente.
