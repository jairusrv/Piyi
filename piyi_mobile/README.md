# Piyí - BETA Sprint 18A COMPLETO

## Sesión persistente lista, sin parches manuales

Este ZIP ya trae los archivos finales. No hay archivos `.patch.txt`.

## Aplicar

Extraer sobre:

```powershell
C:\Users\jairo\Documents\Piyi\piyi_mobile
```

Luego ejecutar:

```powershell
cd C:\Users\jairo\Documents\Piyi\piyi_mobile
flutter clean
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
flutter pub get
flutter run
```

## Prueba

1. Inicia sesión.
2. Cierra la app completamente.
3. Ábrela otra vez.
4. Debe entrar directo al Home.
5. Toca cerrar sesión.
6. Debe volver al Login.
