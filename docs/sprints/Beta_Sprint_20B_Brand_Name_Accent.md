# Beta Sprint 20B - Brand Name Accent

## Objetivo

Corregir la decision de marca antes de enviar la app a testers.

Internamente el proyecto sigue llamandose `Piyi` para codigo, paquetes, rutas, clases, carpetas y configuracion tecnica. Visual y foneticamente, la app se presenta como **Piyí**.

## Decision

- Nombre tecnico: `Piyi`
- Nombre publico/visual: `Piyí`
- Package Android: `com.piyi.mobile`
- Clases Flutter: `PiyiApp`, `PiyiTheme`, `PiyiColors`, etc.
- Textos visibles: `Piyí`

## Cambios incluidos

- `AppConfig.technicalName = 'Piyi'`
- `AppConfig.displayName = 'Piyí'`
- `MaterialApp.title` usa `AppConfig.displayName`.
- Android `android:label` usa `Piyí`.
- Splash y login muestran `Piyí`.
- Dashboard usa `Piyí Beta`.
- Guia de testers usa `Piyí`.

## Nota

Este sprint no cambia endpoints, base de datos, namespaces, solucion .NET ni package identifiers. Solo corrige la marca visible para testers.
