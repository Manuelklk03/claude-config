$ErrorActionPreference='Continue'
Write-Host '=== ENTORNO CLAUDE ==='
foreach($cmd in @('git','node','npm','npx','claude','code','playwright-cli','agent-browser','omniroute')) {
  $found=Get-Command $cmd -ErrorAction SilentlyContinue
  if($found){Write-Host "[OK] $cmd ($($found.Source))"} else {Write-Host "[PENDIENTE] $cmd"}
}
$settings=Join-Path $HOME '.claude\settings.json'
Write-Host "Configuracion global: $settings"
if(Test-Path $settings){try{$null=Get-Content $settings -Raw | ConvertFrom-Json;Write-Host '[OK] JSON valido'}catch{Write-Host '[ERROR] JSON invalido'}}
if(Get-Command claude -ErrorAction SilentlyContinue){ claude --version; claude plugin list }
if(Get-Command npx -ErrorAction SilentlyContinue){npx -y skills@latest ls -g}
