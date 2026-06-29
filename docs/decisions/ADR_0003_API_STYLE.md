# ADR 0003 - API Style

## Estado
Aprobado

## Contexto
Piyí requiere una API simple, consistente y fácil de consumir desde Flutter Mobile, Flutter Web Admin y futuras integraciones.

## Decisión
Usaremos REST con JSON y respuestas estandarizadas.

No usaremos GraphQL en el MVP.

No usaremos MediatR todavía.

No expondremos entidades directamente; siempre usaremos DTOs.

## Consecuencias
- La app móvil podrá integrarse más rápido.
- El Admin podrá consumir los mismos endpoints.
- El backend mantendrá una estructura simple.
- Será más fácil documentar con Swagger/OpenAPI.
