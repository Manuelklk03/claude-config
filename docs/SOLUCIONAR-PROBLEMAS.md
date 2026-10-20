# Solucionar problemas

## Comandos para diagnosticar

Desde la carpeta del kit:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\check.ps1
claude plugin list
npx skills ls -g
```

Logs del kit: `.local/install.log` y `.local/report.json` (se quedan fuera de Git).

## Errores del 20/10/2026 ya conocidos

### Claude-Mem y Headroom: clone timed out / EBUSY / shallow.lock

Un repositorio de gran tamaño superó el límite de 120 segundos. El instalador nuevo eleva el límite a 900.000 ms. Si queda una carpeta `.clone` bloqueada:

1. Cierra VS Code y todas las terminales que estén clonando repositorios.
2. Comprueba que no hay descargas de Git en marcha.
3. Ejecuta `REPARAR.cmd`: limpia **solo** las carpetas temporales incompletas conocidas y reintenta.
4. Si el servicio de Claude-Mem no se activa, sigue [Claude-Mem](CLAUDE-MEM.md#diagnóstico).

El instalador **no borra** la carpeta de datos de memoria `~/.claude-mem`.

### Claude Code Setup y Superpowers: Plugin not found

Normalmente el catálogo oficial estaba ausente o desactualizado. El instalador ahora registra y actualiza explícitamente:

```powershell
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin marketplace update claude-plugins-official
claude plugin install claude-code-setup@claude-plugins-official --scope user
claude plugin install superpowers@claude-plugins-official --scope user
```

Si siguen sin aparecer, revisa `claude plugin marketplace list` y tu versión de Claude Code. No sustituyas el marketplace oficial por uno de autor desconocido.

### PonyTail: cuatro opciones por configurar

El instalador aplica `ledger=true`, `webhookUrl` vacío y `sendNames=false` con `claude plugin configure --values-stdin`, **solo si** nunca se configuraron. `webhookToken` se deja sin definir. Para comprobarlo:

```powershell
claude plugin configure ponytail@ponytail
```

`webhookUrl` y `webhookToken` aparecen como *not set*: es lo correcto (vacío = nada sale del PC).

### Claude-Mem: los hooks no hacen nada / `Executable not found in $PATH: "claude-mem"`

VS Code (y por tanto Claude Code) se abrió antes de que el instalador añadiera el lanzador al PATH de usuario. **Cierra todas las ventanas de VS Code** y vuelve a abrirlo. `check.ps1` lo detecta con el aviso *"VS Code se abrio antes de instalar el lanzador"*.

### Claude-Mem: `npx claude-mem doctor` → "Hook launcher ✗"

Falso positivo de `npx` en Windows. Explicación y comprobación real en [Claude-Mem](CLAUDE-MEM.md#npx-claude-mem-doctor-dice-hook-launcher-).

### Claude-Mem: el instalador pide iniciar sesión en cmem.ai

No es obligatorio. Cancela y ejecuta `$env:CLAUDE_MEM_ONLINE_OPTIN='false'; npx claude-mem install --provider claude`.

### Claude-Mem: "Codex CLI: integration setup failed"

Codex CLI no está instalado; no afecta a Claude Code ni a Windsurf.

### `claude plugin list` muestra "claude-code-setup@synced … not loaded"

Claude Web sincroniza un plugin con el mismo nombre que el local; gana el local. Es informativo.

### PowerShell: `NativeCommandError`, `npm notice`, caracteres raros

PowerShell 5.1 puede tratar mensajes normales de stderr como errores. El instalador ya consulta el código de salida, no el color de la terminal. Algunos caracteres de npm y Claude pueden quedar deformados por la codificación de la consola: no significa necesariamente un fallo.

### npm: bloqueó scripts de postinstalación

No habilites todos los scripts de npm sin revisar sus dependencias. Si `agent-browser` o Playwright muestra una instalación parcial, revisa las instrucciones oficiales y ejecuta la comprobación individual.

### `settings.json` local contiene opciones que no están en el kit

Es correcto: el instalador **no lo sobrescribe**. Los plugins usan sus propios comandos de instalación y escriben su configuración a nivel usuario. Tus permisos, MCP y demás ajustes se mantienen.

## Cómo saber si una skill se está usando

Instalada no significa invocada. Pregunta explícitamente a Claude qué skill aplica a tu tarea, o invócala por su nombre. Para examinar el plugin:

```powershell
claude plugin details frontend-stack
```

## No reinstalar en cada repositorio

`~/.claude` es global en el PC. Solo ejecuta `INSTALAR.cmd` una vez por equipo. Los proyectos específicos conservan sus propios `CLAUDE.md` y `.claude/settings.json` si ya existían.
