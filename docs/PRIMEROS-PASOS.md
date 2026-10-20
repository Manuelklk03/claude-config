# ✅ Primeros pasos después de instalar

La instalación global se realiza **una sola vez por PC**. Si todo terminó sin errores, no reinstales el kit.

## 1. Verificar Claude Code y las skills

Abre una terminal PowerShell nueva:

```powershell
claude --version
claude plugin list
npx skills ls -g
```

Si Claude Code detecta los plugins y skills, ya estarán disponibles para cualquier repositorio abierto en el mismo PC. Reinicia VS Code tras instalar extensiones o modificar `PATH`.

## 2. Revisar Claude-Mem

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\check.ps1
```

En la sección **Claude-Mem** todo debe estar en `[OK]`. Si aparece el aviso de VS Code, ciérralo por completo y vuelve a abrirlo. Si falta el lanzador:

```powershell
$env:CLAUDE_MEM_ONLINE_OPTIN = 'false'
npx claude-mem install --provider claude
```

Así no se pide cuenta en cmem.ai: la memoria usa tu plan de Claude (consume parte de su uso). La base local **no se sincroniza** entre ordenadores. Detalles en [Claude-Mem](CLAUDE-MEM.md).

No subas `~/.claude-mem/settings.json`, la base de datos ni ninguna credencial a GitHub.

## 3. Comprobar PonyTail

El instalador ya aplica estos valores si no estaban configurados. Para comprobarlos:

```powershell
claude plugin configure ponytail@ponytail
```

Valores recomendados para uso individual:

| Opción | Recomendación |
|---|---|
| `ledger` | `true`: registro local de tareas |
| `webhookUrl` | vacío: ningún envío externo |
| `webhookToken` | no configurar si no usas webhook |
| `sendNames` | `false`: menor exposición de datos |

`webhookUrl` y `webhookToken` aparecerán como *not set*: es lo esperado.

## 4. Probar navegador y CLI

```powershell
playwright-cli --help
agent-browser --help
```

Elige **uno** para cada tarea, por ejemplo probar el responsive o navegar por una aplicación. No hace falta ejecutar ambas herramientas simultáneamente.

## 5. Otros componentes

| Herramienta | Qué hacer ahora |
|---|---|
| Superpowers / Karpathy / Frontend Stack | Ya puedes utilizarlos; pide un plan o una auditoría de tu proyecto |
| Task Observer | Puedes usarlo cuando quieras registrar mejoras recurrentes de las skills |
| Headroom | Déjalo deshabilitado salvo que vayas a configurar su runtime y revisar sus hooks |
| Caveman | Déjalo deshabilitado si quieres explicaciones didácticas |
| Anti AI Slop | Déjalo deshabilitado por defecto; el paquete frontend ya aplica reglas de calidad |
| OmniRoute | Sin proveedores conectados no enruta nada; no lo actives sin revisar autenticación y posibles costes |
| GSAP, Lenis, React Bits | Instalar por **proyecto**; ver [Librerías frontend](LIBRERIAS-FRONTEND.md) |

## 6. Verificarlo en otro repositorio

Abre ValveDex, Digital-Fit u otro proyecto en VS Code. Reinicia la sesión de Claude Code y prueba una petición como:

> Analiza esta web y proponme mejoras UI con frontend-stack e Impeccable. Primero explícame el plan; todavía no cambies archivos.

Tus **plugins globales** seguirán disponibles, aunque cada proyecto pueda tener además su propio `CLAUDE.md`.

## 7. Si algo falla

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\check.ps1
```

También puedes abrir `.local/report.json` y `.local/install.log` o consultar [Solucionar problemas](SOLUCIONAR-PROBLEMAS.md).

## 8. Claude Web

Desde Claude Web puedes consultar **Personalizar → Plugins** e instalar los compatibles en tu cuenta. Los plugins instalados desde esa cuenta pueden estar disponibles en Claude Code, pero **las herramientas locales no se sincronizan automáticamente a la web**. Ver [Claude Web](CLAUDE-WEB.md).
