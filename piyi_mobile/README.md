# Piyí - BETA Sprint 12

## Sesión persistente tipo Uber / DiDi

Objetivo:

El usuario NO debe iniciar sesión cada vez que abre la app.

Debe ir automáticamente al Home cuando existe token guardado.

Solo vuelve al login cuando:

- No existe token.
- El usuario toca Cerrar sesión.
- Más adelante: token expirado o servidor rechaza token.

## Incluye

- AuthTokenStore
- SessionManager
- SplashScreen inteligente
- Logout limpio
- Documentación

## Aplicar

Extraer sobre:

```powershell
C:\Users\jairo\Documents\Piyi\piyi_mobile
```

Luego:

```powershell
flutter clean
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
flutter pub get
flutter run
```
