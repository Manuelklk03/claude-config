#requires -Version 5.1
$ErrorActionPreference='Continue'
$root=Split-Path -Parent $PSScriptRoot
Write-Host '=== DIAGNOSTICO DE CLAUDE CODE ==='
foreach($cmd in @('git','node','npm','npx','claude','code','playwright-cli','agent-browser','omniroute')) {
    $found=Get-Command $cmd -ErrorAction SilentlyContinue
    if($found) { Write-Host "[OK] $cmd : $($found.Source)" }
    else {Write-Host "[FALTA] $cmd"}
}
$settings=Join-Path $HOME '.claude\settings.json'
if(Test-Path -LiteralPath $settings) {
    try {$null=Get-Content $settings -Raw -Encoding UTF8 | ConvertFrom-Json; Write-Host '[OK] settings.json valido'}
    catch {Write-Host '[ERROR] settings.json invalido'}
} else {Write-Host '[INFO] Aun no existe settings.json'}
if (Get-Command claude -ErrorAction SilentlyContinue) {
    & claude --version
    & claude plugin list
} else {Write-Host 'Claude Code CLI no detectado'}
$report=Join-Path $root '.local\report.json'
if(Test-Path $report) {
    $r=@(Get-Content -LiteralPath $report -Raw -Encoding UTF8 | ConvertFrom-Json)
    Write-Host "`nUltimo informe: $report"
    $r | Where-Object {$_.status -in @('FAILED','PENDING')} | Format-Table label,status,detail -AutoSize
}
Write-Host 'Comprueba tambien dentro de Claude Code: /status y /plugin'
