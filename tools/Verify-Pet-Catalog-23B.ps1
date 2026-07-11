$ErrorActionPreference = "Stop"

$baseUrl = "https://piyi.onrender.com"

$species = Invoke-RestMethod "$baseUrl/api/catalogs/species"

Write-Host "Especies encontradas: $($species.Count)" -ForegroundColor Cyan

foreach ($item in $species) {
    $breeds = Invoke-RestMethod "$baseUrl/api/catalogs/species/$($item.id)/breeds"
    Write-Host "$($item.name): $($breeds.Count) razas/tipos"
}
