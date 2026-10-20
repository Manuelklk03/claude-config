#requires -Version 5.1
[CmdletBinding()]
param([switch]$Core)
$root=Split-Path -Parent $PSScriptRoot
if(Test-Path -LiteralPath (Join-Path $root '.git')) {
    Write-Host 'Actualizando los archivos de configuracion desde GitHub...'
    & git.exe -C $root pull --ff-only
    if($LASTEXITCODE -ne 0) {throw 'No se ha podido hacer git pull. Revisa tus cambios locales.'}
} else {Write-Warning 'Esta carpeta procede de un ZIP. Para actualizar los archivos descarga el ZIP nuevo o clona claude-config.'}
$installProfile='Complete'
if($Core){$installProfile='Core'}
& (Join-Path $PSScriptRoot 'install.ps1') -Profile $installProfile

# Actualizar copias de plugins instalados, no solo el listado de marketplaces.
$manifest=Get-Content -LiteralPath (Join-Path $root 'config\manifest.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$installed=Join-Path $HOME '.claude\plugins\installed_plugins.json'
if ((Get-Command claude -ErrorAction SilentlyContinue) -and (Test-Path -LiteralPath $installed)) {
    try {
        $db=Get-Content -LiteralPath $installed -Raw -Encoding UTF8 | ConvertFrom-Json
        foreach ($p in $manifest.plugins) {
            if($Core -and $p.stage -eq 'opcional'){continue}
            if(@($db.plugins.PSObject.Properties.Name) -contains $p.id) {
                Write-Host "Actualizando plugin $($p.id)..."
                & claude plugin update $p.id
                if($LASTEXITCODE -ne 0){Write-Warning "No se ha podido actualizar $($p.id)"}
            }
        }
    } catch {Write-Warning 'No se ha podido interpretar installed_plugins.json para actualizar versiones.'}
}
