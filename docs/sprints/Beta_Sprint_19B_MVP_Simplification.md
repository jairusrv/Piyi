# Beta Sprint 19B - MVP Simplification

## Objetivo

Reducir el alcance de mascotas perdidas a un flujo MVP claro:

- publicar una mascota perdida;
- ver reportes activos;
- abrir detalle;
- reportar avistamiento;
- contactar al dueno;
- marcar como encontrada o cerrar el reporte.

Este sprint pausa la presion de producto alrededor de zonas seguras, geocercas y push notifications avanzadas. La infraestructura backend queda en el repositorio para no romper migraciones ni datos existentes, pero deja de ser el foco visible de la app.

## Cambios incluidos

- Corrige la validacion de sesion persistente en Flutter usando `AuthSession.isValid`.
- Agrega la dependencia `geocoding`, requerida por el servicio de ubicacion actual.
- Reemplaza el test inicial de Flutter que todavia apuntaba al template `MyApp`.
- Limpia `PiyiApp` y elimina texto con codificacion rota en el titulo de la app.
- Simplifica la pantalla de mascotas perdidas quitando filtros manuales por ciudad/provincia.
- Cambia el dashboard para enfocarse en mascotas, negocios y reportes simples.
- Pausa visualmente alertas por zona y push notifications en configuracion.

## Decision de producto

No eliminar todavia tablas, entidades ni endpoints de zona/push.

Motivo: ya existen migraciones y servicios relacionados. Borrarlos ahora puede causar ruido tecnico sin aportar valor inmediato. La decision correcta para este sprint es ocultar el alcance avanzado en UX y volver al flujo principal.

## Validacion

Backend:

```powershell
dotnet build
```

Flutter:

```powershell
cd piyi_mobile
flutter pub get
flutter analyze --no-fatal-infos
```

`flutter analyze` sin `--no-fatal-infos` todavia reporta avisos de estilo/deprecaciones preexistentes, pero no errores bloqueantes.

## Siguiente paso recomendado

Sprint 19C deberia enfocarse en pulir el flujo real:

- foto principal del reporte;
- boton de contacto directo;
- accion clara para marcar como encontrada;
- textos sin codificacion rota en pantallas visibles;
- opcion simple "cerca de mi" solo si el GPS esta disponible.
