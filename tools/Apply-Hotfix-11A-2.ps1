$businessPath = ".\src\Piyi.Domain\Entities\Business.cs"

if (!(Test-Path $businessPath)) {
    Write-Host "ERROR: No se encontró Business.cs en $businessPath" -ForegroundColor Red
    exit 1
}

$content = Get-Content $businessPath -Raw

if ($content -match "IsProviderPro") {
    Write-Host "OK: Business.cs ya contiene IsProviderPro" -ForegroundColor Green
    exit 0
}

$property = @"

    public bool IsProviderPro { get; set; } = false;
"@

if ($content -match "public bool IsVerified \{ get; set; \}") {
    $content = $content -replace "public bool IsVerified \{ get; set; \}", "public bool IsVerified { get; set; }$property"
}
elseif ($content -match "public DateTimeOffset CreatedAt") {
    $content = $content -replace "public DateTimeOffset CreatedAt", "$property`r`n    public DateTimeOffset CreatedAt"
}
else {
    $lastBrace = $content.LastIndexOf("}")
    if ($lastBrace -lt 0) {
        Write-Host "ERROR: No se pudo modificar Business.cs" -ForegroundColor Red
        exit 1
    }

    $content = $content.Insert($lastBrace, $property + "`r`n")
}

Set-Content -Path $businessPath -Value $content -Encoding UTF8

Write-Host "OK: Se agregó IsProviderPro a Business.cs" -ForegroundColor Green
