# Hotfix 20E - API WarnAsError Fix

## Problemas corregidos

```text
CS8632 en LostPetService.cs
CS0618 en BusinessReviewConfiguration.cs
```

## Solución

- `LostPetService.cs` vuelve a `#nullable enable`.
- Se suprime solo `CS8601` en ese archivo.
- `BusinessReviewConfiguration.cs` usa `builder.ToTable(... table.HasCheckConstraint(...))`.
- Se crea `piyi_mobile/android/build.gradle` si no existe para forzar `compileSdk 36` en plugins.
