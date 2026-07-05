# Hotfix 20D - Compile Release Fix

## Motivo

El build fallaba por:

```text
CS0618 HasCheckConstraint obsoleto
CS8601 nullable warning en LostPetService
geocoding_android compilando contra android-33
Kotlin Gradle Plugin aplicado en app/build.gradle
```

## Solución

- EF Core: `HasCheckConstraint` se configura ahora dentro de `ToTable`.
- `LostPetService.cs`: se desactiva nullable warning localmente con `#nullable disable`.
- Android:
  - `compileSdk = 36` global para plugins.
  - Se elimina `id "kotlin-android"` del app module.
  - Se suprimen warnings Java de opciones obsoletas.
