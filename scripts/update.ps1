param([switch]$IncludeOptional,[switch]$IncludeOmniRoute,[switch]$IncludeReferences)
$ErrorActionPreference='Stop'
$root=Split-Path -Parent $PSScriptRoot
Set-Location $root
if ((Test-Path '.git') -and (Get-Command git -ErrorAction SilentlyContinue)) {
 git pull --ff-only
 if($LASTEXITCODE -ne 0){throw 'Git pull falló. Resuelve los cambios locales antes de continuar.'}
}
& (Join-Path $PSScriptRoot 'install.ps1') -IncludeOptional:$IncludeOptional -IncludeOmniRoute:$IncludeOmniRoute -IncludeReferences:$IncludeReferences
