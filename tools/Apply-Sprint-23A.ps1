$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Sprint 23A - Encoding Audit sin Python..." -ForegroundColor Cyan

$root = (Resolve-Path ".").Path
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$utf8Strict = New-Object System.Text.UTF8Encoding($false, $true)
$cp1252 = [System.Text.Encoding]::GetEncoding(1252)
$latin1 = [System.Text.Encoding]::GetEncoding(28591)

$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupRoot = Join-Path $root "encoding_backup\$stamp"
$reportDir = Join-Path $root "docs\audits"
New-Item -ItemType Directory -Force -Path $reportDir | Out-Null

$replacementFile = Join-Path $root "tools\text_replacements_23A.json"
if (!(Test-Path $replacementFile)) {
    throw "No se encontró $replacementFile"
}

$replacementPairs = (Get-Content $replacementFile -Raw -Encoding UTF8) | ConvertFrom-Json

$extensions = @(
    ".dart", ".cs", ".csproj", ".sln", ".json", ".xml", ".md", ".txt",
    ".yaml", ".yml", ".ps1", ".bat", ".cmd", ".html", ".cshtml", ".sql",
    ".props", ".targets", ".gradle", ".kts", ".properties"
)

$skipNames = @(
    ".git", ".vs", ".idea", ".vscode", "bin", "obj", "build", ".dart_tool",
    ".gradle", "node_modules", "Pods", "DerivedData", ".pub-cache", "coverage",
    "artifacts", "TestResults", "dist", "encoding_backup"
)

function Should-Skip([string]$path) {
    foreach ($name in $skipNames) {
        $needle = [System.IO.Path]::DirectorySeparatorChar + $name + [System.IO.Path]::DirectorySeparatorChar
        if ($path.Contains($needle)) {
            return $true
        }
    }
    return $false
}

function Get-BadScore([string]$text) {
    $score = 0

    foreach ($ch in $text.ToCharArray()) {
        $code = [int][char]$ch

        if ($code -eq 0x00C3 -or $code -eq 0x00C2 -or $code -eq 0xFFFD) {
            $score += 10
        }

        if ($code -ge 0x0080 -and $code -le 0x009F) {
            $score += 5
        }
    }

    return $score
}

function Convert-Candidate([string]$text, [System.Text.Encoding]$sourceEncoding) {
    try {
        $bytes = $sourceEncoding.GetBytes($text)
        return $utf8Strict.GetString($bytes)
    }
    catch {
        return $null
    }
}

function Repair-Mojibake([string]$text) {
    $current = $text

    for ($round = 0; $round -lt 6; $round++) {
        $currentScore = Get-BadScore $current
        $best = $current
        $bestScore = $currentScore

        foreach ($encoding in @($cp1252, $latin1)) {
            $candidate = Convert-Candidate $current $encoding

            if ($null -ne $candidate) {
                $candidateScore = Get-BadScore $candidate

                if ($candidateScore -lt $bestScore) {
                    $best = $candidate
                    $bestScore = $candidateScore
                }
            }
        }

        if ($best -eq $current) {
            break
        }

        $current = $best
    }

    return $current
}

function Fix-AppThemeSurfaceDuplicate {
    $path = Join-Path $root "piyi_mobile\lib\src\app\app_theme.dart"

    if (!(Test-Path $path)) {
        return
    }

    $lines = [System.IO.File]::ReadAllLines($path)
    $result = New-Object System.Collections.Generic.List[string]
    $insideColorScheme = $false
    $depth = 0
    $surfaceSeen = $false
    $removed = 0

    foreach ($line in $lines) {
        if (!$insideColorScheme -and $line -match "ColorScheme\s*\(") {
            $insideColorScheme = $true
            $surfaceSeen = $false
            $depth = 0
        }

        if ($insideColorScheme) {
            $depth += ([regex]::Matches($line, "\(")).Count
            $depth -= ([regex]::Matches($line, "\)")).Count

            if ($line -match "^\s*surface\s*:") {
                if ($surfaceSeen) {
                    $removed++
                    continue
                }
                $surfaceSeen = $true
            }
        }

        $result.Add($line)

        if ($insideColorScheme -and $depth -le 0) {
            $insideColorScheme = $false
            $surfaceSeen = $false
        }
    }

    if ($removed -gt 0) {
        $backup = Join-Path $backupRoot "piyi_mobile\lib\src\app\app_theme.dart"
        New-Item -ItemType Directory -Force -Path (Split-Path $backup -Parent) | Out-Null
        Copy-Item $path $backup -Force
        [System.IO.File]::WriteAllLines($path, $result, $utf8NoBom)
        Write-Host "FIXED app_theme.dart: eliminados $removed surface duplicados." -ForegroundColor Green
    }
}

