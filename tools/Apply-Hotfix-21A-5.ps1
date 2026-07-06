$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Hotfix 21A-5: logo final correcto..." -ForegroundColor Cyan

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$files = @(
  ".\piyi_mobile\android\app\src\main\res\values\strings.xml",
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
Write-Host "Logo final de Piyí aplicado correctamente." -ForegroundColor Green
Write-Host "Ejecuta adb uninstall com.piyi.mobile antes de probar para refrescar icono." -ForegroundColor Yellow
