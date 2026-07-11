# Piyí — Hotfix 23B-1

Corrige:

- `surface:` duplicado en `app_theme.dart`.
- `PiyiDbContext` no reconocido en `Program.cs`.
- Import faltante en `PetCatalogSeeder23B.cs`.
- Seed 23B ejecutado después de migraciones.
- Health check con texto correcto `Piyí API`.

## Aplicar

Extraer sobre:

```text
C:\Users\jairo\Documents\Piyi
```

Validar:

```powershell
cd C:\Users\jairo\Documents\Piyi
.\tools\Validate-Hotfix-23B-1.bat
```

Luego:

```powershell
git add .
git commit -m "Fix Sprint 23B compile theme and catalog seed"
git push
```

En Render:

```text
Manual Deploy
Clear build cache & deploy
```

Verificar:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\Verify-Pet-Catalog-23B.ps1
```
