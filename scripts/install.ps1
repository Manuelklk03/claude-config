#requires -Version 5.1
[CmdletBinding()]
param(
    [ValidateSet('Complete','Core')][string]$Profile = 'Complete',
    [switch]$Repair,
    [switch]$CleanStaging,
    [switch]$SkipNpm,
    [switch]$SkipSkills,
    [switch]$SkipVSCode,
    [switch]$SkipClaudeMem,
    [switch]$SkipReferences
)
$ErrorActionPreference = 'Stop'
# Una terminal abierta antes de instalar algo no ve el PATH nuevo: releerlo del registro.
$env:PATH = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
$env:CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS = '900000'
$env:CLAUDE_CODE_PLUGIN_PREFER_HTTPS = '1'
$root = Split-Path -Parent $PSScriptRoot
$manifest = Get-Content -LiteralPath (Join-Path $root 'config\manifest.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$defaults = Get-Content -LiteralPath (Join-Path $root 'config\defaults.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$claudeHome = Join-Path $HOME '.claude'
$logs = Join-Path $root '.local'
New-Item -ItemType Directory -Path $logs -Force | Out-Null
New-Item -ItemType Directory -Path $claudeHome -Force | Out-Null
$log = Join-Path $logs 'install.log'
$results = New-Object System.Collections.ArrayList
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'

function Say([string]$s) {
    Write-Host $s
    Add-Content -LiteralPath $log -Value $s -Encoding UTF8
}
function Record([string]$label,[string]$state,[string]$detail) {
    [void]$results.Add([pscustomobject]@{label=$label;status=$state;detail=$detail})
    Say "[$state] $label - $detail"
}
function Have([string]$command) {
    return ($null -ne (Get-Command $command -ErrorAction SilentlyContinue))
}
function Exec([string]$label,[string]$exe,[string[]]$a) {
    if (-not (Have $exe)) {Record $label 'PENDING' "No se encuentra: $exe"; return $false}
    Say "[RUN] $label"
    $old=$ErrorActionPreference
    try {
        # Las herramientas nativas envian avisos normales a stderr: no interpretarlos automaticamente como excepciones.
        $ErrorActionPreference='Continue'
        $textOut = (& $exe @a 2>&1 | Out-String)
        $exitCode = $LASTEXITCODE
        if ($textOut.Trim()) { Add-Content -LiteralPath $log -Value $textOut -Encoding UTF8 }
        if ($exitCode -eq 0) {Record $label 'OK' 'Completado'; return $true}
        Record $label 'FAILED' "Codigo $exitCode. Ver .local/install.log"; return $false
    } catch {Record $label 'FAILED' $_.Exception.Message; return $false}
    finally {$ErrorActionPreference=$old}
}
function InstalledPlugin([string]$id) {
    $path=Join-Path $claudeHome 'plugins\installed_plugins.json'
    if (-not (Test-Path -LiteralPath $path)) {return $false}
    try {
        $j=Get-Content -LiteralPath $path -Raw -Encoding UTF8 | ConvertFrom-Json
        if($j.plugins) {return (@($j.plugins.PSObject.Properties.Name) -contains $id)}
    } catch {}
    return $false
}
function InstalledSkill([string]$name) {
    return (Test-Path -LiteralPath (Join-Path $claudeHome "skills\$name\SKILL.md"))
}
function TryMarketplace([object]$item) {
    # Dejar que Claude valide el catalogo; 'already on disk' finaliza con exito.
    return (Exec "Marketplace $($item.id)" 'claude' @('plugin','marketplace','add', $item.source))
}
function Clean-TemporaryClone {
    if (-not $CleanStaging) {return}
    $dir=Join-Path $claudeHome 'plugins\marketplaces'
    $allowed = @('thedotmack-claude-mem..clone','headroomlabs-ai-headroom..clone')
    if (Get-Process -Name git -ErrorAction SilentlyContinue) {
        Say '[WARN] Git esta ejecutandose: no borro carpetas temporales.'
        return
    }
    foreach($n in $allowed) {
        $p=Join-Path $dir $n
        if (Test-Path -LiteralPath $p) {
            try {Remove-Item -LiteralPath $p -Recurse -Force -ErrorAction Stop; Say "[OK] Temporal limpiado: $n"}
            catch {Say "[WARN] No se pudo limpiar $n : $($_.Exception.Message)"}
        }
    }
}
try {
    Say "=== CLAUDE CONFIG PORTABLE v2.2 - WINDOWS - $(Get-Date -Format 'yyyy-MM-dd HH:mm') - perfil $Profile ==="
    if (-not (Have 'git.exe')) {throw 'Necesitas Git. Usa winget install --id Git.Git -e'}
    if (-not (Have 'node.exe')) {throw 'Necesitas Node.js 22.20+. Usa winget install --id OpenJS.NodeJS.LTS -e'}
    if (-not (Have 'claude.exe')) {
        $env:PATH += ';'+(Join-Path $HOME '.local\bin')
        if (-not (Have 'claude.exe')) {throw 'Instala primero Claude Code CLI: irm https://claude.ai/install.ps1 | iex'}
    }
    $vers=& node --version
    if ($vers -match '^v(\d+)\.(\d+)') {
       $maj=[int]$Matches[1]; $min=[int]$Matches[2]
       if ($maj -lt 22 -or ($maj -eq 22 -and $min -lt 20)) {throw "Node $vers es antiguo (minimo 22.20)."}
    }
    Clean-TemporaryClone
    $settings=Join-Path $claudeHome 'settings.json'
    if (Test-Path -LiteralPath $settings) {
        $backup=Join-Path $logs "settings.$stamp.backup.json"
        Copy-Item -LiteralPath $settings -Destination $backup
        Say "[BACKUP] $backup"
        try {$null=Get-Content $settings -Raw -Encoding UTF8 | ConvertFrom-Json}
        catch {throw 'settings.json existente no es JSON valido. Restaura/corrige manualmente antes de instalar.'}
    }
    # Las reglas se crean solo si faltan. Nunca sobreescribimos las del usuario.
    $rules=Join-Path $claudeHome 'CLAUDE.md'
    if(-not (Test-Path -LiteralPath $rules)) {
        Copy-Item -LiteralPath (Join-Path $root 'CLAUDE.md') -Destination $rules
        Record 'Reglas globales' 'OK' 'CLAUDE.md creado'
    } else {Record 'Reglas globales' 'SKIP' 'CLAUDE.md existente respetado'}

    if (-not $SkipVSCode) {
        if(Have 'code.cmd') { [void](Exec 'Extension VS Code' 'code.cmd' @('--install-extension','anthropic.claude-code')) }
        else {Record 'Extension VS Code' 'PENDING' 'code.cmd no disponible: instalar la extension desde VS Code'}
    }
    # El marketplace oficial puede estar registrado pero desactualizado. Actualizarlo antes de instalar plugins.
    [void](Exec 'Registrar marketplace oficial' 'claude' @('plugin','marketplace','add','anthropics/claude-plugins-official'))
    [void](Exec 'Actualizar catalogo oficial' 'claude' @('plugin','marketplace','update','claude-plugins-official'))
    foreach($m in $manifest.marketplaces) {
        if($m.id -eq 'claude-plugins-official') {continue}
        if($Profile -eq 'Core' -and $m.id -in @('anti-ai-slop','caveman','headroom-marketplace')) {continue}
        if($SkipClaudeMem -and $m.id -eq 'thedotmack') {continue}
        [void](TryMarketplace $m)
    }
    $newPlugins=@()
    foreach($p in $manifest.plugins) {
        if($Profile -eq 'Core' -and $p.stage -eq 'opcional') {continue}
        if($SkipClaudeMem -and $p.id -eq 'claude-mem@thedotmack') {continue}
        if(InstalledPlugin $p.id) {Record "Plugin $($p.id)" 'SKIP' 'Instalado en este equipo'; continue}
        [void](Exec "Plugin $($p.id)" 'claude' @('plugin','install',$p.id,'--scope','user'))
        # Codigo 0 no basta: comprobar que Claude lo registra de verdad.
        if(InstalledPlugin $p.id) {$newPlugins+=$p.id}
        else {Record "Verificar $($p.id)" 'FAILED' 'No aparece en installed_plugins.json'}
    }
    # Opcionales: deshabilitar solo al instalarlos ahora; si luego los activas tu, se respeta.
    foreach($p in $defaults.optionalPluginsInstalledButDisabled) {
        if($newPlugins -contains $p) {[void](Exec "Deshabilitar $p por defecto" 'claude' @('plugin','disable',$p))}
    }
    # PonyTail: aplicar defaults locales solo si nadie ha configurado aun esas opciones.
    if(InstalledPlugin 'ponytail@ponytail') {
        try {$cfg=(& claude plugin configure ponytail@ponytail --json 2>$null | Out-String) | ConvertFrom-Json} catch {$cfg=$null}
        if($cfg -and @($cfg.configured).Count -eq 0) {
            $tmp=Join-Path $logs 'ponytail-config.json'
            # webhookToken nunca se guarda aqui: va al llavero del sistema y solo si tu lo configuras.
            [ordered]@{ledger="$($defaults.ponytail.ledger)".ToLower(); webhookUrl=[string]$defaults.ponytail.webhookUrl; sendNames="$($defaults.ponytail.sendNames)".ToLower()} |
                ConvertTo-Json -Compress | ForEach-Object {[IO.File]::WriteAllText($tmp,$_)}
            # PowerShell 5.1 altera el stdin de procesos nativos; redirigir desde archivo con Start-Process.
            $proc=Start-Process -FilePath (Get-Command claude).Source -ArgumentList 'plugin','configure','ponytail@ponytail','--values-stdin' -RedirectStandardInput $tmp -NoNewWindow -Wait -PassThru
            Remove-Item -LiteralPath $tmp -ErrorAction SilentlyContinue
            if($proc.ExitCode -eq 0) {Record 'Configurar PonyTail' 'OK' 'Registro local, sin webhook, sin enviar nombres'}
            else {Record 'Configurar PonyTail' 'PENDING' 'En Claude: /plugin configure ponytail@ponytail (sin webhook)'}
        } else {Record 'Configurar PonyTail' 'SKIP' 'Opciones ya configuradas: se respetan'}
    }
    if(-not $SkipClaudeMem -and (InstalledPlugin 'claude-mem@thedotmack')) {
        $launcher=Join-Path $env:LOCALAPPDATA 'claude-mem\bin\claude-mem.exe'
        if(-not (Test-Path -LiteralPath $launcher)) {
            # Sin cuenta cmem.ai: CLAUDE_MEM_ONLINE_OPTIN=false y proveedor explicito (documentado por claude-mem).
            # Si ya habia proveedor en ~/.claude-mem/settings.json, no se pasa --provider y se conserva.
            $env:CLAUDE_MEM_ONLINE_OPTIN='false'
            $cmArgs=@('-y','claude-mem@latest','install')
            if(-not (Test-Path -LiteralPath (Join-Path $HOME '.claude-mem\settings.json'))) {$cmArgs+=@('--provider',$defaults.memoryProvider)}
            [void](Exec 'Claude-Mem runtime y lanzador' 'npx.cmd' $cmArgs)
        }
        if(Test-Path -LiteralPath $launcher) {
            $out=(& $launcher --version 2>$null | Out-String).Trim()
            if($out -match '^\d+$') {Record 'Lanzador Claude-Mem' 'OK' "Protocolo $out"} else {Record 'Lanzador Claude-Mem' 'FAILED' "Respuesta inesperada: $out"}
            $userPath=[Environment]::GetEnvironmentVariable('Path','User') -split ';'
            if($userPath -notcontains (Split-Path -Parent $launcher)) {Record 'PATH Claude-Mem' 'PENDING' 'Ejecuta: npx claude-mem install --provider claude'}
        } else {Record 'Lanzador Claude-Mem' 'PENDING' 'Ver docs/CLAUDE-MEM.md'}
    }
    if(-not $SkipSkills) {
        if(-not (Have 'npx.cmd')) {Record 'Skills' 'FAILED' 'Falta npx.cmd'}
        else {
            foreach($s in $manifest.skills) {
                if(InstalledSkill $s.skill) {Record "Skill $($s.skill)" 'SKIP' 'Ya existe'; continue}
                [void](Exec "Skill $($s.skill)" 'npx.cmd' @('-y','skills@latest','add',$s.source,'--skill',$s.skill,'-g','-a','claude-code','-y'))
                if(-not (InstalledSkill $s.skill)) {Record "Verificar skill $($s.skill)" 'FAILED' 'No existe ~/.claude/skills/<skill>/SKILL.md'}
            }
        }
    }
    if(-not $SkipNpm) {
        if(Have 'npm.cmd') {
            foreach($n in $manifest.npmGlobal) {
                if(Have ($n.command+'.cmd')) {Record "CLI $($n.command)" 'SKIP' 'Ya esta en PATH'}
                else {
                    [void](Exec "CLI $($n.command)" 'npm.cmd' @('install','-g',$n.pkg))
                    if(-not (Have ($n.command+'.cmd'))) {Record "Verificar $($n.command)" 'FAILED' 'No aparece en PATH tras npm install -g'}
                }
            }
            if((Have 'playwright-cli.cmd') -and -not (InstalledSkill 'playwright-cli')) {
                [void](Exec 'Skill Playwright CLI' 'playwright-cli.cmd' @('install','--skills','-g'))
            }
            if((Have 'agent-browser.cmd') -and -not (InstalledSkill 'agent-browser')) {
                [void](Exec 'Navegador Agent Browser' 'agent-browser.cmd' @('install'))
                if(-not $SkipSkills) {[void](Exec 'Skill Agent Browser' 'npx.cmd' @('-y','skills@latest','add','vercel-labs/agent-browser','--skill','agent-browser','-g','-a','claude-code','-y'))}
            }
            if($Profile -eq 'Complete') {
                if(Have 'omniroute.cmd') {Record 'OmniRoute CLI' 'SKIP' 'Ya esta instalada'}
                else { [void](Exec 'OmniRoute CLI (no configurar proxy)' 'npm.cmd' @('install','-g','omniroute')) }
            }
        }
    }
    # Task Observer requiere SKILL.md + carpeta references.
    if(-not (InstalledSkill 'task-observer')) {
        $src=Join-Path $logs 'task-observer-src'
        if(-not (Test-Path -LiteralPath (Join-Path $src 'SKILL.md'))) {
            [void](Exec 'Descargar Task Observer' 'git.exe' @('clone','--depth','1','https://github.com/SquidyInk/task-observer.git',$src))
        }
        if((Test-Path -LiteralPath (Join-Path $src 'SKILL.md')) -and (Test-Path -LiteralPath (Join-Path $src 'references'))) {
            $target=Join-Path $claudeHome 'skills\task-observer'
            New-Item -ItemType Directory -Force -Path $target | Out-Null
            Copy-Item -LiteralPath (Join-Path $src 'SKILL.md') -Destination $target -Force
            Copy-Item -LiteralPath (Join-Path $src 'references') -Destination $target -Recurse -Force
            Record 'Task Observer' 'OK' 'SKILL.md y referencias copiadas'
        } else {Record 'Task Observer' 'FAILED' 'No se han descargado SKILL.md y references'}
    } else {Record 'Task Observer' 'SKIP' 'Ya instalado'}
    if($Profile -eq 'Complete' -and -not $SkipReferences) {
        $target=Join-Path $claudeHome 'references\awesome-design-md'
        if(-not(Test-Path -LiteralPath (Join-Path $target '.git'))) {
            New-Item -ItemType Directory -Force -Path (Split-Path -Parent $target) | Out-Null
            [void](Exec 'Biblioteca Awesome DESIGN.md' 'git.exe' @('clone','--depth','1','https://github.com/VoltAgent/awesome-design-md.git',$target))
        } else {Record 'Awesome DESIGN.md' 'SKIP' 'Referencias ya disponibles'}
    }
} finally {
    $report=Join-Path $logs 'report.json'
    @($results) | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $report -Encoding UTF8
    $ok=@($results | Where-Object {$_.status -eq 'OK'}).Count
    $failed=@($results | Where-Object {$_.status -eq 'FAILED'}).Count
    $pending=@($results | Where-Object {$_.status -eq 'PENDING'}).Count
    $skip=@($results | Where-Object {$_.status -eq 'SKIP'}).Count
    Say "=== RESULTADO: $ok correctos, $skip ya disponibles, $failed errores, $pending pendientes ==="
    Say "Informe: $report | Log: $log"
    Say 'Cierra VS Code por completo y vuelve a abrirlo para que Claude Code cargue plugins y el PATH nuevo.'
    Say 'Diagnostico: scripts\check.ps1 (no uses npx claude-mem doctor para el lanzador: da un falso error en Windows).'
    Say 'La autenticacion de modelos, proxies y Claude Web no se comparte por Git.'
}
