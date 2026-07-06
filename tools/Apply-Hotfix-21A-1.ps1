$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Hotfix 21A-1..." -ForegroundColor Cyan

$pubspec = ".\piyi_mobile\pubspec.yaml"

if (!(Test-Path $pubspec)) {
    Write-Host "ERROR: No se encontró $pubspec" -ForegroundColor Red
    exit 1
}

$content = Get-Content $pubspec -Raw

if ($content -match "package_info_plus:") {
    $content = $content -replace 'package_info_plus:\s*\^[0-9]+\.[0-9]+\.[0-9]+', 'package_info_plus: ^10.2.0'
} else {
    $content = $content -replace '(device_info_plus:\s*\^[0-9]+\.[0-9]+\.[0-9]+)', "`$1`r`n  package_info_plus: ^10.2.0"
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText((Resolve-Path $pubspec).Path, $content, $utf8NoBom)

Write-Host "OK: package_info_plus actualizado a ^10.2.0" -ForegroundColor Green
