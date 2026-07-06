$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Sprint 21C - Pet Catalog Seed Data..." -ForegroundColor Cyan

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$files = @(
  ".\src\Piyi.Infrastructure\Data\Seed\PetCatalogSeeder.cs",
  ".\src\Piyi.Infrastructure\Data\Seed\pet_catalog_seed.json"
)

foreach ($file in $files) {
    if (!(Test-Path $file)) {
        Write-Host "ERROR: No se encontró $file. Extrae el ZIP sobre la raíz del proyecto." -ForegroundColor Red
        exit 1
    }

    $content = [System.IO.File]::ReadAllText((Resolve-Path $file).Path)
    [System.IO.File]::WriteAllText((Resolve-Path $file).Path, $content, $utf8NoBom)
    Write-Host "OK:" $file -ForegroundColor Green
}

$infraProject = ".\src\Piyi.Infrastructure\Piyi.Infrastructure.csproj"
if (Test-Path $infraProject) {
    $projectContent = Get-Content $infraProject -Raw

    if ($projectContent -notmatch "pet_catalog_seed.json") {
        $projectContent = $projectContent -replace "</Project>", @"
  <ItemGroup>
    <None Update="Data\Seed\pet_catalog_seed.json">
      <CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
    </None>
  </ItemGroup>
</Project>
"@
        [System.IO.File]::WriteAllText((Resolve-Path $infraProject).Path, $projectContent, $utf8NoBom)
        Write-Host "OK: Piyi.Infrastructure.csproj copia pet_catalog_seed.json al output." -ForegroundColor Green
    }
}

$program = ".\src\Piyi.API\Program.cs"
if (!(Test-Path $program)) {
    Write-Host "ERROR: No se encontró Program.cs" -ForegroundColor Red
    exit 1
}

$programContent = Get-Content $program -Raw

if ($programContent -notmatch "Piyi.Infrastructure.Data.Seed") {
    $programContent = $programContent -replace "(using\s+Piyi\.Infrastructure[^;]*;\s*)", "`$1`r`nusing Piyi.Infrastructure.Data.Seed;"
}

if ($programContent -notmatch "PetCatalogSeeder\.SeedAsync") {
    $seedBlock = @'

using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<Piyi.Infrastructure.Data.PiyiDbContext>();

    try
    {
        await PetCatalogSeeder.SeedAsync(dbContext);
    }
    catch (Exception ex)
    {
        app.Logger.LogError(ex, "Error seeding Piyí pet catalog.");
    }
}

'@

    if ($programContent -match "app\.MapControllers\(\);") {
        $programContent = $programContent -replace "app\.MapControllers\(\);", "$seedBlock`r`napp.MapControllers();"
    }
    else {
        $programContent = $programContent -replace "app\.Run\(\);", "$seedBlock`r`napp.Run();"
    }
}

[System.IO.File]::WriteAllText((Resolve-Path $program).Path, $programContent, $utf8NoBom)
Write-Host "OK: Program.cs configurado para ejecutar seeder." -ForegroundColor Green

Write-Host ""
Write-Host "Sprint 21C aplicado." -ForegroundColor Green
Write-Host "Ejecuta: dotnet build /warnaserror" -ForegroundColor Cyan
