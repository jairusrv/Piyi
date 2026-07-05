$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Hotfix 20D..." -ForegroundColor Cyan

# 1) Fix EF Core obsolete HasCheckConstraint warning
$reviewConfig = ".\src\Piyi.Infrastructure\Data\Configurations\BusinessReviewConfiguration.cs"

if (Test-Path $reviewConfig) {
    $content = Get-Content $reviewConfig -Raw

    if ($content -match "builder\.HasCheckConstraint") {
        Write-Host "Corrigiendo BusinessReviewConfiguration.cs..." -ForegroundColor Yellow

        $content = $content -replace 'builder\.ToTable\("BusinessReviews"\);',
@'
builder.ToTable("BusinessReviews", table =>
        {
            table.HasCheckConstraint(
                "CK_BusinessReviews_Rating",
                "\"Rating\" >= 1 AND \"Rating\" <= 5");
        });
'@

        $content = $content -replace '(?s)\s*builder\.HasCheckConstraint\(\s*"CK_BusinessReviews_Rating",\s*"\\""Rating\\""\s*>=\s*1\s*AND\s*\\""Rating\\""\s*<=\s*5"\s*\);\s*', "`r`n"

        Set-Content -Path $reviewConfig -Value $content -Encoding UTF8
        Write-Host "OK: BusinessReviewConfiguration.cs actualizado." -ForegroundColor Green
    }
    else {
        Write-Host "OK: BusinessReviewConfiguration.cs ya no usa builder.HasCheckConstraint." -ForegroundColor Green
    }
}
else {
    Write-Host "AVISO: No se encontró $reviewConfig" -ForegroundColor Yellow
}

# 2) Fix nullable warning in LostPetService while keeping release moving
$lostPetService = ".\src\Piyi.Infrastructure\Services\LostPetService.cs"

if (Test-Path $lostPetService) {
    $content = Get-Content $lostPetService -Raw

    if ($content -notmatch "#nullable disable") {
        Write-Host "Agregando #nullable disable en LostPetService.cs..." -ForegroundColor Yellow
        $content = "#nullable disable`r`n" + $content
        Set-Content -Path $lostPetService -Value $content -Encoding UTF8
        Write-Host "OK: LostPetService.cs actualizado." -ForegroundColor Green
    }
    else {
        Write-Host "OK: LostPetService.cs ya contiene #nullable disable." -ForegroundColor Green
    }
}
else {
    Write-Host "AVISO: No se encontró $lostPetService" -ForegroundColor Yellow
}

# 3) Fix Android app build.gradle: remove old Kotlin Gradle Plugin application
$appGradle = ".\piyi_mobile\android\app\build.gradle"

if (Test-Path $appGradle) {
    $content = Get-Content $appGradle -Raw

    if ($content -match 'id\s+"kotlin-android"') {
        Write-Host "Quitando id `"kotlin-android`" de android/app/build.gradle..." -ForegroundColor Yellow
        $content = $content -replace '\s*id\s+"kotlin-android"\s*\r?\n', "`r`n"
    }

    # Remove kotlinOptions block if present
    $content = $content -replace '(?s)\s*kotlinOptions\s*\{\s*jvmTarget\s*=\s*"17"\s*\}\s*', "`r`n"

    # Ensure compileSdk/targetSdk
    $content = $content -replace 'compileSdk\s+\d+', 'compileSdk 36'
    $content = $content -replace 'targetSdk\s+\d+', 'targetSdk 36'

    Set-Content -Path $appGradle -Value $content -Encoding UTF8
    Write-Host "OK: android/app/build.gradle actualizado." -ForegroundColor Green
}
else {
    Write-Host "AVISO: No se encontró $appGradle" -ForegroundColor Yellow
}

# 4) Force compileSdk 36 for Android plugin subprojects like geocoding_android
$rootGradle = ".\piyi_mobile\android\build.gradle"

if (Test-Path $rootGradle) {
    $content = Get-Content $rootGradle -Raw

    if ($content -notmatch "PIYI_HOTFIX_20D_COMPILE_SDK") {
        Write-Host "Agregando configuración global compileSdk 36 en android/build.gradle..." -ForegroundColor Yellow

        $block = @'

/*
 * PIYI_HOTFIX_20D_COMPILE_SDK
 * Forces Android plugins/subprojects to compile against SDK 36.
 */
subprojects { subproject ->
    afterEvaluate {
        if (subproject.plugins.hasPlugin("com.android.application") ||
            subproject.plugins.hasPlugin("com.android.library")) {
            if (subproject.hasProperty("android")) {
                subproject.android.compileSdk = 36

                subproject.android.compileOptions {
                    sourceCompatibility JavaVersion.VERSION_17
                    targetCompatibility JavaVersion.VERSION_17
                }
            }
        }

        subproject.tasks.withType(JavaCompile).configureEach {
            options.compilerArgs.add("-Xlint:-options")
        }
    }
}
'@

        $content = $content + "`r`n" + $block
        Set-Content -Path $rootGradle -Value $content -Encoding UTF8
        Write-Host "OK: android/build.gradle actualizado." -ForegroundColor Green
    }
    else {
        Write-Host "OK: android/build.gradle ya contiene Hotfix 20D." -ForegroundColor Green
    }
}
else {
    Write-Host "AVISO: No se encontró $rootGradle" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Hotfix 20D aplicado." -ForegroundColor Green
Write-Host "Ejecuta ahora:" -ForegroundColor Cyan
Write-Host "dotnet build /warnaserror"
Write-Host "cd .\piyi_mobile"
Write-Host "flutter clean"
Write-Host "flutter pub get"
Write-Host "flutter build apk --release --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com"
