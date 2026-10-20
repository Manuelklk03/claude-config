# Instalacion voluntaria, solo para un proyecto frontend (NO global).
param([switch]$GSAP,[switch]$Lenis,[switch]$ReactGSAP)
if(-not (Test-Path -LiteralPath (Join-Path (Get-Location).Path 'package.json'))) {
  throw 'Abre la raiz del proyecto (donde esta package.json) antes de ejecutar este script.'
}
$packages=@()
if($GSAP){$packages+='gsap'}
if($Lenis){$packages+='lenis'}
if($ReactGSAP){$packages+='@gsap/react'; if(-not $GSAP){$packages+='gsap'}}
if($packages.Count -eq 0){Write-Host 'Ejemplo: .\scripts\frontend-deps.ps1 -GSAP -Lenis -ReactGSAP'; exit 0}
& npm.cmd install @packages
if($LASTEXITCODE -ne 0){throw 'npm install no ha finalizado correctamente.'}
Write-Host 'React Bits: anade solo los componentes que elijas en https://reactbits.dev/'
