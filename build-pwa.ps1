# Baut die installierbare Web-App (PWA) in den Ordner "site".
# Läuft auf Windows (PowerShell) und bei GitHub (pwsh). Keine weiteren Programme nötig.
# Findet die Dateien sowohl in den Unterordnern (pwa/, pwa/icons/) als auch flach im Hauptordner.
param([string]$Build = (Get-Date -Format 'yyyyMMddHHmmss'))
$ErrorActionPreference = 'Stop'

$here = $PSScriptRoot
$root = if ((Test-Path (Join-Path $here 'kegeltab.html')) -or (Test-Path (Join-Path $here 'kegelliste.html'))) { $here } else { Split-Path -Parent $here }
$out  = Join-Path $root 'site'

function Find-File([string]$name, [string[]]$subdirs) {
  foreach ($d in $subdirs + @('')) {
    $p = if ($d) { Join-Path (Join-Path $root $d) $name } else { Join-Path $root $name }
    if (Test-Path $p -PathType Leaf) { return $p }
  }
  throw "Datei fehlt im Repository: $name"
}

if (Test-Path $out) { Remove-Item -Recurse -Force $out }
New-Item -ItemType Directory -Force (Join-Path $out 'icons') | Out-Null

$utf8 = New-Object System.Text.UTF8Encoding($false)
$pageFile = if (Test-Path (Join-Path $root 'kegeltab.html')) { 'kegeltab.html' } else { 'kegelliste.html' }
$page = [IO.File]::ReadAllText((Find-File $pageFile @()), $utf8)

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
<meta name="apple-mobile-web-app-title" content="KegelTab">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="mobile-web-app-capable" content="yes">
<style>:root{padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}[hidden]{display:none!important}img{max-width:100%}</style>
</head>
<body>
"@
$html = $head + "`n" + $page + "`n</body>`n</html>`n"
[IO.File]::WriteAllText((Join-Path $out 'index.html'), $html, $utf8)

$sw = [IO.File]::ReadAllText((Find-File 'sw.js' @('pwa')), $utf8).Replace('__BUILD__', $Build)
[IO.File]::WriteAllText((Join-Path $out 'sw.js'), $sw, $utf8)
Copy-Item (Find-File 'manifest.webmanifest' @('pwa')) $out
foreach ($icon in 'apple-touch-icon.png','favicon-32.png','icon-192.png','icon-512.png','icon-maskable-512.png') {
  Copy-Item (Find-File $icon @('pwa/icons','icons')) (Join-Path $out 'icons')
}
# Damit GitHub Pages die Dateien unverändert ausliefert
[IO.File]::WriteAllText((Join-Path $out '.nojekyll'), '', $utf8)

Write-Host "Web-App gebaut in 'site' (Version $Build)."
