# Sprint 21B - Stabilization REAL FIX

## Problema corregido

El proyecto tenía dos clases llamadas `PiyiBackButton`:

- `package:piyi_mobile/src/core/navigation/piyi_back_button.dart`
- `package:piyi_ui/src/widgets/piyi_back_button.dart`

Eso producía `ambiguous_import`.

## Solución

- Se elimina el archivo conflictivo de `piyi_mobile`.
- Se crea `PiyiAppBackButton`.
- Se reemplazan todas las referencias directas en pantallas internas.
- Se limpian imports rotos y duplicados.
