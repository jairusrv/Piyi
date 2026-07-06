$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Hotfix 21A-4..." -ForegroundColor Cyan

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# 1. Ensure pubspec has brand assets
$pubspec = ".\piyi_mobile\pubspec.yaml"
if (Test-Path $pubspec) {
    $content = Get-Content $pubspec -Raw

    if ($content -notmatch "assets/brand/piyi_logo.png") {
        if ($content -match "flutter:\s*\r?\n\s*uses-material-design:\s*true") {
            $content = $content -replace "flutter:\s*\r?\n\s*uses-material-design:\s*true",
@"
flutter:
  uses-material-design: true
  assets:
    - assets/brand/piyi_logo.png
    - assets/brand/piyi_logo_square.png
"@
        }
    }

    [System.IO.File]::WriteAllText((Resolve-Path $pubspec).Path, $content, $utf8NoBom)
    Write-Host "OK: pubspec.yaml revisado." -ForegroundColor Green
}

# 2. Normalize key files without BOM
$files = @(
  ".\piyi_mobile\android\app\src\main\res\values\strings.xml",
  ".\piyi_mobile\android\app\src\main\AndroidManifest.xml",
  ".\piyi_mobile\lib\src\core\brand\piyi_brand.dart",
  ".\piyi_mobile\lib\src\core\widgets\piyi_country_phone_field.dart",
  ".\piyi_mobile\packages\piyi_ui\lib\src\widgets\piyi_page_scaffold.dart"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = [System.IO.File]::ReadAllText((Resolve-Path $file).Path)
        [System.IO.File]::WriteAllText((Resolve-Path $file).Path, $content, $utf8NoBom)
        Write-Host "OK UTF8 sin BOM:" $file -ForegroundColor Green
    }
}

# 3. Patch likely register screen phone field.
$registerFiles = Get-ChildItem ".\piyi_mobile\lib" -Recurse -Filter "*.dart" | Where-Object {
    $_.Name -match "register|signup|sign_up" -or (Select-String -Path $_.FullName -Pattern "Crear cuenta|Register|Registro" -Quiet)
}

foreach ($file in $registerFiles) {
    $path = $file.FullName
    $content = Get-Content $path -Raw

    if ($content -match "_phoneController" -and $content -notmatch "PiyiCountryPhoneField") {
        Write-Host "Actualizando teléfono con código país en $path" -ForegroundColor Yellow

        if ($content -notmatch "piyi_country_phone_field.dart") {
            $content = $content -replace "(import\s+'[^']+';\s*\r?\n)", "`$1import '../../../core/widgets/piyi_country_phone_field.dart';`r`n"
        }

        # Replace common TextField/TextFormField block that uses _phoneController and label teléfono.
        $pattern = "(?s)(TextFormField|TextField)\s*\(\s*controller:\s*_phoneController\s*,.*?decoration:\s*InputDecoration\s*\(\s*labelText:\s*['""](Tel[eé]fono|Teléfono|Phone)['""].*?\)\s*,?\s*\)"
        if ($content -match $pattern) {
            $content = [regex]::Replace($content, $pattern, "PiyiCountryPhoneField(controller: _phoneController)", 1)
        } else {
            # Conservative replacement for PiyiInput phone if exists
            $pattern2 = "(?s)PiyiInput\s*\(\s*controller:\s*_phoneController\s*,.*?label:\s*['""](Tel[eé]fono|Teléfono|Phone)['""].*?\)"
            if ($content -match $pattern2) {
                $content = [regex]::Replace($content, $pattern2, "PiyiCountryPhoneField(controller: _phoneController)", 1)
            }
        }

        [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
    }
}

Write-Host ""
Write-Host "Hotfix 21A-4 aplicado." -ForegroundColor Green
Write-Host "IMPORTANTE: ejecuta adb uninstall com.piyi.mobile para refrescar icono y nombre." -ForegroundColor Yellow
