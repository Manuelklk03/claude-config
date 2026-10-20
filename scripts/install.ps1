#requires -Version 5.1
param(
  [switch]$IncludeOptional,
  [switch]$IncludeOmniRoute,
  [switch]$IncludeReferences,
  [switch]$SkipNpm,
  [switch]$SkipSkills,
  [switch]$SkipPlugins,
  [switch]$SkipTaskObserver,
  [switch]$SkipVSCode
)
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$manifest = Get-Content (Join-Path $repo 'config\manifest.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$claudeDir = Join-Path $HOME '.claude'
$logDir = Join-Path $repo '.local'
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$log = Join-Path $logDir 'install.log'
$failed = New-Object System.Collections.Generic.List[string]
$ok = New-Object System.Collections.Generic.List[string]
function Log([string]$message) { Write-Host $message; Add-Content -Path $log -Value $message -Encoding UTF8 }
function Run([string]$label,[string]$exe,[string[]]$arguments) {
  # npm instala lanzadores .ps1 y .cmd; utilizar .cmd evita errores por ExecutionPolicy.
  if ($exe -in @('npm','npx','agent-browser','playwright-cli')) { $exe += '.cmd' }
  if (-not (Get-Command $exe -ErrorAction SilentlyContinue)) { Log "[PENDIENTE] $label - No se encuentra $exe"; $failed.Add($label); return }
  Log "[EJECUTANDO] $label"
  $previousPreference = $ErrorActionPreference
  try {
    $ErrorActionPreference = 'Continue'
    $output = & $exe @arguments 2>&1 | Out-String
    $code = $LASTEXITCODE
    if ($output.Trim()) { Log $output.Trim() }
    if ($code -eq 0) { $ok.Add($label); Log "[OK] $label" }
    else { Log "[REVISAR] $label (codigo $code; si dice 'already exists', puede estar instalado)"; $failed.Add($label) }
  } catch { Log "[ERROR] $label - $($_.Exception.Message)"; $failed.Add($label) }
  finally { $ErrorActionPreference = $previousPreference }
}
Log '=== INSTALADOR GLOBAL CLAUDE - WINDOWS ==='
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw 'Instala Git antes de continuar.' }
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) { throw 'Instala y autentica Claude Code CLI (comando claude) antes de continuar.' }
if (-not $SkipSkills -or -not $SkipNpm) {
 if (-not (Get-Command node -ErrorAction SilentlyContinue)) { throw 'Falta Node.js 22.20+.' }
 $ver = (& node --version).Trim()
 if ($ver -match '^v(\d+)\.(\d+)\.') {
    $major=[int]$Matches[1]; $minor=[int]$Matches[2]
    if ($major -lt 22 -or ($major -eq 22 -and $minor -lt 20)) {throw "Node $ver es antiguo; actualiza a >=22.20."}
 }
}
if (Test-Path (Join-Path $claudeDir 'settings.json')) {
 $backup = Join-Path $logDir ('settings.backup.'+(Get-Date -Format 'yyyyMMdd-HHmmss')+'.json')
 Copy-Item (Join-Path $claudeDir 'settings.json') $backup
 Log "[COPIA] Configuracion previa en $backup"
}
# Reglas personales compartibles, sin sobrescribir las ya existentes.
New-Item -ItemType Directory -Force -Path $claudeDir | Out-Null
$globalRules = Join-Path $claudeDir 'CLAUDE.md'
if (-not (Test-Path $globalRules)) {
 Copy-Item (Join-Path $repo 'CLAUDE.md') $globalRules
 Log '[OK] Reglas globales CLAUDE.md copiadas.'
} else { Log '[INFO] CLAUDE.md global existente: preservado; fusiona reglas del kit manualmente si deseas.' }
if (-not $SkipVSCode -and (Get-Command code -ErrorAction SilentlyContinue)) {
 Run 'Extension oficial VS Code' 'code' @('--install-extension','anthropic.claude-code','--force')
} else { Log '[INFO] VS Code: si no existe code en PATH, instala la extension Anthropic.claude-code a mano.' }
if (-not $SkipPlugins) {
 Log '[INFO] Los plugins ejecutan codigo local (hooks y MCP). Instala solo repositorios que hayas revisado.'
 foreach($m in $manifest.marketplaces) {
    if ($m.id -in @('anti-ai-slop','caveman','headroom-marketplace') -and -not $IncludeOptional) { continue }
    Run "Marketplace $($m.id)" 'claude' @('plugin','marketplace','add',$m.source)
 }
 foreach($p in $manifest.plugins) {
    if ($p.stage -eq 'opcional' -and -not $IncludeOptional) { continue }
    Run "Plugin $($p.id)" 'claude' @('plugin','install',$p.id,'--scope','user')
 }
}
if (-not $SkipSkills) {
 foreach($s in $manifest.skills) {
    Run "Skill $($s.skill)" 'npx' @('-y','skills@latest','add',$s.source,'--skill',$s.skill,'-g','-a','claude-code','-y')
 }
 # Verificacion, no instala una segunda copia del Agent Browser: se instala via npm por separado
}
if (-not $SkipNpm) {
 foreach ($p in $manifest.npmGlobal) { Run "NPM $($p.pkg)" 'npm' @('install','-g',$p.pkg) }
 if (Get-Command playwright-cli.cmd -ErrorAction SilentlyContinue) {
    Run 'Skill Playwright CLI global' 'playwright-cli' @('install','--skills','-g')
 }
 if (Get-Command agent-browser.cmd -ErrorAction SilentlyContinue) {
    Run 'Instalar navegador Agent Browser' 'agent-browser' @('install')
    if (-not $SkipSkills) {Run 'Skill Agent Browser global' 'npx' @('-y','skills@latest','add','vercel-labs/agent-browser','--skill','agent-browser','-g','-a','claude-code','-y')}
 }
 if($IncludeOmniRoute) { Run 'OmniRoute CLI (SIN conectar proveedores)' 'npm' @('install','-g','omniroute') }
}
if (-not $SkipTaskObserver) {
 $target = Join-Path $claudeDir 'skills\task-observer'
 $temp = Join-Path $logDir 'task-observer-src'
 if (Test-Path $temp) {Remove-Item $temp -Force -Recurse}
 Run 'Descargar Task Observer' 'git' @('clone','--depth','1','https://github.com/SquidyInk/task-observer.git',$temp)
 if ((Test-Path (Join-Path $temp 'SKILL.md')) -and (Test-Path (Join-Path $temp 'references'))) {
   New-Item -ItemType Directory -Force -Path $target | Out-Null
   Copy-Item (Join-Path $temp 'SKILL.md') $target -Force
   Copy-Item (Join-Path $temp 'references') $target -Recurse -Force
   Log '[OK] Task Observer (SKILL.md + references)'
 } else { Log '[REVISAR] Task Observer - SKILL.md o references ausentes'; $failed.Add('Task Observer') }
}
if ($IncludeReferences) {
 $target=Join-Path $claudeDir 'references\awesome-design-md'
 if (-not (Test-Path (Join-Path $target '.git'))) {
   New-Item -ItemType Directory -Force -Path (Split-Path -Parent $target) | Out-Null
   Run 'Clonar Awesome DESIGN.md (REFERENCIAS)' 'git' @('clone','--depth','1','https://github.com/VoltAgent/awesome-design-md.git',$target)
 } else {Run 'Actualizar Awesome DESIGN.md' 'git' @('-C',$target,'pull','--ff-only')}
}
Log ''
Log "=== FINAL: $($ok.Count) pasos correctos; $($failed.Count) a revisar ==="
foreach($f in $failed) {Log "  - $f"}
Log 'Reinicia VS Code y Claude Code. Verifica: claude plugin list ; npx skills ls -g'
Log 'No ejecutes OmniRoute setup-claude ni sobreescribas ~/.claude/settings.json sin revisar.'
Log "Log: $log"
