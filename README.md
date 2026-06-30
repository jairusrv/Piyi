# Piyí - Sprint 04.07 Push Queue Processor

## Objetivo

Agregar procesador base de cola push.

Este sprint todavía NO integra Firebase real. Agrega:

- `IPushSender`
- `FakePushSender`
- `IPushQueueProcessorService`
- Procesamiento de cola pendiente
- Marcado de envíos como `Sent` o `Failed`
- Endpoint Development para procesar manualmente

## Endpoints Development

```text
POST /api/dev/push-queue/process
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

## Próximo paso

Después de esto podemos integrar Firebase Admin SDK real o iniciar Flutter Mobile.
