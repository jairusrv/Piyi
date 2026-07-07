$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Sprint 22 - RC1 Readiness..." -ForegroundColor Cyan

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Save-NoBom($path, $content) {
    [System.IO.File]::WriteAllText((Resolve-Path $path).Path, $content, $utf8NoBom)
}

# 1) Normalize critical files.
$criticalFiles = @(
  ".\piyi_mobile\lib\src\core\brand\piyi_brand.dart",
  ".\piyi_mobile\lib\src\core\storage\secure_storage_service.dart",
  ".\piyi_mobile\lib\src\core\widgets\piyi_country_phone_field.dart",
  ".\piyi_mobile\lib\src\core\navigation\piyi_app_back_button.dart",
  ".\piyi_mobile\lib\src\features\auth\data\auth_repository.dart",
  ".\piyi_mobile\lib\src\features\auth\presentation\login_screen.dart",
  ".\piyi_mobile\lib\src\features\auth\presentation\register_screen.dart",
  ".\piyi_mobile\lib\src\features\home\presentation\home_screen.dart",
  ".\piyi_mobile\android\app\src\main\res\values\strings.xml"
)

foreach ($file in $criticalFiles) {
  if (Test-Path $file) {
    $content = [System.IO.File]::ReadAllText((Resolve-Path $file).Path)
    Save-NoBom $file $content
    Write-Host "OK UTF8:" $file -ForegroundColor Green
  }
}

# 2) Remove old conflicting app-level back button if it exists.
$oldBack = ".\piyi_mobile\lib\src\core\navigation\piyi_back_button.dart"
if (Test-Path $oldBack) {
  Remove-Item $oldBack -Force
  Write-Host "OK eliminado back conflictivo:" $oldBack -ForegroundColor Green
}

# 3) Replace conflicting references to PiyiBackButton from previous hotfixes.
$dartFiles = Get-ChildItem ".\piyi_mobile\lib" -Recurse -Filter "*.dart" -ErrorAction SilentlyContinue

foreach ($file in $dartFiles) {
  $path = $file.FullName
  $content = Get-Content $path -Raw
  $original = $content

  $content = [regex]::Replace($content, "(?m)^\s*import\s+['""][^'""]*piyi_back_button\.dart['""];\s*\r?\n", "")
  $content = $content -replace "PiyiBackButton\.fallbackHome\(context\)", "PiyiAppBackButton.fallbackHome(context)"

  if ($content -match "PiyiAppBackButton" -and $content -notmatch "piyi_app_back_button\.dart") {
    if ($content -match "import\s+'package:flutter/material.dart';") {
      $content = $content -replace "import\s+'package:flutter/material.dart';",
        "import 'package:flutter/material.dart';`r`nimport 'package:piyi_mobile/src/core/navigation/piyi_app_back_button.dart';"
    } else {
      $content = "import 'package:piyi_mobile/src/core/navigation/piyi_app_back_button.dart';`r`n$content"
    }
  }

  if ($content -ne $original) {
    [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
    Write-Host "OK back/import:" $path -ForegroundColor Green
  }
}

# 4) Ensure pubspec assets, dependencies and RC version.
$pubspec = ".\piyi_mobile\pubspec.yaml"

if (Test-Path $pubspec) {
  $content = Get-Content $pubspec -Raw

  $content = $content -replace "version:\s*\d+\.\d+\.\d+\+\d+", "version: 0.3.0+22"
  $content = $content -replace "flutter_secure_storage:\s*\^[0-9]+\.[0-9]+\.[0-9]+", "flutter_secure_storage: ^10.3.1"
  $content = $content -replace "device_info_plus:\s*\^[0-9]+\.[0-9]+\.[0-9]+", "device_info_plus: ^13.2.0"

  if ($content -notmatch "assets/brand/piyi_logo.png") {
    $content = $content -replace "flutter:\s*\r?\n\s*uses-material-design:\s*true",
@"
flutter:
  uses-material-design: true
  assets:
    - assets/brand/piyi_logo.png
    - assets/brand/piyi_logo_square.png
    - assets/images/logo.png
"@
  } else {
    foreach ($asset in @("assets/brand/piyi_logo_square.png", "assets/images/logo.png")) {
      if ($content -notmatch [regex]::Escape($asset)) {
        $content = $content -replace "(\s+- assets/brand/piyi_logo.png)", "`$1`r`n    - $asset"
      }
    }
  }

  Save-NoBom $pubspec $content
  Write-Host "OK pubspec RC1." -ForegroundColor Green
}

# 5) Generate basic suspicious-text report without failing.
$reportDir = ".\docs\audits"
New-Item -ItemType Directory -Force -Path $reportDir | Out-Null
$reportPath = Join-Path $reportDir "Sprint_22_RC1_Text_Check.txt"

$suspects = @("Ã", "Â", "â€", "�")
$report = New-Object System.Collections.Generic.List[string]
$report.Add("Sprint 22 RC1 Text Check")
$report.Add("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
$report.Add("")

$sourceFiles = Get-ChildItem . -Recurse -File -Include *.dart,*.cs,*.json,*.xml,*.md,*.yaml,*.yml,*.html -ErrorAction SilentlyContinue | Where-Object {
  $_.FullName -notmatch "\\bin\\|\\obj\\|\\build\\|\\.dart_tool\\|\\.gradle\\|\\.git\\"
}

foreach ($file in $sourceFiles) {
  $text = [System.IO.File]::ReadAllText($file.FullName)
  foreach ($s in $suspects) {
    if ($text.Contains($s)) {
      $report.Add("CHECK: $($file.FullName.Replace((Get-Location).Path + '\', '')) contains $s")
      break
    }
  }
}

[System.IO.File]::WriteAllText($reportPath, ($report -join [Environment]::NewLine), $utf8NoBom)
Write-Host "OK reporte textos:" $reportPath -ForegroundColor Green

Write-Host ""
Write-Host "Sprint 22 RC1 aplicado." -ForegroundColor Green
Write-Host "Valida con:" -ForegroundColor Cyan
Write-Host "dotnet build /warnaserror"
Write-Host "cd .\piyi_mobile"
Write-Host "flutter clean"
Write-Host "Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue"
Write-Host "Remove-Item pubspec.lock -Force -ErrorAction SilentlyContinue"
Write-Host "flutter pub get"
Write-Host "flutter analyze --no-fatal-infos"
Write-Host "flutter run --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com"
