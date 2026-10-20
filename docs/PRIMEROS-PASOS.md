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
npx claude-mem doctor
```

Si el diagnóstico indica que falta instalar el runtime o conectar un proveedor:

```powershell
npx claude-mem install
```

El instalador permite elegir proveedor. Utilizar el plan de Claude consume parte de su uso; los proveedores externos pueden necesitar una cuenta, créditos o claves API. La base local **no se sincroniza automáticamente** entre ordenadores.

No subas `~/.claude-mem/settings.json`, la base de datos ni ninguna credencial a GitHub.

## 3. Comprobar PonyTail

Abre una sesión con `claude` y ejecuta:

```text
/plugin configure ponytail@ponytail
```

Valores recomendados para uso individual:

| Opción | Recomendación |
|---|---|
| `ledger` | `true`: registro local de tareas |
| `webhookUrl` | vacío: ningún envío externo |
| `webhookToken` | no configurar si no usas webhook |
| `sendNames` | `false`: menor exposición de datos |

Si no pide configurar nada, no es necesario cambiarlo.

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
