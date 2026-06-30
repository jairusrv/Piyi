# Piyí Hotfix - API HTTP Development

## Problema corregido

El API estaba redireccionando HTTP a HTTPS en desarrollo por `app.UseHttpsRedirection()`.

Eso hacía que Flutter terminara intentando conectarse a puertos dinámicos como:

```text
127.0.0.1:49710
10.28.28.228:41162
```

## Solución

En desarrollo NO se aplica HTTPS Redirection. En producción sí.

## Aplicar

Extraer sobre:

```powershell
C:\Users\jairo\Documents\Piyi
```

Luego ejecutar:

```powershell
dotnet build
dotnet run --project .\src\Piyi.API\Piyi.API.csproj --urls "http://0.0.0.0:5105"
```

## Para celular por USB con ADB reverse

Flutter queda usando:

```dart
static const String baseUrl = 'http://127.0.0.1:5105';
```

Ejecutar:

```powershell
adb reverse tcp:5105 tcp:5105
adb reverse --list
```
