$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Hotfix 21A-6..." -ForegroundColor Cyan

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# 1) Ensure pubspec has assets.
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
"@
    }

    [System.IO.File]::WriteAllText((Resolve-Path $pubspec).Path, $content, $utf8NoBom)
    Write-Host "OK: pubspec assets revisados." -ForegroundColor Green
}

# 2) Remove "Bienvenido nueva..." subtitle from home/dashboard screens.
$homeCandidates = Get-ChildItem ".\piyi_mobile\lib" -Recurse -Filter "*.dart" | Where-Object {
    $_.Name -match "home|dashboard" -or (Select-String -Path $_.FullName -Pattern "Bienvenido nueva|Bienvenido de nuevo|Bienvenido" -Quiet)
}

foreach ($file in $homeCandidates) {
    $path = $file.FullName
    $content = Get-Content $path -Raw
    $old = $content

    $content = $content -replace "Bienvenido nueva\.\.\.", ""
    $content = $content -replace "Bienvenido nueva", ""
    $content = $content -replace "Bienvenido de nuevo", ""
    $content = $content -replace "Bienvenido nuevamente", ""

    # Hide common Text widgets containing the subtitle if still present.
    $content = [regex]::Replace($content, "(?s)Text\s*\(\s*['""]Bienvenido[^'""]*['""].*?\),", "")

    if ($content -ne $old) {
        [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
        Write-Host "OK: texto de bienvenida secundario eliminado en $path" -ForegroundColor Green
    }
}

# 3) Patch splash-like screens to use the final logo instead of paw + text.
$splashCandidates = Get-ChildItem ".\piyi_mobile\lib" -Recurse -Filter "*.dart" | Where-Object {
    $_.Name -match "splash|welcome|onboarding" -or (Select-String -Path $_.FullName -Pattern "El hogar digital de tus mascotas|Piyí|Piyi" -Quiet)
}

foreach ($file in $splashCandidates) {
    $path = $file.FullName
    $content = Get-Content $path -Raw

    if ($content -match "El hogar digital de tus mascotas" -or $file.Name -match "splash") {
        if ($content -notmatch "piyi_brand.dart") {
            $content = $content -replace "(import\s+'package:flutter/material.dart';)", "`$1`r`nimport '../../../core/brand/piyi_brand.dart';"
        }

        # Replace common paw icon widgets with logo asset where safe.
        $content = [regex]::Replace(
            $content,
            "Icon\s*\(\s*Icons\.pets\s*,[^)]*\)",
            "Image.asset(PiyiBrand.logoAsset, width: 230, fit: BoxFit.contain)"
        )

        # Remove standalone Piyí/Piyi text in splash if logo already contains text.
        $content = [regex]::Replace($content, "(?s)Text\s*\(\s*['""]Piy[ií]́?['""].*?\),", "")

        [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
        Write-Host "OK: splash/logo revisado en $path" -ForegroundColor Green
    }
}

# 4) Normalize key files UTF-8 without BOM.
$files = @(
  ".\piyi_mobile\android\app\src\main\res\values\strings.xml",
  ".\piyi_mobile\lib\src\core\brand\piyi_brand.dart",
  ".\piyi_mobile\packages\piyi_ui\lib\src\widgets\piyi_page_scaffold.dart"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        $text = [System.IO.File]::ReadAllText((Resolve-Path $file).Path)
        [System.IO.File]::WriteAllText((Resolve-Path $file).Path, $text, $utf8NoBom)
    }
}

Write-Host ""
Write-Host "Hotfix 21A-6 aplicado." -ForegroundColor Green
Write-Host "Ejecuta adb uninstall com.piyi.mobile antes de probar para refrescar icono/splash." -ForegroundColor Yellow
