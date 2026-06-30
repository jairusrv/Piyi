# Piyí - Sprint 05.01 Flutter Mobile Foundation

## Objetivo

Crear la base inicial de la app móvil Flutter.

Este sprint incluye:

- Estructura de carpetas.
- Tema visual base de Piyí.
- Rutas principales.
- Cliente HTTP base.
- Configuración de API.
- Pantallas iniciales:
  - Splash
  - Login
  - Register
  - Home

## Cómo crear el proyecto Flutter

Desde:

```powershell
C:\Users\jairo\Documents\Piyi
```

Ejecutar:

```powershell
flutter create Piyi.Mobile
```

Luego copiar el contenido de este ZIP dentro de:

```powershell
C:\Users\jairo\Documents\Piyi\Piyi.Mobile
```

Después ejecutar:

```powershell
cd C:\Users\jairo\Documents\Piyi\Piyi.Mobile
flutter pub get
flutter run
```

## Paquetes usados

```yaml
flutter_riverpod
dio
go_router
flutter_secure_storage
google_fonts
```

## Nota

En Android emulator, `localhost` apunta al emulador, no a tu PC. Por eso usamos:

```text
http://10.0.2.2:5105
```

Para celular físico, luego cambiaremos la URL por la IP local de tu computadora o por el API publicado.
