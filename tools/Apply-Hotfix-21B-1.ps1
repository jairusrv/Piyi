$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Hotfix 21B-1: login Image.asset const fix..." -ForegroundColor Cyan

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$login = ".\piyi_mobile\lib\src\features\auth\presentation\login_screen.dart"

if (!(Test-Path $login)) {
    Write-Host "ERROR: No se encontró $login" -ForegroundColor Red
    exit 1
}

$content = Get-Content $login -Raw

$content = $content -replace "const\s+Image\.asset\(", "Image.asset("

[System.IO.File]::WriteAllText((Resolve-Path $login).Path, $content, $utf8NoBom)

Write-Host "OK: removido const de Image.asset en login_screen.dart" -ForegroundColor Green
