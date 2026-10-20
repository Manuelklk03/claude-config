param([switch]$GSAP,[switch]$Lenis)
if (-not (Test-Path 'package.json')) {throw 'Ejecuta esto en la raiz de un proyecto Node que tenga package.json.'}
$pkgs=@()
if($GSAP){$pkgs+='gsap'}
if($Lenis){$pkgs+='lenis'}
if($pkgs.Count -eq 0){Write-Host 'Ejemplo: .\scripts\frontend-deps.ps1 -GSAP -Lenis'; exit}
npm.cmd install @pkgs
Write-Host 'React Bits: instala/copia solo los componentes que elijas desde https://reactbits.dev/'
