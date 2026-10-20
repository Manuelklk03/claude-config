#requires -Version 5.1
[CmdletBinding()]
param([string]$RepoUrl = 'https://github.com/Manuelklk03/claude-config.git')
$ErrorActionPreference='Stop'
$root=Split-Path -Parent $PSScriptRoot
if(-not (Get-Command git.exe -ErrorAction SilentlyContinue)){throw 'Instala Git primero.'}
$work=Join-Path $env:TEMP ('claude-config-upload-'+[guid]::NewGuid().ToString('N').Substring(0,10))
Write-Host "Clonando $RepoUrl"
& git.exe clone $RepoUrl $work
if($LASTEXITCODE -ne 0){throw "No puedo clonar el repositorio. Comprueba que lo has creado y que tienes acceso. No se ha modificado ningun repositorio. Temporal: $work"}
# No se eliminan archivos desconocidos: se sustituyen unicamente los archivos gestionados por el kit.
$files=@('README.md','CLAUDE.md','.gitignore','INSTALAR.cmd','REPARAR.cmd','ACTUALIZAR.cmd','PUBLICAR-EN-GITHUB.cmd',
'config/manifest.json','config/defaults.json',
'scripts/install.ps1','scripts/repair.ps1','scripts/check.ps1','scripts/update.ps1','scripts/publish.ps1','scripts/frontend-deps.ps1',
'docs/CLAUDE-WEB.md','docs/GUIA-HERRAMIENTAS.md','docs/SOLUCIONAR-PROBLEMAS.md')
foreach($relative in $files) {
    $src=Join-Path $root ($relative.Replace('/','\'))
    if(-not(Test-Path $src)){throw "No se encuentra un archivo del kit: $relative"}
    $dst=Join-Path $work ($relative.Replace('/','\'))
    New-Item -ItemType Directory -Path (Split-Path -Parent $dst) -Force | Out-Null
    Copy-Item -LiteralPath $src -Destination $dst -Force
}
& git.exe -C $work add -- @($files)
if($LASTEXITCODE -ne 0){throw "Fallo git add. Temporal conservado en $work"}
$changes=& git.exe -C $work status --porcelain
if(-not $changes){Write-Host 'El repositorio ya esta actualizado.'; Remove-Item -LiteralPath $work -Force -Recurse; exit 0}
& git.exe -C $work commit -m 'chore: update portable Claude Code configuration'
if($LASTEXITCODE -ne 0){throw "Fallo el commit. Temporal conservado en $work"}
& git.exe -C $work push origin HEAD
if($LASTEXITCODE -ne 0){throw "No se pudo hacer push. No uses --force; comprueba el acceso. Temporal: $work"}
Write-Host '[OK] Los archivos del kit estan actualizados en GitHub.'
Remove-Item -LiteralPath $work -Force -Recurse
