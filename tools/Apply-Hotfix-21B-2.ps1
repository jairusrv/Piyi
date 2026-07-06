$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Hotfix 21B-2..." -ForegroundColor Cyan

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Save-NoBom($path, $content) {
    [System.IO.File]::WriteAllText((Resolve-Path $path).Path, $content, $utf8NoBom)
}

# 1) pubspec assets
$pubspec = ".\piyi_mobile\pubspec.yaml"
if (Test-Path $pubspec) {
    $content = Get-Content $pubspec -Raw

    if ($content -notmatch "assets/brand/piyi_logo.png") {
        $content = $content -replace "flutter:\s*\r?\n\s*uses-material-design:\s*true",
@"
flutter:
  uses-material-design: true
  assets:
    - assets/brand/piyi_logo.png
    - assets/brand/piyi_logo_square.png
    - assets/images/logo.png
    - assets/images/logo_2x.png
    - assets/images/logo_3x.png
"@
    } else {
        foreach ($asset in @("assets/images/logo.png", "assets/images/logo_2x.png", "assets/images/logo_3x.png")) {
            if ($content -notmatch [regex]::Escape($asset)) {
                $content = $content -replace "(\s+- assets/brand/piyi_logo_square.png)", "`$1`r`n    - $asset"
            }
        }
    }

    Save-NoBom $pubspec $content
    Write-Host "OK: pubspec assets revisados." -ForegroundColor Green
}

# 2) base files normalize
$files = @(
  ".\piyi_mobile\android\app\src\main\res\values\strings.xml",
  ".\piyi_mobile\lib\src\core\brand\piyi_brand.dart",
  ".\piyi_mobile\lib\src\core\widgets\piyi_country_phone_field.dart",
  ".\piyi_mobile\lib\src\core\widgets\piyi_user_greeting.dart",
  ".\piyi_mobile\lib\src\core\widgets\piyi_logo_header.dart"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        $text = [System.IO.File]::ReadAllText((Resolve-Path $file).Path)
        Save-NoBom $file $text
    }
}

# 3) Login: improve logo resolution and remove old paw/title if possible.
$loginFiles = Get-ChildItem ".\piyi_mobile\lib" -Recurse -Filter "*.dart" | Where-Object {
    $_.Name -match "login" -or (Select-String -Path $_.FullName -Pattern "Correo electronico|Correo electrónico|Ingresar|Bienvenido de nuevo" -Quiet)
}

foreach ($file in $loginFiles) {
    $path = $file.FullName
    $content = Get-Content $path -Raw
    $original = $content

    if ($content -notmatch "piyi_brand\.dart") {
        if ($content -match "import\s+'package:flutter/material.dart';") {
            $content = $content -replace "import\s+'package:flutter/material.dart';",
                "import 'package:flutter/material.dart';`r`nimport 'package:piyi_mobile/src/core/brand/piyi_brand.dart';"
        } else {
            $content = "import 'package:piyi_mobile/src/core/brand/piyi_brand.dart';`r`n$content"
        }
    }

    $content = [regex]::Replace(
        $content,
        "Icon\s*\(\s*Icons\.pets\s*,[\s\S]*?\)",
        "Image.asset(PiyiBrand.logoAsset, width: 250, fit: BoxFit.contain, filterQuality: FilterQuality.high, isAntiAlias: true)"
    )

    $content = $content -replace "const\s+Image\.asset\(", "Image.asset("

    $content = [regex]::Replace(
        $content,
        "Image\.asset\s*\(\s*PiyiBrand\.logoAsset\s*,[^)]*\)",
        "Image.asset(PiyiBrand.logoAsset, width: 250, fit: BoxFit.contain, filterQuality: FilterQuality.high, isAntiAlias: true)"
    )

    # Remove standalone title Piyí when logo already includes the text.
    $content = [regex]::Replace($content, "(?s)Text\s*\(\s*['""]Piy[ií]́?['""].*?\),", "")

    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
        Write-Host "OK login/logo:" $path -ForegroundColor Green
    }
}

# 4) Register: force phone field replacement.
$register = ".\piyi_mobile\lib\src\features\auth\presentation\register_screen.dart"
if (Test-Path $register) {
    $content = Get-Content $register -Raw
    $original = $content

    # Clean old duplicated imports.
    $content = [regex]::Replace($content, "(?m)^\s*import\s+['""][^'""]*piyi_country_phone_field\.dart['""];\s*\r?\n", "")

    if ($content -notmatch "package:piyi_mobile/src/core/widgets/piyi_country_phone_field.dart") {
        if ($content -match "import\s+'package:flutter/material.dart';") {
            $content = $content -replace "import\s+'package:flutter/material.dart';",
                "import 'package:flutter/material.dart';`r`nimport 'package:piyi_mobile/src/core/widgets/piyi_country_phone_field.dart';"
        } else {
            $content = "import 'package:piyi_mobile/src/core/widgets/piyi_country_phone_field.dart';`r`n$content"
        }
    }

    if ($content -notmatch "PiyiCountryPhoneField\s*\(") {
        $pattern1 = "(?s)(TextFormField|TextField)\s*\(\s*controller:\s*_phoneController\s*,.*?decoration:\s*InputDecoration\s*\([\s\S]*?labelText:\s*['""](Tel[eé]fono|Telefono|Phone)['""][\s\S]*?\)\s*,?\s*\)"
        if ($content -match $pattern1) {
            $content = [regex]::Replace($content, $pattern1, "PiyiCountryPhoneField(controller: _phoneController)", 1)
        } else {
            $pattern2 = "(?s)PiyiInput\s*\(\s*controller:\s*_phoneController\s*,[\s\S]*?(label|labelText)\s*:\s*['""](Tel[eé]fono|Telefono|Phone)['""][\s\S]*?\)"
            if ($content -match $pattern2) {
                $content = [regex]::Replace($content, $pattern2, "PiyiCountryPhoneField(controller: _phoneController)", 1)
            }
        }
    }

    [System.IO.File]::WriteAllText((Resolve-Path $register).Path, $content, $utf8NoBom)
    Write-Host "OK register phone field revisado." -ForegroundColor Green
}

# 5) Home: replace hardcoded Hola Jairo with widget reading stored session/token.
$homeFiles = Get-ChildItem ".\piyi_mobile\lib\src\features" -Recurse -Filter "*.dart" | Where-Object {
    $_.Name -match "home|dashboard" -or (Select-String -Path $_.FullName -Pattern "Hola Jairo|Bienvenido nueva" -Quiet)
}

foreach ($file in $homeFiles) {
    $path = $file.FullName
    $content = Get-Content $path -Raw
    $original = $content

    if ($content -notmatch "piyi_user_greeting\.dart") {
        if ($content -match "import\s+'package:flutter/material.dart';") {
            $content = $content -replace "import\s+'package:flutter/material.dart';",
                "import 'package:flutter/material.dart';`r`nimport 'package:piyi_mobile/src/core/widgets/piyi_user_greeting.dart';"
        }
    }

    $content = [regex]::Replace($content, "(?s)Text\s*\(\s*['""]Hola\s+Jairo['""].*?\)", "const PiyiUserGreeting()", 1)
    $content = $content -replace "Bienvenido nueva\.\.\.", ""
    $content = $content -replace "Bienvenido nueva", ""

    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
        Write-Host "OK home greeting:" $path -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Hotfix 21B-2 aplicado." -ForegroundColor Green
Write-Host "IMPORTANTE: para refrescar icono, ejecuta adb uninstall com.piyi.mobile." -ForegroundColor Yellow
