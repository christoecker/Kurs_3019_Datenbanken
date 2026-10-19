# Baut die Dozenten-Skripte (Markdown -> PDF). Aufruf aus beliebigem Ordner:
#   .\build-skripte.ps1            alle Skripte
#   .\build-skripte.ps1 termin-01  nur einen Termin
# Voraussetzungen: pandoc, xelatex (MiKTeX), mermaid-cli (npm i -g @mermaid-js/mermaid-cli)
param([string]$Termin = "*")
$ErrorActionPreference = "Stop"
$werkzeuge = $PSScriptRoot
$root = Resolve-Path (Join-Path $werkzeuge "..\..\..")
Set-Location $root
$env:SKRIPT_CACHE = "docs/02-theoriephase/_skript-werkzeuge/cache"
$env:SKRIPT_DOCS = "docs"
New-Item -ItemType Directory -Force $env:SKRIPT_CACHE | Out-Null
Get-ChildItem "docs/02-theoriephase/$Termin/skript/*.md" | ForEach-Object {
    $pdf = [IO.Path]::ChangeExtension($_.FullName, ".pdf")
    Write-Host "Baue $($_.Name) ..."
    pandoc $_.FullName -o $pdf --pdf-engine=xelatex `
        --lua-filter="$werkzeuge/skript.lua" -H "$werkzeuge/skript-header.tex" `
        -V papersize=a4 -V classoption=table -V fontsize=11pt -V geometry:margin=1.5cm `
        -V geometry:top=1.7cm -V geometry:bottom=1.8cm `
        --syntax-highlighting=tango -f markdown+pipe_tables+fenced_divs+bracketed_spans
    if ($LASTEXITCODE -ne 0) { throw "pandoc fehlgeschlagen: $($_.Name)" }
}
