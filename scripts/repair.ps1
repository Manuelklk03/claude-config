#requires -Version 5.1
[CmdletBinding()]
param([switch]$Core)
$root=Split-Path -Parent $PSScriptRoot
Write-Host 'Se reintentaran las instalaciones pendientes sin borrar tus plugins existentes.'
$opts=@('-Profile','Complete','-Repair','-CleanStaging')
if($Core) {$opts=@('-Profile','Core','-Repair','-CleanStaging')}
& (Join-Path $PSScriptRoot 'install.ps1') @opts
