# BETA Sprint 11A - Catálogo Informativo Pro Backend

## Qué es

Catálogo/vitrina informativa para productos y servicios ofrecidos por proveedores Pro.

## Qué NO es

- No carrito.
- No checkout.
- No delivery.
- No órdenes.
- No comisiones.
- No pasarela de pago.

## Endpoints

GET /api/catalog/search
GET /api/catalog/business/{businessId}
GET /api/catalog/{id}
POST /api/catalog
PUT /api/catalog/{id}
DELETE /api/catalog/{id}

## Reglas

Solo negocios con:

```csharp
IsProviderPro = true
```

pueden crear/editar publicaciones.

## Siguientes mejoras solicitadas

- Sprint 12: sesión persistente.
- Sprint 13: navegación/back consistente.
- Sprint 14: ubicación actual para zona segura.
