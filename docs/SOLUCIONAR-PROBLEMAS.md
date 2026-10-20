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
4. Si el servicio de Claude-Mem no se activa, utiliza `npx claude-mem doctor` y, si lo indica, `npx claude-mem install`.

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

La configuración segura prevista es:
- `ledger`: `true`
- `webhookUrl`: cadena vacía
- `sendNames`: `false`
- `webhookToken`: dejar vacío (no guardarlo en Git)

Para revisar las opciones abre Claude Code y ejecuta:

```text
/plugin configure ponytail@ponytail
```

El instalador **intenta** pasar esos valores con `--config`. Si tu versión de Claude CLI no admite esa opción, instala el plugin y marca la revisión en el log. Nunca inventa un token ni habilita un webhook.

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
