# Claude Config Universal — Windows, Claude Code y VS Code

Kit reutilizable para **un usuario** de Windows en cualquier proyecto. Las fuentes están en `config/manifest.json` y el inventario se documenta en `docs/NOTAS-HERRAMIENTAS.md`.

## Requisitos

- Windows 10/11, PowerShell, Git, Node.js **22.20+**, npm, Claude Code CLI con sesión iniciada.
- VS Code recomendado (extensión Anthropic.claude-code). El CLI y la extensión no son lo mismo; instala ambos.
- Autentícate una vez en Claude Code: `claude`, comando `/login`.
- No ejecute el script como Administrador salvo que una dependencia lo requiera explícitamente.

## PC 1 (exactamente desde la raíz de este kit)

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\check.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\check.ps1
```

El instalador hace copia de seguridad de `~/.claude/settings.json` y usa **comandos oficiales** `claude plugin marketplace add` / `claude plugin install --scope user` para no borrar tu configuración. Instala por defecto las tools verificadas de bajo riesgo relativo (algunas incluyen hooks); muestra errores y no los oculta. Lee `docs/NOTAS-HERRAMIENTAS.md` antes.

### Herramientas opcionales, avanzadas

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1 -IncludeOptional -IncludeOmniRoute -IncludeReferences
```

`IncludeOptional` habilita **Headroom, Caveman y Anti AI Slop**. `IncludeOmniRoute` solo instala su CLI, NO configura credenciales/proxy. `IncludeReferences` clona la galería Awesome DESIGN.md. No recomiendo ejecutar el modo avanzado hasta probar el modo normal.

Comprueba: `claude plugin list` y `npx skills ls -g`, reinicia Claude/VS Code. Si hay una línea `[REVISAR]`, inspecciona `.local/install.log`: NO significa que el plugin esté funcionando.

## GitHub privado y PC 2

1. Crea en GitHub un repositorio **privado, vacío** llamado `claude-config` (sin README inicial).
2. En la carpeta descomprimida:

```powershell
git init
git branch -M main
git add .
git commit -m "chore: add portable Claude Code configuration"
git remote add origin https://github.com/Manuelklk03/claude-config.git
git push -u origin main
```

3. En el otro PC:

```powershell
git clone https://github.com/Manuelklk03/claude-config.git
cd claude-config
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

4. Cuando actualices `manifest.json` y los scripts, haz commit+push en el PC de origen. En el otro:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\update.ps1
```

No clones el kit dentro de **cada** proyecto. Solo una vez por PC. Todo se instala en el ámbito del usuario, disponible en cada repo/VS Code.

## Acerca del JSON

- `config/manifest.json`: fuente de verdad del instalador que contiene marketplaces, plugins, skills, npm y referencias.
- `config/settings.global.template.json`: ejemplo de formato válido para `~/.claude/settings.json`. **NO se debe copiar encima** sin combinarlo con los valores existentes: podrías perder MCP, hooks y permisos. El script utiliza los CLI oficiales y no copia el template.
- Tu verdadera config global queda en `%USERPROFILE%\.claude\settings.json` y las instalaciones reales se registran localmente en Claude.
- `CLAUDE.md` contiene las reglas personales. Si no existe un `~/.claude/CLAUDE.md`, el instalador copia el del kit; si ya existe, **lo conserva** y deberás fusionar manualmente las reglas que te interesen.

## Librerías web (GSAP, Lenis y React Bits)

Al usar un proyecto web concreto, ejecuta desde su raíz:

```powershell
npm install gsap lenis
```

Para React Bits: https://reactbits.dev/ — selecciona y copia solo los componentes que necesites con sus dependencias.

## Claude Web

Consulta `docs/CLAUDE-WEB.md`. Importante: en versiones Claude Code **2.1.273+**, los plugins/skills añadidos a tu cuenta Claude desde Web se pueden **sincronizar unilateralmente a Claude Code** al iniciar sesión con la misma cuenta. No implica que plugins locales se suban a Web.

## Restauración

Si un plugin no funciona, desactívalo con `claude plugin` o elimínalo desde `/plugin`. Para recuperar una configuración anterior, **guarda primero copia de la actual** y revisa el archivo `settings.backup.*.json` en `.local/`.

## Fuentes principales

- https://github.com/JaimeJunr/claude-code-frontend-skills
- https://github.com/Leonxlnx/imagegen-skills
- https://github.com/multica-ai/andrej-karpathy-skills
- https://claude.com/es/marketplace/plugins/claude-code-setup
- https://github.com/anthropics/claude-plugins-official
- https://github.com/vercel-labs/skills
- https://support.claude.com/es/articles/13837440-usar-plugins-en-claude
