$ErrorActionPreference = "Stop"
Write-Host "Aplicando Piyí Hotfix 20G..." -ForegroundColor Cyan
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# Remove Kotlin MainActivity to avoid startup mismatch
$kotlinMain = ".\piyi_mobile\android\app\src\main\kotlin\com\piyi\mobile\MainActivity.kt"
if (Test-Path $kotlinMain) {
    Remove-Item $kotlinMain -Force
    Write-Host "OK: MainActivity.kt eliminado." -ForegroundColor Green
}

# Java MainActivity
$javaMainDir = ".\piyi_mobile\android\app\src\main\java\com\piyi\mobile"
if (!(Test-Path $javaMainDir)) {
    New-Item -ItemType Directory -Path $javaMainDir -Force | Out-Null
}
$javaMainContent = @'
package com.piyi.mobile;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
}
'@
[System.IO.File]::WriteAllText((Resolve-Path $javaMainDir).Path + "\MainActivity.java", $javaMainContent, $utf8NoBom)
Write-Host "OK: MainActivity.java creado/corregido." -ForegroundColor Green

# Minimal main.dart, no Firebase before runApp
$mainDart = ".\piyi_mobile\lib\main.dart"
$mainDartContent = @'
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app/piyi_app.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('Piyí FlutterError: ${details.exception}');
    };

    runApp(
      const ProviderScope(
        child: PiyiApp(),
      ),
    );
  }, (Object error, StackTrace stackTrace) {
    debugPrint('Piyí startup error: $error');
    debugPrintStack(stackTrace: stackTrace);

    runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No pudimos iniciar Piyí. Cerrá la app e intentá nuevamente.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  });
}
'@
[System.IO.File]::WriteAllText((Resolve-Path $mainDart).Path, $mainDartContent, $utf8NoBom)
Write-Host "OK: main.dart mínimo aplicado." -ForegroundColor Green

# Safe Firebase bootstrap, disabled by default
$firebaseDir = ".\piyi_mobile\lib\src\core\bootstrap"
if (!(Test-Path $firebaseDir)) {
    New-Item -ItemType Directory -Path $firebaseDir -Force | Out-Null
}
$firebaseBootstrapContent = @'
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseBootstrap {
  const FirebaseBootstrap._();

  static Future<bool> tryInitialize() async {
    const enabled = bool.fromEnvironment(
      'PIYI_ENABLE_FIREBASE',
      defaultValue: false,
    );

    if (!enabled) {
      debugPrint('Piyí Firebase disabled for beta startup.');
      return false;
    }

    try {
      if (Firebase.apps.isNotEmpty) {
        return true;
      }

      await Firebase.initializeApp();
      debugPrint('Piyí Firebase initialized.');
      return true;
    } catch (error, stackTrace) {
      debugPrint('Piyí Firebase initialization skipped: $error');
      debugPrintStack(stackTrace: stackTrace);
      return false;
    }
  }
}
'@
[System.IO.File]::WriteAllText((Resolve-Path $firebaseDir).Path + "\firebase_bootstrap.dart", $firebaseBootstrapContent, $utf8NoBom)
Write-Host "OK: FirebaseBootstrap seguro aplicado." -ForegroundColor Green

# strings.xml
$valuesDir = ".\piyi_mobile\android\app\src\main\res\values"
if (!(Test-Path $valuesDir)) {
    New-Item -ItemType Directory -Path $valuesDir -Force | Out-Null
}
$stringsXml = @'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Piyí</string>
    <string name="google_maps_api_key">REEMPLAZAR_GOOGLE_MAPS_API_KEY</string>
</resources>
'@
[System.IO.File]::WriteAllText((Resolve-Path $valuesDir).Path + "\strings.xml", $stringsXml, $utf8NoBom)
Write-Host "OK: strings.xml corregido." -ForegroundColor Green

