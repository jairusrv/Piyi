$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Hotfix 21B Logo/Login/Icon..." -ForegroundColor Cyan

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Save-NoBom($path, $content) {
    [System.IO.File]::WriteAllText((Resolve-Path $path).Path, $content, $utf8NoBom)
}

# 1) Asegurar assets en pubspec.yaml
$pubspec = ".\piyi_mobile\pubspec.yaml"
if (Test-Path $pubspec) {
    $content = Get-Content $pubspec -Raw

    if ($content -notmatch "assets/brand/piyi_logo.png") {
        $content = $content -replace "flutter:\s*\r?\n\s*uses-material-design:\s*true",
@"
flutter:
  uses-material-design: true
  assets:
    - assets/brand/piyi_logo.png
    - assets/brand/piyi_logo_square.png
    - assets/images/logo.png
"@
    }
    elseif ($content -notmatch "assets/images/logo.png") {
        $content = $content -replace "(\s+- assets/brand/piyi_logo_square.png)", "`$1`r`n    - assets/images/logo.png"
    }

    Save-NoBom $pubspec $content
    Write-Host "OK: pubspec.yaml assets revisados." -ForegroundColor Green
}

# 2) Normalizar archivos XML/Dart incluidos
$files = @(
  ".\piyi_mobile\android\app\src\main\res\values\strings.xml",
  ".\piyi_mobile\lib\src\core\brand\piyi_brand.dart",
  ".\piyi_mobile\lib\src\core\widgets\piyi_logo_header.dart",
  ".\piyi_mobile\lib\src\features\splash\presentation\splash_screen.dart"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        $text = [System.IO.File]::ReadAllText((Resolve-Path $file).Path)
        Save-NoBom $file $text
        Write-Host "OK UTF8 sin BOM:" $file -ForegroundColor Green
    }
}

# 3) Patch LoginScreen: sustituir huella + texto Piyí por logo oficial.
$loginCandidates = Get-ChildItem ".\piyi_mobile\lib" -Recurse -Filter "*.dart" | Where-Object {
    $_.Name -match "login" -or (Select-String -Path $_.FullName -Pattern "Bienvenido de nuevo|Correo electrónico|Correo electrónico|Ingresar" -Quiet)
}

foreach ($file in $loginCandidates) {
    $path = $file.FullName
    $content = Get-Content $path -Raw
    $original = $content

    # Agregar import de brand si no existe.
    if ($content -notmatch "piyi_brand\.dart") {
        if ($content -match "import\s+'package:flutter/material.dart';") {
            $content = $content -replace "import\s+'package:flutter/material.dart';",
                "import 'package:flutter/material.dart';`r`nimport 'package:piyi_mobile/src/core/brand/piyi_brand.dart';"
        }
        else {
            $content = "import 'package:piyi_mobile/src/core/brand/piyi_brand.dart';`r`n$content"
        }
    }

    # Reemplazar Icon(Icons.pets...) por Image.asset(PiyiBrand.logoAsset...)
    $content = [regex]::Replace(
        $content,
        "Icon\s*\(\s*Icons\.pets\s*,[\s\S]*?\)",
        "Image.asset(PiyiBrand.logoAsset, width: 210, fit: BoxFit.contain)"
    )

    # Reemplazar textos aislados Piyí/Piyi del encabezado por vacío.
    $content = [regex]::Replace(
        $content,
        "(?s)Text\s*\(\s*['""]Piy[ií]́?['""].*?\),",
        ""
    )

    # Si no hay logo aún en pantalla, insertar antes del texto Bienvenido de nuevo.
    if ($content -notmatch "Image\.asset\(PiyiBrand\.logoAsset") {
        $content = [regex]::Replace(
            $content,
            "(Text\s*\(\s*['""]Bienvenido de nuevo['""])",
            "Image.asset(PiyiBrand.logoAsset, width: 210, fit: BoxFit.contain),`r`nconst SizedBox(height: 18),`r`n$1",
            1
        )
    }

    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
        Write-Host "OK: login actualizado:" $path -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Hotfix aplicado." -ForegroundColor Green
Write-Host "IMPORTANTE para refrescar icono Android:" -ForegroundColor Yellow
Write-Host "adb uninstall com.piyi.mobile"
