$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Hotfix 21A-3..." -ForegroundColor Cyan

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$files = @(
  ".\piyi_mobile\packages\piyi_ui\lib\src\tokens\piyi_colors.dart",
  ".\piyi_mobile\packages\piyi_ui\lib\src\theme\piyi_theme.dart",
  ".\piyi_mobile\packages\piyi_ui\lib\src\widgets\piyi_error_view.dart",
  ".\piyi_mobile\packages\piyi_ui\lib\src\widgets\piyi_form_section.dart",
  ".\piyi_mobile\packages\piyi_ui\lib\src\widgets\piyi_friendly_empty_state.dart",
  ".\piyi_mobile\packages\piyi_ui\lib\src\widgets\piyi_loading_overlay.dart",
  ".\piyi_mobile\packages\piyi_ui\lib\src\widgets\piyi_retry_button.dart",
  ".\piyi_mobile\packages\piyi_ui\lib\src\widgets\piyi_skeleton.dart"
)

foreach ($file in $files) {
  if (Test-Path $file) {
    $content = [System.IO.File]::ReadAllText((Resolve-Path $file).Path)
    [System.IO.File]::WriteAllText((Resolve-Path $file).Path, $content, $utf8NoBom)
  }
}

Write-Host "Hotfix 21A-3 aplicado." -ForegroundColor Green
