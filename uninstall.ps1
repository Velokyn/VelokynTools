# Velokyn's Tools - UNINSTALLER (paste-able, no double-click needed)
$ErrorActionPreference = 'SilentlyContinue'
$paths = @(
  (Join-Path $env:APPDATA 'Adobe\CEP\extensions\VelokynTools'),
  (Join-Path $env:CommonProgramFiles 'Adobe\CEP\extensions\VelokynTools')
)
foreach ($p in $paths) {
  if (Test-Path $p) {
    Remove-Item $p -Recurse -Force
    if (Test-Path $p) { Write-Host "  Could not remove $p (run PowerShell as admin)" -ForegroundColor DarkYellow }
    else { Write-Host "  Removed $p" -ForegroundColor Green }
  }
}
Write-Host "`n  Velokyn's Tools removed. Restart After Effects.`n" -ForegroundColor Green
