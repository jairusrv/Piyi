# Hotfix 21A-7 - Global Back Button

## Motivo

El hotfix anterior solo modificaba `PiyiPageScaffold`, pero varias pantallas internas usan `Scaffold` y `AppBar` directamente.

## Solución

- Se crea `PiyiBackButton`.
- Se actualiza `PiyiPageScaffold`.
- Se agrega `leading: PiyiBackButton.fallbackHome(context)` a pantallas internas con `AppBar`.

## Pantallas omitidas

- home
- login
- register
- splash
- dashboard
- onboarding
