# Hotfix - Render Dockerfile

## Problema

Render fallaba con:

```text
failed to solve: failed to read dockerfile: open Dockerfile: no such file or directory
```

## Causa

El repo no tenia un `Dockerfile` en la raiz, pero Render estaba configurado para construir el servicio usando Docker.

## Solucion

- Agregado `Dockerfile` multi-stage para publicar `src/Piyi.API`.
- Agregado `.dockerignore` para excluir Flutter, builds y archivos innecesarios del contexto Docker.
- Agregado `app.UseAuthentication()` antes de `app.UseAuthorization()`.
- Desactivado `UseHttpsRedirection()` para ejecucion detras del proxy TLS de Render.
- Limpieza del texto `/health` a `Piyí API`.
- Agregada guia `docs/deployment/Render_Neon_Free_Deploy.md`.
