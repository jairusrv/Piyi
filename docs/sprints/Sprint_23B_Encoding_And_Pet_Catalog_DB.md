# Sprint 23B — Encoding + Catálogo de mascotas en BD

## Incluye

- Corrección dirigida de mojibake doble/triple.
- Seed idempotente de especies y razas.
- Migraciones automáticas al iniciar el API.
- Catálogo cargado desde PostgreSQL mediante:
  - `GET /api/catalogs/species`
  - `GET /api/catalogs/species/{speciesId}/breeds`

## Especies

Perro, gato, ave, pez, conejo, hámster, cobaya, hurón, tortuga,
lagarto/reptil, serpiente, caballo, mini pig, erizo, chinchilla,
jerbo, rata doméstica y ratón doméstico.

## Aplicar

```powershell
cd C:\Users\jairo\Documents\Piyi
.\tools\Apply-Sprint-23B.bat
```

Luego subir a GitHub y desplegar Render.
