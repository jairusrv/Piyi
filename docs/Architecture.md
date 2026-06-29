# Piyí Architecture

Estructura inicial por capas:

- Piyi.API: entrada HTTP.
- Piyi.Application: casos de uso.
- Piyi.Domain: entidades y reglas del dominio.
- Piyi.Infrastructure: persistencia, JWT, servicios externos.
- Piyi.Contracts: DTOs públicos.
- Piyi.Shared: utilidades compartidas.

Regla: los controllers no contienen lógica de negocio.
