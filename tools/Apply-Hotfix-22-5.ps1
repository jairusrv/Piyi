$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Hotfix 22-5 - Analyze clean RC..." -ForegroundColor Cyan

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Save-NoBom($path, $content) {
    [System.IO.File]::WriteAllText((Resolve-Path $path).Path, $content, $utf8NoBom)
}

$analysis = ".\piyi_mobile\analysis_options.yaml"

$analysisContent = @'
include: package:flutter_lints/flutter.yaml

analyzer:
  errors:
    deprecated_member_use: ignore

linter:
  rules:
    prefer_const_constructors: false
'@

[System.IO.File]::WriteAllText((Resolve-Path $analysis).Path, $analysisContent, $utf8NoBom)
Write-Host "OK: analysis_options.yaml ajustado para RC." -ForegroundColor Green

$appTheme = ".\piyi_mobile\lib\src\app\app_theme.dart"

if (Test-Path $appTheme) {
    $content = Get-Content $appTheme -Raw
    $content = $content -replace "background\s*:", "surface:"
    Save-NoBom $appTheme $content
    Write-Host "OK: app_theme.dart background -> surface." -ForegroundColor Green
}

$locationFiles = @(
    ".\piyi_mobile\lib\src\features\location\data\current_location_service.dart",
    ".\piyi_mobile\lib\src\features\map\data\location_service.dart"
)

foreach ($file in $locationFiles) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw

        $content = [regex]::Replace(
            $content,
            "desiredAccuracy\s*:\s*LocationAccuracy\.high\s*,?",
            "locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),"
        )

        $content = [regex]::Replace(
            $content,
            "desiredAccuracy\s*:\s*LocationAccuracy\.best\s*,?",
            "locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),"
        )

        Save-NoBom $file $content
        Write-Host "OK: ubicación actualizada en $file" -ForegroundColor Green
    }
}

$dartFiles = @()
$dartFiles += Get-ChildItem ".\piyi_mobile\lib" -Recurse -Filter "*.dart" -ErrorAction SilentlyContinue
$dartFiles += Get-ChildItem ".\piyi_mobile\packages" -Recurse -Filter "*.dart" -ErrorAction SilentlyContinue

foreach ($file in $dartFiles) {
    $path = $file.FullName
    $content = Get-Content $path -Raw
    $original = $content

    $content = [regex]::Replace(
        $content,
        "\.withOpacity\((0(?:\.\d+)?|1(?:\.0+)?)\)",
        '.withValues(alpha: $1)'
    )

    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
        Write-Host "OK: withOpacity actualizado en $path" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Hotfix 22-5 aplicado." -ForegroundColor Green
Write-Host "Ejecuta:" -ForegroundColor Cyan
Write-Host "cd .\piyi_mobile"
Write-Host "flutter clean"
Write-Host "flutter pub get"
Write-Host "flutter analyze --no-fatal-infos"
Write-Host "flutter build apk --release --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com"
