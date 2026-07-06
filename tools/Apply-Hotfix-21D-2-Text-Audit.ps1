$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyi Hotfix 21D-2 - Text Audit JSON Fix..." -ForegroundColor Cyan

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$replacementFile = ".\tools\text_replacements_21D.json"

if (!(Test-Path $replacementFile)) {
    Write-Host "ERROR: No se encontró $replacementFile" -ForegroundColor Red
    exit 1
}

$replacementJson = Get-Content $replacementFile -Raw -Encoding UTF8
$replacementPairs = $replacementJson | ConvertFrom-Json

$extensions = @(
    "*.dart", "*.cs", "*.json", "*.xml", "*.md", "*.txt",
    "*.yaml", "*.yml", "*.ps1", "*.html", "*.cshtml"
)

$skipParts = @(
    "\bin\", "\obj\", "\build\", "\.dart_tool\", "\.gradle\",
    "\.git\", "\.vs\", "\node_modules\", "\Pods\", "\DerivedData\"
)

function Should-Skip($path) {
    foreach ($part in $skipParts) {
        if ($path.Contains($part)) {
            return $true
        }
    }

    return $false
}

$files = @()

foreach ($ext in $extensions) {
    $files += Get-ChildItem . -Recurse -File -Filter $ext -ErrorAction SilentlyContinue
}

$files = $files | Sort-Object FullName -Unique

$report = New-Object System.Collections.Generic.List[string]
$changedFiles = 0

foreach ($file in $files) {
    $path = $file.FullName

    if (Should-Skip $path) {
        continue
    }

    if ($path.EndsWith("text_replacements_21D.json")) {
        continue
    }

    $content = [System.IO.File]::ReadAllText($path)
    $original = $content

    foreach ($pair in $replacementPairs) {
        $bad = [string]$pair.bad
        $good = [string]$pair.good

        if ($bad.Length -gt 0) {
            $content = $content.Replace($bad, $good)
        }
    }

    if ($file.Name -eq "strings.xml" -and $content -match "app_name") {
        $content = [regex]::Replace(
            $content,
            '<string name="app_name">.*?</string>',
            '<string name="app_name">Piy&#237;</string>'
        )
    }

    if ($file.Name -eq "piyi_brand.dart") {
        $content = $content -replace "displayName\s*=\s*'Piyí'", "displayName = 'Piy\u00ed'"
        $content = $content -replace 'displayName\s*=\s*"Piyí"', 'displayName = "Piy\u00ed"'
    }

    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
        $changedFiles++
        $relative = Resolve-Path -Relative $path
        $report.Add("UPDATED: $relative")
        Write-Host "OK:" $relative -ForegroundColor Green
    }
}

$report.Add("")
$report.Add("---- POSIBLES RESTOS SOSPECHOSOS ----")

$suspects = @("Ã", "Â", "�")

foreach ($file in $files) {
    $path = $file.FullName

    if (Should-Skip $path) {
        continue
    }

    if ($path.EndsWith("text_replacements_21D.json")) {
        continue
    }

    $content = [System.IO.File]::ReadAllText($path)

    foreach ($suspect in $suspects) {
        if ($content.Contains($suspect)) {
            $relative = Resolve-Path -Relative $path
            $report.Add("CHECK: $relative contains $suspect")
            break
        }
    }
}

$reportDir = ".\docs\audits"
New-Item -ItemType Directory -Force -Path $reportDir | Out-Null

$report.Insert(0, "Piyi Text Audit 21D-2")
$report.Insert(1, "Changed files: $changedFiles")
$report.Insert(2, "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
$report.Insert(3, "")

$reportPath = Join-Path $reportDir "Text_Audit_Report_21D_2.txt"
[System.IO.File]::WriteAllText((Resolve-Path $reportPath).Path, ($report -join [Environment]::NewLine), $utf8NoBom)

Write-Host ""
Write-Host "Hotfix 21D-2 aplicado." -ForegroundColor Green
Write-Host "Archivos modificados: $changedFiles" -ForegroundColor Cyan
Write-Host "Reporte: docs\audits\Text_Audit_Report_21D_2.txt" -ForegroundColor Cyan
