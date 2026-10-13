# Velokyn's Tools - ONE-LINE ONLINE INSTALLER
# Host this file in your GitHub repo. Edit $UpdateJson ONCE (raw link to your update.json).
$UpdateJson = 'https://raw.githubusercontent.com/Velokyn/VelokynTools/main/update.json'

$ErrorActionPreference = 'Stop'
Write-Host "`n  Installing Velokyn's Tools..." -ForegroundColor Yellow
$j   = Invoke-RestMethod $UpdateJson
$tmp = Join-Path $env:TEMP 'vt_install'
Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
New-Item $tmp -ItemType Directory | Out-Null
Write-Host "  Downloading v$($j.version)..."
Invoke-WebRequest $j.url -OutFile "$tmp\vt.zip" -UseBasicParsing
if ($j.sha256 -and ((Get-FileHash "$tmp\vt.zip" -Algorithm SHA256).Hash -ne $j.sha256)) { throw 'Download is corrupted (checksum mismatch).' }
Expand-Archive "$tmp\vt.zip" "$tmp\x" -Force

$dest = Join-Path $env:APPDATA 'Adobe\CEP\extensions\VelokynTools'
$old2 = Join-Path $env:CommonProgramFiles 'Adobe\CEP\extensions\VelokynTools'
foreach ($p in @($dest, $old2)) { if (Test-Path $p) { try { Remove-Item $p -Recurse -Force } catch { Write-Host "  (could not remove $p - run as admin to clean it)" -ForegroundColor DarkYellow } } }
New-Item (Split-Path $dest) -ItemType Directory -Force | Out-Null
Copy-Item "$tmp\x\VelokynTools" $dest -Recurse -Force

foreach ($v in 9..14) { $k = "HKCU:\Software\Adobe\CSXS.$v"; New-Item $k -Force | Out-Null; New-ItemProperty $k -Name PlayerDebugMode -Value '1' -PropertyType String -Force | Out-Null }

if (Get-Command winget -ErrorAction SilentlyContinue) {
  Write-Host "  Installing helpers (ffmpeg + deno) for subtitles & downloads..."
  foreach ($id in 'Gyan.FFmpeg','DenoLand.Deno') { try { winget install -e --id $id --silent --accept-package-agreements --accept-source-agreements | Out-Null } catch {} }
}
Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "`n  Done! Restart After Effects > Window > Extensions > Velokyn's Tools`n" -ForegroundColor Green