$files = Get-ChildItem $root -Recurse -File | Where-Object {
    -not (Should-Skip $_.FullName) -and
    (
        $extensions -contains $_.Extension.ToLowerInvariant() -or
        $_.Name -eq ".gitignore" -or
        $_.Name -eq ".dockerignore"
    )
}

$changedFiles = New-Object System.Collections.Generic.List[string]
$suspiciousFiles = New-Object System.Collections.Generic.List[string]
$errorFiles = New-Object System.Collections.Generic.List[string]

foreach ($file in $files) {
    if ($file.FullName.EndsWith("text_replacements_23A.json")) {
        continue
    }

    try {
        $original = [System.IO.File]::ReadAllText($file.FullName)
        $fixed = Repair-Mojibake $original

        foreach ($pair in $replacementPairs) {
            $bad = [string]$pair.bad
            $good = [string]$pair.good

            if ($bad.Length -gt 0) {
                $fixed = $fixed.Replace($bad, $good)
            }
        }

        if ($file.Name -eq "strings.xml" -and $fixed.Contains('name="app_name"')) {
            $fixed = [regex]::Replace(
                $fixed,
                '<string\s+name="app_name">.*?</string>',
                '<string name="app_name">Piy&#237;</string>',
                [System.Text.RegularExpressions.RegexOptions]::Singleline
            )
        }

        if ($file.Name -eq "piyi_brand.dart") {
            $fixed = $fixed.Replace("displayName = 'Piyí'", "displayName = 'Piy\u00ed'")
        }

        if ($fixed -ne $original) {
            $relative = $file.FullName.Substring($root.Length).TrimStart('\', '/')
            $backup = Join-Path $backupRoot $relative

            New-Item -ItemType Directory -Force -Path (Split-Path $backup -Parent) | Out-Null
            Copy-Item $file.FullName $backup -Force
            [System.IO.File]::WriteAllText($file.FullName, $fixed, $utf8NoBom)

            $changedFiles.Add($relative)
            Write-Host "FIXED $relative" -ForegroundColor Green
        }

        if ((Get-BadScore $fixed) -gt 0) {
            $relative = $file.FullName.Substring($root.Length).TrimStart('\', '/')
            $suspiciousFiles.Add($relative)
        }
    }
    catch {
        $relative = $file.FullName.Substring($root.Length).TrimStart('\', '/')
        $errorFiles.Add("$relative : $($_.Exception.Message)")
    }
}

Fix-AppThemeSurfaceDuplicate

$reportPath = Join-Path $reportDir "Encoding_Audit_Report_23A_$stamp.txt"

$report = New-Object System.Collections.Generic.List[string]
$report.Add("Piyí Sprint 23A - Encoding Audit sin Python")
$report.Add("Fecha: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
$report.Add("Archivos revisados: $($files.Count)")
$report.Add("Archivos corregidos: $($changedFiles.Count)")
$report.Add("Archivos aún sospechosos: $($suspiciousFiles.Count)")
$report.Add("Errores: $($errorFiles.Count)")
$report.Add("")
$report.Add("CORREGIDOS")
$changedFiles | ForEach-Object { $report.Add($_) }
$report.Add("")
$report.Add("SOSPECHOSOS")
$suspiciousFiles | ForEach-Object { $report.Add($_) }
$report.Add("")
$report.Add("ERRORES")
$errorFiles | ForEach-Object { $report.Add($_) }

[System.IO.File]::WriteAllLines($reportPath, $report, $utf8NoBom)

Write-Host ""
Write-Host "Sprint 23A aplicado." -ForegroundColor Cyan
Write-Host "Respaldo: $backupRoot"
Write-Host "Reporte: $reportPath"

if ($errorFiles.Count -gt 0) {
    throw "La auditoría terminó con errores. Revisa el reporte."
}
