# Piyí - Sprint 04.06 Notifications Queue

## Objetivo

Agregar base de notificaciones internas y cola de envíos push.

Este sprint NO envía Firebase real todavía. Prepara:

- Notificaciones internas del usuario.
- Cola de push notifications.
- Generación de alertas para mascotas perdidas usando candidatos por zona.
- Consulta de mis notificaciones.
- Marcar como leída.

## Nuevas entidades

```text
UserNotification
PushNotificationQueue
```

## Endpoints protegidos

```text
GET /api/users/me/notifications
PUT /api/users/me/notifications/{notificationId}/read
```

## Endpoints Development

```text
POST /api/dev/lost-pets/{lostPetId}/generate-alerts
GET  /api/dev/push-queue/pending
```

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
