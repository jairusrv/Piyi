# Hotfix 20H - Neon Connection Resolver

Render estaba usando `localhost:5432` / `piyi_db`.

Este hotfix agrega `DatabaseConnectionStringFactory` para leer:

- `ConnectionStrings__DefaultConnection`
- `DATABASE_URL`
- `NEON_DATABASE_URL`
- `POSTGRES_URL`

También convierte URLs tipo:

```text
postgresql://user:pass@host/db?sslmode=require&channel_binding=require
```

a formato Npgsql.
