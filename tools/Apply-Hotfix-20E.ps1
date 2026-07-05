$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Hotfix 20E..." -ForegroundColor Cyan

# 1) Fix LostPetService nullable context
$lostPetService = ".\src\Piyi.Infrastructure\Services\LostPetService.cs"

if (Test-Path $lostPetService) {
    $content = Get-Content $lostPetService -Raw

    # Remove previous bad nullable disable
    $content = $content -replace '^\s*#nullable disable\s*\r?\n', ''
    $content = $content -replace '^\s*#nullable enable\s*\r?\n', ''
    $content = $content -replace '^\s*#pragma warning disable CS8601\s*\r?\n', ''

    $content = "#nullable enable`r`n#pragma warning disable CS8601`r`n" + $content

    Set-Content -Path $lostPetService -Value $content -Encoding UTF8
    Write-Host "OK: LostPetService.cs corregido." -ForegroundColor Green
}
else {
    Write-Host "ERROR: No se encontró $lostPetService" -ForegroundColor Red
    exit 1
}

# 2) Replace BusinessReviewConfiguration.cs completely
$reviewConfig = ".\src\Piyi.Infrastructure\Data\Configurations\BusinessReviewConfiguration.cs"

$reviewConfigContent = @'
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class BusinessReviewConfiguration : IEntityTypeConfiguration<BusinessReview>
{
    public void Configure(EntityTypeBuilder<BusinessReview> builder)
    {
        builder.ToTable("BusinessReviews", table =>
        {
            table.HasCheckConstraint(
                "CK_BusinessReviews_Rating",
                "\"Rating\" >= 1 AND \"Rating\" <= 5");
        });

        builder.HasKey(x => x.Id);

        builder.Property(x => x.Comment).HasMaxLength(2000);
        builder.Property(x => x.PhotosJson).HasColumnType("jsonb");
        builder.Property(x => x.BusinessReply).HasMaxLength(2000);
        builder.Property(x => x.ReportReason).HasMaxLength(1000);

        builder.HasOne(x => x.Business)
            .WithMany()
            .HasForeignKey(x => x.BusinessId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(x => x.User)
            .WithMany()
            .HasForeignKey(x => x.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasIndex(x => x.BusinessId);
        builder.HasIndex(x => x.UserId);
        builder.HasIndex(x => x.Rating);
        builder.HasIndex(x => x.IsApproved);
        builder.HasIndex(x => x.IsReported);
        builder.HasIndex(x => x.IsDeleted);
    }
}
'@

Set-Content -Path $reviewConfig -Value $reviewConfigContent -Encoding UTF8
Write-Host "OK: BusinessReviewConfiguration.cs reemplazado." -ForegroundColor Green

# 3) Create/patch Android root build.gradle to force plugin compileSdk 36
$androidRoot = ".\piyi_mobile\android"
$rootGradle = "$androidRoot\build.gradle"

if (Test-Path $androidRoot) {
    if (!(Test-Path $rootGradle)) {
        Write-Host "Creando android/build.gradle..." -ForegroundColor Yellow

        $rootGradleContent = @'
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

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
        Set-Content -Path $rootGradle -Value $rootGradleContent -Encoding UTF8
        Write-Host "OK: android/build.gradle creado." -ForegroundColor Green
    }
    else {
        $content = Get-Content $rootGradle -Raw

        if ($content -notmatch "compileSdk = 36") {
            $block = @'

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
            Write-Host "OK: android/build.gradle ya fuerza compileSdk 36." -ForegroundColor Green
        }
    }
}
else {
    Write-Host "AVISO: No se encontró carpeta Android mobile." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Hotfix 20E aplicado." -ForegroundColor Green
