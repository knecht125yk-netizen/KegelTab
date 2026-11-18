# Baut die installierbare Web-App (PWA) in den Ordner "site".
# Läuft auf Windows (PowerShell) und bei GitHub (pwsh). Keine weiteren Programme nötig.
param([string]$Build = (Get-Date -Format 'yyyyMMddHHmmss'))
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$out  = Join-Path $root 'site'

if (Test-Path $out) { Remove-Item -Recurse -Force $out }
New-Item -ItemType Directory -Force (Join-Path $out 'icons') | Out-Null

$utf8 = New-Object System.Text.UTF8Encoding($false)
$page = [IO.File]::ReadAllText((Join-Path $root 'kegelliste.html'), $utf8)

$head = @"
<!doctype html>
<html lang="de">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
<meta name="kl-pwa" content="$Build">
<link rel="manifest" href="manifest.webmanifest">
<link rel="apple-touch-icon" href="icons/apple-touch-icon.png">
<link rel="icon" type="image/png" href="icons/favicon-32.png">
<meta name="apple-mobile-web-app-title" content="Kegelliste">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="mobile-web-app-capable" content="yes">
<style>:root{padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}[hidden]{display:none!important}img{max-width:100%}</style>
</head>
<body>
"@
$html = $head + "`n" + $page + "`n</body>`n</html>`n"
[IO.File]::WriteAllText((Join-Path $out 'index.html'), $html, $utf8)

$sw = [IO.File]::ReadAllText((Join-Path $root 'pwa/sw.js'), $utf8).Replace('__BUILD__', $Build)
[IO.File]::WriteAllText((Join-Path $out 'sw.js'), $sw, $utf8)
Copy-Item (Join-Path $root 'pwa/manifest.webmanifest') $out
Copy-Item (Join-Path $root 'pwa/icons/*') (Join-Path $out 'icons')
# Damit GitHub Pages die Dateien unverändert ausliefert
[IO.File]::WriteAllText((Join-Path $out '.nojekyll'), '', $utf8)

Write-Host "Web-App gebaut in 'site' (Version $Build)."
