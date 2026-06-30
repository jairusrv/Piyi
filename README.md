# Piyí - Sprint 03.03 Admin Business Create

## Objetivo

Agregar endpoints protegidos para que un administrador pueda crear y actualizar negocios.

## Endpoints

```text
POST /api/admin/businesses
PUT  /api/admin/businesses/{id}
PUT  /api/admin/businesses/{id}/verify
PUT  /api/admin/businesses/{id}/activate
PUT  /api/admin/businesses/{id}/deactivate
```

Requieren JWT con rol `Admin`.

## Cómo aplicar

Extraer sobre:

```powershell
C:\Users\jairo\Documents\Piyi
```

Luego:

```powershell
dotnet restore
dotnet build
```

## Nota

Si todavía no tienes un usuario Admin, luego agregaremos endpoint/seed temporal para promover tu usuario.
