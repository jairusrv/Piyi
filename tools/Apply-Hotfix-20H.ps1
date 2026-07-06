$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Hotfix 20H - Neon Connection Resolver..." -ForegroundColor Cyan

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$factory = ".\src\Piyi.Infrastructure\Data\DatabaseConnectionStringFactory.cs"
if (!(Test-Path $factory)) {
    Write-Host "ERROR: No se encontró $factory. Extrae el ZIP sobre la raíz del proyecto." -ForegroundColor Red
    exit 1
}

$content = [System.IO.File]::ReadAllText((Resolve-Path $factory).Path)
[System.IO.File]::WriteAllText((Resolve-Path $factory).Path, $content, $utf8NoBom)
Write-Host "OK: DatabaseConnectionStringFactory disponible." -ForegroundColor Green

$di = ".\src\Piyi.Infrastructure\DependencyInjection.cs"
if (!(Test-Path $di)) {
    Write-Host "ERROR: No se encontró $di" -ForegroundColor Red
    exit 1
}

$diContent = Get-Content $di -Raw

if ($diContent -notmatch "DatabaseConnectionStringFactory.GetConnectionString") {
    $diContent = $diContent -replace 'var\s+connectionString\s*=\s*configuration\.GetConnectionString\("DefaultConnection"\)\s*;',
        'var connectionString = DatabaseConnectionStringFactory.GetConnectionString(configuration);'

    if ($diContent -notmatch "DatabaseConnectionStringFactory.GetConnectionString") {
        $diContent = $diContent -replace 'configuration\.GetConnectionString\("DefaultConnection"\)',
            'DatabaseConnectionStringFactory.GetConnectionString(configuration)'
    }
}

[System.IO.File]::WriteAllText((Resolve-Path $di).Path, $diContent, $utf8NoBom)
Write-Host "OK: DependencyInjection.cs usa DatabaseConnectionStringFactory." -ForegroundColor Green

$program = ".\src\Piyi.API\Program.cs"
if (Test-Path $program) {
    $programContent = Get-Content $program -Raw

    if ($programContent -match 'if\s*\(app\.Environment\.IsDevelopment\(\)\)\s*\{\s*app\.UseSwagger\(\);\s*app\.UseSwaggerUI\(\);\s*\}') {
        $programContent = $programContent -replace 'if\s*\(app\.Environment\.IsDevelopment\(\)\)\s*\{\s*app\.UseSwagger\(\);\s*app\.UseSwaggerUI\(\);\s*\}',
@'
if (app.Environment.IsDevelopment() ||
    string.Equals(Environment.GetEnvironmentVariable("PIYI_ENABLE_SWAGGER"), "true", StringComparison.OrdinalIgnoreCase))
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
'@
    }

    $programContent = $programContent -replace '\s*app\.UseHttpsRedirection\(\);\s*', "`r`n"

    if ($programContent -notmatch 'app\.UseAuthentication\(\);') {
        $programContent = $programContent -replace 'app\.UseCors\("PiyiCors"\);',
            "app.UseCors(""PiyiCors"");`r`napp.UseAuthentication();"
    }

    [System.IO.File]::WriteAllText((Resolve-Path $program).Path, $programContent, $utf8NoBom)
    Write-Host "OK: Program.cs actualizado para Render." -ForegroundColor Green
}

$appsettingsProd = ".\src\Piyi.API\appsettings.Production.json"
$appsettingsProdContent = @'
{
  "AllowedHosts": "*",
  "ConnectionStrings": {
    "DefaultConnection": ""
  },
  "Jwt": {
    "Issuer": "Piyi.API",
    "Audience": "Piyi.Mobile",
    "SecretKey": "SET_IN_RENDER_ENVIRONMENT",
    "ExpirationMinutes": 1440
  }
}
'@
[System.IO.File]::WriteAllText((Resolve-Path ".\src\Piyi.API").Path + "\appsettings.Production.json", $appsettingsProdContent, $utf8NoBom)
Write-Host "OK: appsettings.Production.json seguro creado." -ForegroundColor Green

Write-Host ""
Write-Host "Hotfix 20H aplicado." -ForegroundColor Green
Write-Host "Ejecuta: dotnet build /warnaserror" -ForegroundColor Cyan
