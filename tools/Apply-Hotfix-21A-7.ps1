$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Hotfix 21A-7 - Back global..." -ForegroundColor Cyan

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Write-NoBom($path, $content) {
    [System.IO.File]::WriteAllText((Resolve-Path $path).Path, $content, $utf8NoBom)
}

function Get-RelativeImportToCoreNavigation($filePath) {
    $libSrc = (Resolve-Path ".\piyi_mobile\lib\src").Path
    $fileDir = Split-Path (Resolve-Path $filePath).Path -Parent

    $relative = [System.IO.Path]::GetRelativePath($fileDir, (Join-Path $libSrc "core\navigation\piyi_back_button.dart"))
    $relative = $relative -replace "\\", "/"

    if (-not $relative.StartsWith(".")) {
        $relative = "./$relative"
    }

    return $relative
}

# 1) Normaliza archivos base incluidos.
$baseFiles = @(
  ".\piyi_mobile\lib\src\core\navigation\piyi_back_button.dart",
  ".\piyi_mobile\packages\piyi_ui\lib\src\widgets\piyi_page_scaffold.dart"
)

foreach ($file in $baseFiles) {
    if (Test-Path $file) {
        $content = [System.IO.File]::ReadAllText((Resolve-Path $file).Path)
        Write-NoBom $file $content
        Write-Host "OK base:" $file -ForegroundColor Green
    }
}

# 2) Parchea pantallas internas que usan AppBar directo.
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

    if ($content -match "PiyiBackButton\.fallbackHome") {
        continue
    }

    # Agrega import relativo.
    if ($content -notmatch "piyi_back_button\.dart") {
        $relativeImport = Get-RelativeImportToCoreNavigation $path
        $importLine = "import '$relativeImport';"

        if ($content -match "import\s+'package:flutter/material.dart';") {
            $content = $content -replace "import\s+'package:flutter/material.dart';", "import 'package:flutter/material.dart';`r`n$importLine"
        }
        elseif ($content -match 'import\s+"package:flutter/material.dart";') {
            $content = $content -replace 'import\s+"package:flutter/material.dart";', "import `"package:flutter/material.dart`";`r`n$importLine"
        }
        else {
            $content = "$importLine`r`n$content"
        }
    }

    # Inserta leading después de AppBar(
    $content = [regex]::Replace(
        $content,
        "AppBar\s*\(\s*",
        "AppBar(`r`n        leading: PiyiBackButton.fallbackHome(context),`r`n        ",
        1
    )

    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
        Write-Host "OK back agregado:" $path -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Hotfix 21A-7 aplicado." -ForegroundColor Green
Write-Host "Ahora ejecuta flutter analyze para detectar si alguna pantalla requiere ajuste manual." -ForegroundColor Yellow
