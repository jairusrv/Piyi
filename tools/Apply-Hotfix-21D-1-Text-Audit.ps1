$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyi Hotfix 21D-1 - Text Audit PS Fix..." -ForegroundColor Cyan

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Decode-B64($value) {
    return [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($value))
}

$replacementPairs = @(
    @("UGl5w4PCrQ==", "UGl5w60=")
    @("UGl5w4M=", "UGl5w60=")
    @("Q29uZmlndXJhY2nDg8Kzbg==", "Q29uZmlndXJhY2nDs24=")
    @("Y29uZmlndXJhY2nDg8Kzbg==", "Y29uZmlndXJhY2nDs24=")
    @("VGVsw4PCqWZvbm8=", "VGVsw6lmb25v")
    @("dGVsw4PCqWZvbm8=", "dGVsw6lmb25v")
    @("VGVsZWZvbm8=", "VGVsw6lmb25v")
    @("dGVsZWZvbm8=", "dGVsw6lmb25v")
    @("Q29udHJhc2XDg8KxYQ==", "Q29udHJhc2XDsWE=")
    @("Y29udHJhc2XDg8KxYQ==", "Y29udHJhc2XDsWE=")
    @("Q29udHJhc2VuYQ==", "Q29udHJhc2XDsWE=")
    @("Y29udHJhc2VuYQ==", "Y29udHJhc2XDsWE=")
    @("Tm90aWZpY2FjacODwrNu", "Tm90aWZpY2FjacOzbg==")
    @("bm90aWZpY2FjacODwrNu", "bm90aWZpY2FjacOzbg==")
    @("VWJpY2FjacODwrNu", "VWJpY2FjacOzbg==")
    @("dWJpY2FjacODwrNu", "dWJpY2FjacOzbg==")
    @("RGlyZWNjacODwrNu", "RGlyZWNjacOzbg==")
    @("ZGlyZWNjacODwrNu", "ZGlyZWNjacOzbg==")
    @("RGVzY3JpcGNpw4PCs24=", "RGVzY3JpcGNpw7Nu")
    @("ZGVzY3JpcGNpw4PCs24=", "ZGVzY3JpcGNpw7Nu")
    @("Q2F0ZWdvcsODwq1h", "Q2F0ZWdvcsOtYQ==")
    @("Y2F0ZWdvcsODwq1h", "Y2F0ZWdvcsOtYQ==")
    @("SW5mb3JtYWNpw4PCs24=", "SW5mb3JtYWNpw7Nu")
    @("aW5mb3JtYWNpw4PCs24=", "aW5mb3JtYWNpw7Nu")
    @("TsODwrptZXJv", "TsO6bWVybw==")
    @("bsODwrptZXJv", "bsO6bWVybw==")
    @("Q8ODwrNkaWdv", "Q8OzZGlnbw==")
    @("Y8ODwrNkaWdv", "Y8OzZGlnbw==")
    @("UGHDg8Ktcw==", "UGHDrXM=")
    @("cGHDg8Ktcw==", "cGHDrXM=")
    @("w4LCvw==", "wr8=")
    @("w4LCoQ==", "wqE=")
    @("w4PCoQ==", "w6E=")
    @("w4PCqQ==", "w6k=")
    @("w4PCrQ==", "w60=")
    @("w4PCsw==", "w7M=")
    @("w4PCug==", "w7o=")
    @("w4PCsQ==", "w7E=")
    @("w4PCgQ==", "w4E=")
    @("w4PigLA=", "w4k=")
    @("w4PCjQ==", "w40=")
    @("w4PigJw=", "w5M=")
    @("w4PFoQ==", "w5o=")
    @("w4PigJg=", "w5E=")
    @("Q29ycmVvIGVsZWN0cm9uaWNv", "Q29ycmVvIGVsZWN0csOzbmljbw==")
    @("SW5pY2lhciBzZXNpb24=", "SW5pY2lhciBzZXNpw7Nu")
    @("Q2VycmFyIHNlc2lvbg==", "Q2VycmFyIHNlc2nDs24=")
    @("QXVuIG5vIHRpZW5lcyBtYXNjb3Rhcw==", "QcO6biBubyB0aWVuZXMgbWFzY290YXM=")
    @("QXVuIG5vIHRpZW5lcyBub3RpZmljYWNpb25lcw==", "QcO6biBubyB0aWVuZXMgbm90aWZpY2FjaW9uZXM=")
    @("QXVuIG5vIGhheSByZXBvcnRlcw==", "QcO6biBubyBoYXkgcmVwb3J0ZXM=")
    @("QW5hZGly", "QcOxYWRpcg==")
)

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

    $content = [System.IO.File]::ReadAllText($path)
    $original = $content

    foreach ($pair in $replacementPairs) {
        $bad = Decode-B64 $pair[0]
        $good = Decode-B64 $pair[1]
        $content = $content.Replace($bad, $good)
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

$report.Insert(0, "Piyi Text Audit 21D-1")
$report.Insert(1, "Changed files: $changedFiles")
$report.Insert(2, "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
$report.Insert(3, "")

$reportPath = Join-Path $reportDir "Text_Audit_Report_21D_1.txt"
[System.IO.File]::WriteAllText((Resolve-Path $reportPath).Path, ($report -join [Environment]::NewLine), $utf8NoBom)

Write-Host ""
Write-Host "Hotfix 21D-1 aplicado." -ForegroundColor Green
Write-Host "Archivos modificados: $changedFiles" -ForegroundColor Cyan
Write-Host "Reporte: docs\audits\Text_Audit_Report_21D_1.txt" -ForegroundColor Cyan
