$ErrorActionPreference = "Stop"

$pubspec = ".\pubspec.yaml"

if (!(Test-Path $pubspec)) {
  Write-Host "No se encontró pubspec.yaml. Ejecuta desde piyi_mobile." -ForegroundColor Red
  exit 1
}

$content = Get-Content $pubspec -Raw

if ($content -notmatch "version:\s*(\d+)\.(\d+)\.(\d+)\+(\d+)") {
  Write-Host "No se pudo leer version en pubspec.yaml" -ForegroundColor Red
  exit 1
}

$major = [int]$Matches[1]
$minor = [int]$Matches[2]
$patch = [int]$Matches[3]
$build = [int]$Matches[4] + 1

$newVersion = "version: $major.$minor.$patch+$build"
$content = [regex]::Replace($content, "version:\s*\d+\.\d+\.\d+\+\d+", $newVersion)

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText((Resolve-Path $pubspec).Path, $content, $utf8NoBom)

Write-Host "Piyí build incrementado: $major.$minor.$patch+$build" -ForegroundColor Green
