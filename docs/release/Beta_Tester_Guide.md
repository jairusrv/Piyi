# Piyí Beta Tester Guide

## Alcance de la beta

La primera beta debe probar solo los flujos principales:

- crear cuenta;
- iniciar sesion;
- registrar mascota;
- ver detalle de mascota;
- reportar mascota perdida;
- ver mascotas perdidas;
- reportar avistamiento;
- buscar negocios y servicios;
- validar que la app no se bloquee si el API responde con error.

## Fuera de alcance por ahora

- geocercas avanzadas;
- push notifications reales;
- pagos;
- suscripciones;
- proveedores Pro;
- administracion avanzada;
- diagnostico de dispositivos.

## Datos que se deben pedir a testers

- modelo de teléfono;
- version de Android o iOS;
- si pudo registrarse;
- si pudo iniciar sesion luego de cerrar y abrir la app;
- pantalla donde fallo;
- captura del error visible;
- pasos para reproducir.

## Checklist previo al envio del APK

```powershell
dotnet build

cd piyi_mobile
flutter pub get
flutter analyze --no-fatal-infos
flutter test
flutter build apk --release --dart-define=PIYI_API_BASE_URL=https://TU-API-PUBLICA
```

El APK queda normalmente en:

```text
piyi_mobile/build/app/outputs/flutter-apk/app-release.apk
```
