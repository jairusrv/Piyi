$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Sprint 23B..." -ForegroundColor Cyan

$root = (Resolve-Path ".").Path
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$replacementFile = Join-Path $root "tools\text_replacements_23B.json"

if (!(Test-Path $replacementFile)) {
    throw "No se encontró $replacementFile"
}

$pairs = (Get-Content $replacementFile -Raw -Encoding UTF8) | ConvertFrom-Json

$extensions = @(
    ".dart", ".cs", ".csproj", ".json", ".xml", ".yaml", ".yml",
    ".md", ".txt", ".ps1", ".bat", ".sql", ".html", ".cshtml"
)

$skip = @(
    "\.git\", "\bin\", "\obj\", "\build\", "\.dart_tool\",
    "\.gradle\", "\node_modules\", "\encoding_backup\"
)

function Should-Skip([string]$path) {
    foreach ($part in $skip) {
        if ($path.Contains($part)) {
            return $true
        }
    }

    return $false
}

$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupRoot = Join-Path $root "encoding_backup\23B_$stamp"
$changed = New-Object System.Collections.Generic.List[string]
$suspicious = New-Object System.Collections.Generic.List[string]

$files = Get-ChildItem $root -Recurse -File | Where-Object {
    ($extensions -contains $_.Extension.ToLowerInvariant()) -and
    -not (Should-Skip $_.FullName)
}

foreach ($file in $files) {
    if ($file.FullName.EndsWith("text_replacements_23B.json")) {
        continue
    }

    $original = [System.IO.File]::ReadAllText($file.FullName)
    $fixed = $original

    for ($round = 0; $round -lt 4; $round++) {
        $before = $fixed

        foreach ($pair in $pairs) {
            $fixed = $fixed.Replace([string]$pair.bad, [string]$pair.good)
        }

        if ($fixed -eq $before) {
            break
        }
    }

    if ($fixed -ne $original) {
        $relative = $file.FullName.Substring($root.Length).TrimStart('\', '/')
        $backup = Join-Path $backupRoot $relative

        New-Item -ItemType Directory -Force -Path (Split-Path $backup -Parent) | Out-Null
        Copy-Item $file.FullName $backup -Force
        [System.IO.File]::WriteAllText($file.FullName, $fixed, $utf8NoBom)

        $changed.Add($relative)
        Write-Host "TEXT FIXED: $relative" -ForegroundColor Green
    }

    if ($fixed.Contains("Ãƒ") -or $fixed.Contains("Ã‚") -or $fixed.Contains("ÃÆ") -or $fixed.Contains("�")) {
        $relative = $file.FullName.Substring($root.Length).TrimStart('\', '/')
        $suspicious.Add($relative)
    }
}

# Ensure JSON is copied into Infrastructure output.
$infraProject = Join-Path $root "src\Piyi.Infrastructure\Piyi.Infrastructure.csproj"
$projectContent = [System.IO.File]::ReadAllText($infraProject)

if (!$projectContent.Contains("pet_catalog_23B.json")) {
    $itemGroup = @'

  <ItemGroup>
    <None Update="Data\Seed\pet_catalog_23B.json">
      <CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
    </None>
  </ItemGroup>
'@

    $projectContent = $projectContent.Replace("</Project>", "$itemGroup`r`n</Project>")
    [System.IO.File]::WriteAllText($infraProject, $projectContent, $utf8NoBom)
    Write-Host "OK: JSON agregado al output de Infrastructure." -ForegroundColor Green
}

# Add seeder invocation to Program.cs.
$program = Join-Path $root "src\Piyi.API\Program.cs"
$programContent = [System.IO.File]::ReadAllText($program)

if (!$programContent.Contains("Piyi.Infrastructure.Data.Seed")) {
    $programContent = "using Microsoft.EntityFrameworkCore;`r`nusing Piyi.Infrastructure.Data;`r`nusing Piyi.Infrastructure.Data.Seed;`r`n" + $programContent
}

if (!$programContent.Contains("PetCatalogSeeder23B.SeedAsync")) {
    $seedBlock = @'

using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<PiyiDbContext>();

    try
    {
        await dbContext.Database.MigrateAsync();
        await PetCatalogSeeder23B.SeedAsync(dbContext);
    }
    catch (Exception ex)
    {
        app.Logger.LogError(ex, "No se pudo inicializar el catálogo de especies y razas.");
        throw;
    }
}

'@

    $programContent = $programContent.Replace("app.MapControllers();", "$seedBlock`r`napp.MapControllers();")
}

[System.IO.File]::WriteAllText($program, $programContent, $utf8NoBom)
Write-Host "OK: Program.cs ejecutará migraciones y seed de catálogo." -ForegroundColor Green

$reportDir = Join-Path $root "docs\audits"
New-Item -ItemType Directory -Force -Path $reportDir | Out-Null
$report = Join-Path $reportDir "Sprint_23B_Report_$stamp.txt"

$lines = @(
    "Piyí Sprint 23B",
    "Archivos de texto corregidos: $($changed.Count)",
    "Archivos aún sospechosos: $($suspicious.Count)",
    "",
    "CORREGIDOS"
) + $changed + @("", "SOSPECHOSOS") + $suspicious

[System.IO.File]::WriteAllLines($report, $lines, $utf8NoBom)

Write-Host ""
Write-Host "Sprint 23B aplicado." -ForegroundColor Cyan
Write-Host "Reporte: $report"
Write-Host "Respaldo: $backupRoot"
