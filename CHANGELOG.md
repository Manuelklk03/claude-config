# Changelog

## 2.2 — 2026-10-20

### Corregido
- `install.ps1`: ya no reasigna la variable automática `$args`; relee el PATH del registro al empezar.
- `install.ps1`: los plugins opcionales se desactivan solo al instalarlos por primera vez (antes se volvían a desactivar en cada ejecución).
- PonyTail: las opciones locales se aplican con `claude plugin configure --values-stdin` (el `--config` anterior no surtía efecto) y solo si nunca se configuraron.
- `update.ps1`: ya no sobrescribe la variable automática `$PROFILE`.

### Añadido
- Verificación real tras instalar plugins, skills y CLIs.
- Claude-Mem: instalación sin cuenta cmem.ai (`CLAUDE_MEM_ONLINE_OPTIN=false`, proveedor `claude`) y comprobación del lanzador.
- `check.ps1`: skills del manifiesto, lanzador y worker de Claude-Mem, aviso de VS Code abierto antes del PATH nuevo, opciones de PonyTail.
- Skill **Find Skills** (`vercel-labs/skills`) en el manifiesto.
- Guías: Claude-Mem, Sincronización, Seguridad, Arquitectura; sección VS Code en Claude Web.

### Cambiado
- `docs/NOTAS-HERRAMIENTAS.md` se integra en `docs/GUIA-HERRAMIENTAS.md` (eliminaba flags inexistentes).
- `.windsurf/rules/claude-mem-context.md` (autogenerado) deja de seguirse en Git.

## 2.1
- README y guías de primeros pasos y librerías frontend; scripts de publicación fuera de Git.
