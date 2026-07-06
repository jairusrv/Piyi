$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Sprint 21D - Text Audit & Encoding Fix..." -ForegroundColor Cyan

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$extensions = @(
    "*.dart", "*.cs", "*.json", "*.xml", "*.md", "*.txt",
    "*.yaml", "*.yml", "*.ps1", "*.html", "*.cshtml"
)

$skipDirs = @(
    "\bin\", "\obj\", "\build\", "\.dart_tool\", "\.gradle\",
    "\.git\", "\.vs\", "\node_modules\", "\Pods\", "\DerivedData\"
)

$replacements = [ordered]@{
    "Piyí" = "Piyí"
    "Piyí" = "Piyí"
    "Piyi" = "Piyi"
    "Configuración" = "Configuración"
    "configuración" = "configuración"
    "Teléfono" = "Teléfono"
    "teléfono" = "teléfono"
    "Teléfono" = "Teléfono"
    "teléfono" = "teléfono"
    "Contraseña" = "Contraseña"
    "contraseña" = "contraseña"
    "Notificación" = "Notificación"
    "Notificaciones" = "Notificaciones"
    "notificación" = "notificación"
    "Ubicación" = "Ubicación"
    "ubicación" = "ubicación"
    "Dirección" = "Dirección"
    "dirección" = "dirección"
    "Descripción" = "Descripción"
    "descripción" = "descripción"
    "Categoría" = "Categoría"
    "categoría" = "categoría"
    "Categorías" = "Categorías"
    "categorías" = "categorías"
    "Información" = "Información"
    "información" = "información"
    "Número" = "Número"
    "número" = "número"
    "Código" = "Código"
    "código" = "código"
    "País" = "País"
    "país" = "país"
    "Provincia" = "Provincia"
    "Ciudad" = "Ciudad"
    "¿" = "¿"
    "¡" = "¡"
    "á" = "á"
    "é" = "é"
    "í" = "í"
    "ó" = "ó"
    "ú" = "ú"
    "ñ" = "ñ"
    "Á" = "Á"
    "É" = "É"
    "Í" = "Í"
    "Ó" = "Ó"
    "Ú" = "Ú"
    "Ñ" = "Ñ"
    "â€“" = "–"
    "â€”" = "—"
    "â€˜" = "‘"
    "â€™" = "’"
    "â€œ" = "“"
    "â€" = "”"
    "â€¦" = "…"
}

# Correcciones de textos visibles comunes
$visibleTextReplacements = [ordered]@{
    "Correo electrónico" = "Correo electrónico"
    "Correo Electronico" = "Correo electrónico"
    "Crear cuenta" = "Crear cuenta"
    "Iniciar sesión" = "Iniciar sesión"
    "Cerrar sesión" = "Cerrar sesión"
    "Mascotas perdidas" = "Mascotas perdidas"
    "Aún no tienes mascotas" = "Aún no tienes mascotas"
    "Aún no tienes notificaciones" = "Aún no tienes notificaciones"
    "Aún no tienes notificaciones." = "Aún no tienes notificaciones."
    "Aún no hay reportes" = "Aún no hay reportes"
    "Añadir" = "Añadir"
    "Agregar mascota" = "Agregar mascota"
    "Registra tu primera mascota para gestionar su salud, QR, recordatorios y alertas." = "Registra tu primera mascota para gestionar su salud, QR, recordatorios y alertas."
    "Contraseña" = "Contraseña"
    "Teléfono" = "Teléfono"
}

$report = New-Object System.Collections.Generic.List[string]
$changedFiles = 0

function Should-Skip($path) {
    foreach ($dir in $skipDirs) {
        if ($path.Contains($dir)) {
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

foreach ($file in $files) {
    $path = $file.FullName

    if (Should-Skip $path) {
        continue
    }

    $content = [System.IO.File]::ReadAllText($path)
    $original = $content

    foreach ($key in $replacements.Keys) {
        $content = $content.Replace($key, $replacements[$key])
    }

    foreach ($key in $visibleTextReplacements.Keys) {
        $content = $content.Replace($key, $visibleTextReplacements[$key])
    }

    # Nombre visual: en XML usar entidad para evitar Android mojibake.
    if ($file.Name -eq "strings.xml" -and $content -match "app_name") {
        $content = [regex]::Replace(
            $content,
            '<string name="app_name">.*?</string>',
            '<string name="app_name">Piy&#237;</string>'
        )
    }

    # Dart brand: usar escape Unicode para evitar problemas de encoding.
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

# Buscar posibles restos sospechosos
$suspects = @("Ã", "Â", "â€", "�")
$report.Add("")
$report.Add("---- POSIBLES RESTOS SOSPECHOSOS ----")

foreach ($file in $files) {
    $path = $file.FullName

    if (Should-Skip $path) {
        continue
    }

    $content = [System.IO.File]::ReadAllText($path)

    foreach ($suspect in $suspects) {
        if ($content.Contains($suspect)) {
            $relative = Resolve-Path -Relative $path
            $report.Add("CHECK: $relative contains '$suspect'")
            break
        }
    }
}

$reportDir = ".\docs\audits"
New-Item -ItemType Directory -Force -Path $reportDir | Out-Null

$reportPath = Join-Path $reportDir "Text_Audit_Report_21D.txt"
$report.Insert(0, "Piyí Text Audit 21D")
$report.Insert(1, "Changed files: $changedFiles")
$report.Insert(2, "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
$report.Insert(3, "")

[System.IO.File]::WriteAllText((Resolve-Path $reportDir).Path + "\Text_Audit_Report_21D.txt", ($report -join [Environment]::NewLine), $utf8NoBom)

Write-Host ""
Write-Host "Sprint 21D aplicado." -ForegroundColor Green
Write-Host "Archivos modificados: $changedFiles"
Write-Host "Reporte: docs\audits\Text_Audit_Report_21D.txt" -ForegroundColor Cyan
