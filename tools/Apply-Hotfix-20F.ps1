$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Hotfix 20F..." -ForegroundColor Cyan

$root = Get-Location
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# Ensure all text files in hotfix-sensitive Android/Dart files are UTF-8 without BOM.
$files = @(
    ".\piyi_mobile\android\app\src\main\AndroidManifest.xml",
    ".\piyi_mobile\android\app\src\main\res\values\strings.xml",
    ".\piyi_mobile\android\gradle.properties",
    ".\piyi_mobile\lib\main.dart",
    ".\piyi_mobile\lib\src\core\bootstrap\firebase_bootstrap.dart"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = [System.IO.File]::ReadAllText((Resolve-Path $file))
        [System.IO.File]::WriteAllText((Resolve-Path $file), $content, $utf8NoBom)
        Write-Host "OK UTF-8 sin BOM:" $file -ForegroundColor Green
    }
}

# Remove old problematic Gradle flags if they still exist.
$gradleProps = ".\piyi_mobile\android\gradle.properties"
if (Test-Path $gradleProps) {
    $content = Get-Content $gradleProps -Raw
    $content = $content -replace '(?m)^\s*android\.builtInKotlin\s*=.*\r?\n?', ''
    $content = $content -replace '(?m)^\s*android\.newDsl\s*=.*\r?\n?', ''
    [System.IO.File]::WriteAllText((Resolve-Path $gradleProps), $content, $utf8NoBom)
    Write-Host "OK: gradle.properties limpio." -ForegroundColor Green
}

Write-Host ""
Write-Host "Hotfix 20F aplicado." -ForegroundColor Green
Write-Host "Comandos recomendados:" -ForegroundColor Cyan
Write-Host "cd .\piyi_mobile"
Write-Host "flutter clean"
Write-Host "Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue"
Write-Host "Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue"
Write-Host "flutter pub get"
Write-Host "flutter run --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com"
