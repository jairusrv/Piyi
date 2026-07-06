$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Hotfix 21A-2: icono sin texto + nombre corregido..." -ForegroundColor Cyan

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$files = @(
  ".\piyi_mobile\android\app\src\main\res\values\strings.xml",
  ".\piyi_mobile\android\app\src\main\AndroidManifest.xml",
  ".\piyi_mobile\lib\src\core\brand\piyi_brand.dart"
)

foreach ($file in $files) {
  if (Test-Path $file) {
    $content = [System.IO.File]::ReadAllText((Resolve-Path $file).Path)
    [System.IO.File]::WriteAllText((Resolve-Path $file).Path, $content, $utf8NoBom)
    Write-Host "OK UTF8 sin BOM:" $file -ForegroundColor Green
  }
}

Write-Host ""
Write-Host "Hotfix 21A-2 aplicado." -ForegroundColor Green
Write-Host "Para probar icono/nombre, desinstala la app antes de instalar:" -ForegroundColor Yellow
Write-Host "adb uninstall com.piyi.mobile"
