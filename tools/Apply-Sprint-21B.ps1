$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Sprint 21B - Stabilization..." -ForegroundColor Cyan

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Write-NoBom($path, $content) {
    [System.IO.File]::WriteAllText((Resolve-Path $path).Path, $content, $utf8NoBom)
}

# 1) Pubspec: assets and dependency consistency.
$pubspec = ".\piyi_mobile\pubspec.yaml"
if (Test-Path $pubspec) {
    $content = Get-Content $pubspec -Raw

    $content = $content -replace 'package_info_plus:\s*\^[0-9]+\.[0-9]+\.[0-9]+', 'package_info_plus: ^10.2.0'
    $content = $content -replace 'device_info_plus:\s*\^[0-9]+\.[0-9]+\.[0-9]+', 'device_info_plus: ^13.2.0'
    $content = $content -replace 'flutter_secure_storage:\s*\^[0-9]+\.[0-9]+\.[0-9]+', 'flutter_secure_storage: ^10.3.1'

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

    Write-NoBom $pubspec $content
    Write-Host "OK: pubspec.yaml estabilizado." -ForegroundColor Green
}

# 2) Normalize base files.
$baseFiles = @(
  ".\piyi_mobile\lib\src\core\navigation\piyi_back_button.dart",
  ".\piyi_mobile\lib\src\core\widgets\piyi_country_phone_field.dart",
  ".\piyi_mobile\lib\src\core\brand\piyi_brand.dart",
  ".\piyi_mobile\packages\piyi_ui\lib\src\widgets\piyi_page_scaffold.dart",
  ".\piyi_mobile\android\app\src\main\res\values\strings.xml"
)

foreach ($file in $baseFiles) {
    if (Test-Path $file) {
        $text = [System.IO.File]::ReadAllText((Resolve-Path $file).Path)
        Write-NoBom $file $text
        Write-Host "OK base:" $file -ForegroundColor Green
    }
}

# 3) Fix broken piyi_back_button imports across project.
$dartFiles = Get-ChildItem ".\piyi_mobile\lib" -Recurse -Filter "*.dart"

