#requires -Version 5.1
# Solo lectura: no instala ni cambia nada.
$ErrorActionPreference='Continue'
$root=Split-Path -Parent $PSScriptRoot
$env:PATH = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
Write-Host '=== DIAGNOSTICO DE CLAUDE CODE ==='
foreach($cmd in @('git','node','npm','npx','claude','code','bun','uv','playwright-cli','agent-browser','omniroute')) {
    $found=Get-Command $cmd -ErrorAction SilentlyContinue
    if($found) { Write-Host "[OK] $cmd : $($found.Source)" }
    else {Write-Host "[FALTA] $cmd"}
}
$settings=Join-Path $HOME '.claude\settings.json'
if(Test-Path -LiteralPath $settings) {
    try {$null=Get-Content $settings -Raw -Encoding UTF8 | ConvertFrom-Json; Write-Host '[OK] settings.json valido'}
    catch {Write-Host '[ERROR] settings.json invalido'}
} else {Write-Host '[INFO] Aun no existe settings.json'}

$manifest=Get-Content -LiteralPath (Join-Path $root 'config\manifest.json') -Raw -Encoding UTF8 | ConvertFrom-Json
Write-Host "`n--- Skills del manifiesto ---"
foreach($s in @($manifest.skills.skill) + @('playwright-cli','agent-browser','task-observer')) {
    if(Test-Path -LiteralPath (Join-Path $HOME ".claude\skills\$s\SKILL.md")) {Write-Host "[OK] $s"} else {Write-Host "[FALTA] $s"}
}

Write-Host "`n--- Claude-Mem ---"
$launcher=Join-Path $env:LOCALAPPDATA 'claude-mem\bin\claude-mem.exe'
if(Test-Path -LiteralPath $launcher) {
    Write-Host "[OK] Lanzador: $launcher (protocolo $((& $launcher --version 2>$null | Out-String).Trim()))"
    $dir=Split-Path -Parent $launcher
    if(([Environment]::GetEnvironmentVariable('Path','User') -split ';') -contains $dir) {Write-Host '[OK] Lanzador en el PATH de usuario'}
    else {Write-Host '[ERROR] Lanzador fuera del PATH de usuario: npx claude-mem install --provider claude'}
    # Claude Code hereda el PATH del proceso que lo abrio (VS Code); si es antiguo, los hooks no encuentran claude-mem.
    $vscode=Get-Process -Name Code -ErrorAction SilentlyContinue | Sort-Object StartTime | Select-Object -First 1
    if($vscode -and $vscode.StartTime -lt (Get-Item -LiteralPath $launcher).CreationTime) {
        Write-Host '[AVISO] VS Code se abrio antes de instalar el lanzador: cierralo por completo y vuelve a abrirlo'
    }
} else {Write-Host '[FALTA] Lanzador de Claude-Mem (ver docs/CLAUDE-MEM.md)'}
try {
    $h=Invoke-RestMethod -Uri 'http://127.0.0.1:37777/api/health' -TimeoutSec 5
    Write-Host "[OK] Worker $($h.version) en 127.0.0.1:37777 - proveedor: $($h.ai.provider)"
} catch {Write-Host '[INFO] Worker no activo (arranca solo al abrir una sesion de Claude Code)'}
Write-Host '[INFO] npx claude-mem doctor marca "Hook launcher" como error en Windows: es un falso positivo de npx.'

if (Get-Command claude -ErrorAction SilentlyContinue) {
    Write-Host "`n--- Claude Code ---"
    & claude --version
    & claude plugin list
    Write-Host "`n--- PonyTail ---"
    & claude plugin configure ponytail@ponytail
} else {Write-Host 'Claude Code CLI no detectado'}
$report=Join-Path $root '.local\report.json'
if(Test-Path $report) {
    $r=@(Get-Content -LiteralPath $report -Raw -Encoding UTF8 | ConvertFrom-Json)
    Write-Host "`nUltimo informe: $report"
    $r | Where-Object {$_.status -in @('FAILED','PENDING')} | Format-Table label,status,detail -AutoSize
}
Write-Host 'Comprueba tambien dentro de Claude Code: /status y /plugin'