# Manifest
$manifest = ".\piyi_mobile\android\app\src\main\AndroidManifest.xml"
$manifestContent = @'
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32" />

    <queries>
        <package android:name="com.google.android.apps.maps" />
    </queries>

    <application
        android:label="@string/app_name"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:usesCleartextTraffic="false">

        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="@string/google_maps_api_key" />

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:taskAffinity=""
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">

            <meta-data
                android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme" />

            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>

        <meta-data android:name="flutterEmbedding" android:value="2" />
    </application>
</manifest>
'@
[System.IO.File]::WriteAllText((Resolve-Path $manifest).Path, $manifestContent, $utf8NoBom)
Write-Host "OK: AndroidManifest.xml corregido." -ForegroundColor Green

# app build.gradle: ensure app id and copy fix
$appGradle = ".\piyi_mobile\android\app\build.gradle"
if (Test-Path $appGradle) {
    $content = Get-Content $appGradle -Raw
    $content = $content -replace '(?m)^\s*id\s+"kotlin-android"\s*\r?\n?', ''
    $content = $content -replace 'namespace\s+"[^"]+"', 'namespace "com.piyi.mobile"'
    $content = $content -replace 'applicationId\s+"[^"]+"', 'applicationId "com.piyi.mobile"'
    $content = $content -replace 'compileSdk\s+\d+', 'compileSdk 36'
    $content = $content -replace 'targetSdk\s+\d+', 'targetSdk 36'

    if ($content -notmatch "PIYI_COPY_APK_FOR_FLUTTER_RUN") {
        $copyBlock = @'

/*
 * PIYI_COPY_APK_FOR_FLUTTER_RUN
 * Ensures Flutter can find APK after Gradle builds.
 */
tasks.register("copyDebugApkForFlutter") {
    dependsOn("assembleDebug")
    doLast {
        def sourceApk = file("$buildDir/outputs/apk/debug/app-debug.apk")
        def targetDir = file("../../build/app/outputs/flutter-apk")
        def targetApk = file("../../build/app/outputs/flutter-apk/app-debug.apk")
        if (sourceApk.exists()) {
            targetDir.mkdirs()
            targetApk.bytes = sourceApk.bytes
            println("Copied debug APK to Flutter expected path: " + targetApk)
        }
    }
}

tasks.register("copyReleaseApkForFlutter") {
    dependsOn("assembleRelease")
    doLast {
        def sourceApk = file("$buildDir/outputs/apk/release/app-release.apk")
        def targetDir = file("../../build/app/outputs/flutter-apk")
        def targetApk = file("../../build/app/outputs/flutter-apk/app-release.apk")
        if (sourceApk.exists()) {
            targetDir.mkdirs()
            targetApk.bytes = sourceApk.bytes
            println("Copied release APK to Flutter expected path: " + targetApk)
        }
    }
}

afterEvaluate {
    tasks.matching { it.name == "assembleDebug" }.configureEach {
        finalizedBy("copyDebugApkForFlutter")
    }
    tasks.matching { it.name == "assembleRelease" }.configureEach {
        finalizedBy("copyReleaseApkForFlutter")
    }
}
'@
        $content = $content + "`r`n" + $copyBlock
    }
    [System.IO.File]::WriteAllText((Resolve-Path $appGradle).Path, $content, $utf8NoBom)
    Write-Host "OK: android/app/build.gradle revisado." -ForegroundColor Green
}

# gradle.properties cleanup
$gradleProps = ".\piyi_mobile\android\gradle.properties"
if (Test-Path $gradleProps) {
    $content = Get-Content $gradleProps -Raw
    $content = $content -replace '(?m)^\s*android\.builtInKotlin\s*=.*\r?\n?', ''
    $content = $content -replace '(?m)^\s*android\.newDsl\s*=.*\r?\n?', ''
    [System.IO.File]::WriteAllText((Resolve-Path $gradleProps).Path, $content, $utf8NoBom)
    Write-Host "OK: gradle.properties limpio." -ForegroundColor Green
}

Write-Host ""
Write-Host "Hotfix 20G aplicado." -ForegroundColor Green
