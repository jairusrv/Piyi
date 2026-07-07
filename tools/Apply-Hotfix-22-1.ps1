$ErrorActionPreference = "Stop"

Write-Host "Aplicando Piyí Hotfix 22-1 - RC1 Analyze Errors Fix..." -ForegroundColor Cyan

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Save-NoBom($path, $content) {
    [System.IO.File]::WriteAllText((Resolve-Path $path).Path, $content, $utf8NoBom)
}

# 1) Arreglar import innecesario/autorreferenciado en piyi_app_back_button.dart
$back = ".\piyi_mobile\lib\src\core\navigation\piyi_app_back_button.dart"
if (Test-Path $back) {
    $content = Get-Content $back -Raw
    $content = [regex]::Replace($content, "(?m)^\s*import\s+'package:piyi_mobile/src/core/navigation/piyi_app_back_button\.dart';\s*\r?\n", "")
    Save-NoBom $back $content
    Write-Host "OK: piyi_app_back_button.dart limpio." -ForegroundColor Green
}

# 2) Corregir AboutScreen: PiyiLogoHeader(size:) -> PiyiLogoHeader(width:)
$about = ".\piyi_mobile\lib\src\features\settings\presentation\about_screen.dart"
if (Test-Path $about) {
    $content = Get-Content $about -Raw
    $content = $content -replace "PiyiLogoHeader\(\s*size\s*:", "PiyiLogoHeader(width:"
    Save-NoBom $about $content
    Write-Host "OK: about_screen.dart usa width." -ForegroundColor Green
}

# 3) Agregar métodos de sesión faltantes a SecureStorageService
$storageFiles = Get-ChildItem ".\piyi_mobile\lib" -Recurse -Filter "*.dart" | Where-Object {
    Select-String -Path $_.FullName -Pattern "class SecureStorageService" -Quiet
}

if ($storageFiles.Count -eq 0) {
    Write-Host "AVISO: No se encontró SecureStorageService." -ForegroundColor Yellow
}
else {
    foreach ($file in $storageFiles) {
        $path = $file.FullName
        $content = Get-Content $path -Raw
        $original = $content

        if ($content -notmatch "Future<String\?>\s+getRefreshToken") {
            $methods = @'

  Future<String?> getRefreshToken() async {
    return read('refresh_token');
  }

  Future<void> saveRefreshToken(String? refreshToken) async {
    if (refreshToken == null || refreshToken.isEmpty) {
      return;
    }

    await write('refresh_token', refreshToken);
  }

  Future<void> saveUserData({
    String? firstName,
    String? lastName,
    String? fullName,
    String? email,
    String? phoneNumber,
  }) async {
    if (firstName != null && firstName.isNotEmpty) {
      await write('firstName', firstName);
    }

    if (lastName != null && lastName.isNotEmpty) {
      await write('lastName', lastName);
    }

    if (fullName != null && fullName.isNotEmpty) {
      await write('fullName', fullName);
    }

    if (email != null && email.isNotEmpty) {
      await write('email', email);
    }

    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      await write('phoneNumber', phoneNumber);
    }
  }

  Future<void> clearAllSession() async {
    await delete('access_token');
    await delete('token');
    await delete('auth_token');
    await delete('jwt');
    await delete('refresh_token');
    await delete('firstName');
    await delete('lastName');
    await delete('fullName');
    await delete('email');
    await delete('phoneNumber');
  }
'@

            $lastBrace = $content.LastIndexOf("}")
            if ($lastBrace -gt 0) {
                $content = $content.Insert($lastBrace, $methods + "`r`n")
            }
        }

        if ($content -ne $original) {
            Save-NoBom $path $content
            Write-Host "OK: métodos agregados a $path" -ForegroundColor Green
        }
        else {
            Write-Host "OK: SecureStorageService ya tenía métodos requeridos." -ForegroundColor Green
        }
    }
}

Write-Host ""
Write-Host "Hotfix 22-1 aplicado." -ForegroundColor Green
Write-Host "Ejecuta:" -ForegroundColor Cyan
Write-Host "cd .\piyi_mobile"
Write-Host "flutter analyze --no-fatal-infos"
Write-Host "flutter run --dart-define=PIYI_API_BASE_URL=https://piyi.onrender.com"