foreach ($file in $dartFiles) {
    $path = $file.FullName
    $content = Get-Content $path -Raw
    $original = $content

    # Remove any relative broken imports.
    $content = [regex]::Replace($content, "(?m)^\s*import\s+['""][^'""]*piyi_back_button\.dart['""];\s*\r?\n", "")

    if ($content -match "PiyiBackButton") {
        if ($content -notmatch "package:piyi_mobile/src/core/navigation/piyi_back_button.dart") {
            if ($content -match "import\s+'package:flutter/material.dart';") {
                $content = $content -replace "import\s+'package:flutter/material.dart';",
                    "import 'package:flutter/material.dart';`r`nimport 'package:piyi_mobile/src/core/navigation/piyi_back_button.dart';"
            }
            elseif ($content -match 'import\s+"package:flutter/material.dart";') {
                $content = $content -replace 'import\s+"package:flutter/material.dart";',
                    "import `"package:flutter/material.dart`";`r`nimport 'package:piyi_mobile/src/core/navigation/piyi_back_button.dart';"
            }
            else {
                $content = "import 'package:piyi_mobile/src/core/navigation/piyi_back_button.dart';`r`n$content"
            }
        }
    }

    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
        Write-Host "OK imports back:" $path -ForegroundColor Green
    }
}

# 4) Add back button to internal screens with direct AppBar.
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

    if ($content -notmatch "PiyiBackButton\.fallbackHome") {
        # Add import.
        if ($content -notmatch "package:piyi_mobile/src/core/navigation/piyi_back_button.dart") {
            if ($content -match "import\s+'package:flutter/material.dart';") {
                $content = $content -replace "import\s+'package:flutter/material.dart';",
                    "import 'package:flutter/material.dart';`r`nimport 'package:piyi_mobile/src/core/navigation/piyi_back_button.dart';"
            }
        }

        # Insert leading only if AppBar doesn't already have leading.
        if ($content -notmatch "AppBar\s*\(\s*leading\s*:") {
            $content = [regex]::Replace(
                $content,
                "AppBar\s*\(\s*",
                "AppBar(`r`n        leading: PiyiBackButton.fallbackHome(context),`r`n        ",
                1
            )
        }
    }

    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
        Write-Host "OK back screen:" $path -ForegroundColor Green
    }
}

# 5) Clean duplicate phone imports and enforce country phone field in register.
$register = ".\piyi_mobile\lib\src\features\auth\presentation\register_screen.dart"
if (Test-Path $register) {
    $content = Get-Content $register -Raw

    # Remove every old country phone import.
    $content = [regex]::Replace($content, "(?m)^\s*import\s+['""][^'""]*piyi_country_phone_field\.dart['""];\s*\r?\n", "")

    # Add one absolute package import.
    if ($content -notmatch "package:piyi_mobile/src/core/widgets/piyi_country_phone_field.dart") {
        if ($content -match "import\s+'package:flutter/material.dart';") {
            $content = $content -replace "import\s+'package:flutter/material.dart';",
                "import 'package:flutter/material.dart';`r`nimport 'package:piyi_mobile/src/core/widgets/piyi_country_phone_field.dart';"
        } else {
            $content = "import 'package:piyi_mobile/src/core/widgets/piyi_country_phone_field.dart';`r`n$content"
        }
    }

    # Try safe replacements for phone field.
    if ($content -match "_phoneController") {
        if ($content -notmatch "PiyiCountryPhoneField\s*\(") {
            $pattern1 = "(?s)(TextFormField|TextField)\s*\(\s*controller:\s*_phoneController\s*,.*?decoration:\s*InputDecoration\s*\(.*?labelText:\s*['""](Tel[eé]fono|Teléfono|Phone)['""].*?\)\s*,?\s*\)"
            if ($content -match $pattern1) {
                $content = [regex]::Replace($content, $pattern1, "PiyiCountryPhoneField(controller: _phoneController)", 1)
            } else {
                $pattern2 = "(?s)PiyiInput\s*\(\s*controller:\s*_phoneController\s*,.*?label\s*:\s*['""](Tel[eé]fono|Teléfono|Phone)['""].*?\)"
                if ($content -match $pattern2) {
                    $content = [regex]::Replace($content, $pattern2, "PiyiCountryPhoneField(controller: _phoneController)", 1)
                }
            }
        }
    }

    [System.IO.File]::WriteAllText((Resolve-Path $register).Path, $content, $utf8NoBom)
    Write-Host "OK: register_screen limpio y phone field preparado." -ForegroundColor Green
}

# 6) Remove secondary welcome text.
$homeFiles = Get-ChildItem ".\piyi_mobile\lib\src\features" -Recurse -Filter "*.dart" | Where-Object {
    $_.Name -match "home|dashboard" -or (Select-String -Path $_.FullName -Pattern "Bienvenido nueva|Bienvenido de nuevo|Bienvenido nuevamente" -Quiet)
}

foreach ($file in $homeFiles) {
    $path = $file.FullName
    $content = Get-Content $path -Raw
    $original = $content

    $content = $content -replace "Bienvenido nueva\.\.\.", ""
    $content = $content -replace "Bienvenido nueva", ""
    $content = $content -replace "Bienvenido de nuevo", ""
    $content = $content -replace "Bienvenido nuevamente", ""
    $content = [regex]::Replace($content, "(?s)Text\s*\(\s*['""]Bienvenido[^'""]*['""].*?\),", "")

    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
        Write-Host "OK: texto bienvenida removido:" $path -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Sprint 21B aplicado." -ForegroundColor Green
Write-Host "Siguiente:" -ForegroundColor Cyan
Write-Host "cd .\piyi_mobile"
Write-Host "flutter clean"
Write-Host "Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue"
Write-Host "Remove-Item pubspec.lock -Force -ErrorAction SilentlyContinue"
Write-Host "flutter pub get"
Write-Host "flutter analyze --no-fatal-infos"
Write-Host "flutter run --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com"
