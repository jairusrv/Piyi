$ErrorActionPreference = "Stop"
Write-Host "Aplicando Piyí Sprint 21A..." -ForegroundColor Cyan

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$files = @(
 ".\piyi_mobile\pubspec.yaml",
 ".\piyi_mobile\android\app\src\main\AndroidManifest.xml",
 ".\piyi_mobile\android\app\src\main\res\values\strings.xml",
 ".\piyi_mobile\packages\piyi_ui\lib\src\tokens\piyi_colors.dart",
 ".\piyi_mobile\packages\piyi_ui\lib\src\theme\piyi_theme.dart",
 ".\piyi_mobile\lib\src\core\brand\piyi_brand.dart",
 ".\src\Piyi.API\Controllers\PrivacyController.cs"
)

foreach ($file in $files) {
  if (Test-Path $file) {
    $content = [System.IO.File]::ReadAllText((Resolve-Path $file).Path)
    [System.IO.File]::WriteAllText((Resolve-Path $file).Path, $content, $utf8NoBom)
  }
}

Write-Host "Sprint 21A aplicado." -ForegroundColor Green
Write-Host ""
Write-Host "Validar API:" -ForegroundColor Cyan
Write-Host "dotnet build /warnaserror"
Write-Host ""
Write-Host "Validar Flutter:" -ForegroundColor Cyan
Write-Host "cd .\piyi_mobile"
Write-Host "flutter clean"
Write-Host "flutter pub get"
Write-Host "flutter run --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com"
