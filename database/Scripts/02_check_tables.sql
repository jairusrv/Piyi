-- Después de ejecutar la migración, puedes validar tablas con:

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
