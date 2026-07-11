param([Parameter(Mandatory=$true)][string]$BackupFolder)
$ErrorActionPreference="Stop"
$root=(Resolve-Path ".").Path
$backup=(Resolve-Path $BackupFolder).Path
Get-ChildItem $backup -Recurse -File | ForEach-Object {
  $relative=$_.FullName.Substring($backup.Length).TrimStart('\','/')
  $target=Join-Path $root $relative
  New-Item -ItemType Directory -Force -Path (Split-Path $target -Parent) | Out-Null
  Copy-Item $_.FullName $target -Force
  Write-Host "RESTORED: $relative" -ForegroundColor Green
}
