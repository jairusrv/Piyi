$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Sprint 21B REAL FIX..." -ForegroundColor Cyan

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Save-NoBom($path, $content) {
    [System.IO.File]::WriteAllText((Resolve-Path $path).Path, $content, $utf8NoBom)
}

# 1) Normalizar archivos base incluidos.
$baseFiles = @(
  ".\piyi_mobile\lib\src\core\navigation\piyi_app_back_button.dart",
  ".\piyi_mobile\packages\piyi_ui\lib\src\widgets\piyi_page_scaffold.dart"
)

foreach ($file in $baseFiles) {
    if (Test-Path $file) {
        $content = [System.IO.File]::ReadAllText((Resolve-Path $file).Path)
        Save-NoBom $file $content
        Write-Host "OK base:" $file -ForegroundColor Green
    }
}

# 2) Eliminar archivo anterior conflictivo si existe.
$oldBack = ".\piyi_mobile\lib\src\core\navigation\piyi_back_button.dart"
if (Test-Path $oldBack) {
    Remove-Item $oldBack -Force
    Write-Host "OK: eliminado piyi_back_button.dart conflictivo." -ForegroundColor Green
}

# 3) Corregir imports y referencias en todos los Dart.
$dartFiles = Get-ChildItem ".\piyi_mobile\lib" -Recurse -Filter "*.dart"

foreach ($file in $dartFiles) {
    $path = $file.FullName
    $content = Get-Content $path -Raw
    $original = $content

    # Remover imports viejos/rotos del back button.
    $content = [regex]::Replace($content, "(?m)^\s*import\s+['""][^'""]*piyi_back_button\.dart['""];\s*\r?\n", "")

    # Reemplazar nombre conflictivo.
    $content = $content -replace "PiyiBackButton\.fallbackHome\(context\)", "PiyiAppBackButton.fallbackHome(context)"
    $content = $content -replace "PiyiBackButton\(", "PiyiAppBackButton("

    # Agregar import correcto si usa PiyiAppBackButton.
    if ($content -match "PiyiAppBackButton" -and $content -notmatch "piyi_app_back_button\.dart") {
        if ($content -match "import\s+'package:flutter/material.dart';") {
            $content = $content -replace "import\s+'package:flutter/material.dart';",
                "import 'package:flutter/material.dart';`r`nimport 'package:piyi_mobile/src/core/navigation/piyi_app_back_button.dart';"
        }
        elseif ($content -match 'import\s+"package:flutter/material.dart";') {
            $content = $content -replace 'import\s+"package:flutter/material.dart";',
                "import `"package:flutter/material.dart`";`r`nimport 'package:piyi_mobile/src/core/navigation/piyi_app_back_button.dart';"
        }
        else {
            $content = "import 'package:piyi_mobile/src/core/navigation/piyi_app_back_button.dart';`r`n$content"
        }
    }

    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
        Write-Host "OK Dart back/import:" $path -ForegroundColor Green
    }
}

# 4) Agregar back button a pantallas internas que aún no lo tengan.
$screenFiles = Get-ChildItem ".\piyi_mobile\lib\src\features" -Recurse -Filter "*.dart" | Where-Object {
    $_.FullName -match "screen\.dart$" -and
    $_.Name -notmatch "home|login|register|splash|dashboard|welcome|onboarding"
}

foreach ($file in $screenFiles) {
    $path = $file.FullName
    $content = Get-Content $path -Raw
    $original = $content

    if ($content -notmatch "AppBar\s*\(") {
        continue
    }

    if ($content -notmatch "PiyiAppBackButton\.fallbackHome" -and $content -notmatch "AppBar\s*\(\s*leading\s*:") {
        if ($content -notmatch "piyi_app_back_button\.dart") {
            if ($content -match "import\s+'package:flutter/material.dart';") {
                $content = $content -replace "import\s+'package:flutter/material.dart';",
                    "import 'package:flutter/material.dart';`r`nimport 'package:piyi_mobile/src/core/navigation/piyi_app_back_button.dart';"
            } else {
                $content = "import 'package:piyi_mobile/src/core/navigation/piyi_app_back_button.dart';`r`n$content"
            }
        }

        $content = [regex]::Replace(
            $content,
            "AppBar\s*\(\s*",
            "AppBar(`r`n        leading: PiyiAppBackButton.fallbackHome(context),`r`n        ",
            1
        )
    }

    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
        Write-Host "OK back agregado:" $path -ForegroundColor Green
    }
}

# 5) Limpieza específica de register_screen.
$register = ".\piyi_mobile\lib\src\features\auth\presentation\register_screen.dart"
if (Test-Path $register) {
    $content = Get-Content $register -Raw

    # Remover imports duplicados de phone field.
    $content = [regex]::Replace($content, "(?m)^\s*import\s+['""][^'""]*piyi_country_phone_field\.dart['""];\s*\r?\n", "")

    # Agregar un único import solo si realmente se usa el widget.
    if ($content -match "PiyiCountryPhoneField" -and $content -notmatch "package:piyi_mobile/src/core/widgets/piyi_country_phone_field.dart") {
        if ($content -match "import\s+'package:flutter/material.dart';") {
            $content = $content -replace "import\s+'package:flutter/material.dart';",
                "import 'package:flutter/material.dart';`r`nimport 'package:piyi_mobile/src/core/widgets/piyi_country_phone_field.dart';"
        } else {
            $content = "import 'package:piyi_mobile/src/core/widgets/piyi_country_phone_field.dart';`r`n$content"
        }
    }

    # Si el widget no se logró insertar, no dejar import muerto.
    if ($content -notmatch "PiyiCountryPhoneField") {
        $content = [regex]::Replace($content, "(?m)^\s*import\s+'package:piyi_mobile/src/core/widgets/piyi_country_phone_field\.dart';\s*\r?\n", "")
    }

    [System.IO.File]::WriteAllText((Resolve-Path $register).Path, $content, $utf8NoBom)
    Write-Host "OK: register_screen imports limpiados." -ForegroundColor Green
}

# 6) Revisar pubspec para package_info compatible.
$pubspec = ".\piyi_mobile\pubspec.yaml"
if (Test-Path $pubspec) {
    $content = Get-Content $pubspec -Raw
    $content = $content -replace 'package_info_plus:\s*\^[0-9]+\.[0-9]+\.[0-9]+', 'package_info_plus: ^10.2.0'
    $content = $content -replace 'device_info_plus:\s*\^[0-9]+\.[0-9]+\.[0-9]+', 'device_info_plus: ^13.2.0'
    $content = $content -replace 'flutter_secure_storage:\s*\^[0-9]+\.[0-9]+\.[0-9]+', 'flutter_secure_storage: ^10.3.1'
    Save-NoBom $pubspec $content
    Write-Host "OK: pubspec dependencias revisadas." -ForegroundColor Green
}

Write-Host ""
Write-Host "Sprint 21B REAL FIX aplicado." -ForegroundColor Green
Write-Host "Ejecuta ahora:" -ForegroundColor Cyan
Write-Host "cd .\piyi_mobile"
Write-Host "flutter clean"
Write-Host "Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue"
Write-Host "Remove-Item pubspec.lock -Force -ErrorAction SilentlyContinue"
Write-Host "flutter pub get"
Write-Host "flutter analyze --no-fatal-infos"
Write-Host "flutter run --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com"
