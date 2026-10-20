# Claude Config Portable 🚀

**Instalación y mantenimiento de Claude Code, skills, plugins y herramientas de desarrollo en Windows, con una sola configuración reutilizable en cualquier PC.**

> Preparado para reutilizarse en distintos ordenadores, en VS Code y en todos tus repositorios, sin tener que instalar los mismos plugins por proyecto.

## ¿Qué problema resuelve?

Cuando cambias de equipo o reinstalas VS Code, tus repositorios están en GitHub, pero la configuración global de Claude Code **no se traslada por Git automáticamente**. Este proyecto guarda las *instrucciones y recetas de instalación*, no los datos privados. Ejecutando el instalador en cada PC recuperas las mismas herramientas compatibles.

**En resumen:** una instalación por **ordenador**, no una instalación por **repositorio**.

| Componente | Se instala dónde | Disponible en otros repositorios | Se sincroniza por Git |
|---|---|---|---|
| Plugins Claude Code | `~/.claude/plugins/` | Sí, con scope `user` | Configuración/recetas, **no** los binarios |
| Skills globales | `~/.claude/skills/` | Sí | El inventario y la receta |
| Reglas `CLAUDE.md` | `~/.claude/CLAUDE.md` | Sí | Sí, mediante esta plantilla, solo si no existían |
| Extensión Claude VS Code | Instalación de VS Code | Sí, en esa instalación | Receta |
| API keys / sesiones | Perfil local/servicios | Según proveedor | **Nunca** |
| Datos locales de Claude-Mem | `~/.claude-mem/` | En ese equipo | **Nunca** |
| Claude Web y Claude Code cloud | Cuenta/sesión remota | Depende del tipo de plugin | No de forma universal |

## ✅ Inicio rápido: primer ordenador

**Requisitos:** Windows 10/11, Git, Node.js 22.20+ (tu Node 24 es válido), VS Code y Claude Code CLI. GitHub debe permitirte hacer `git push` al repositorio privado.

1. Descarga el ZIP y descomprímelo; **no ejecutes directamente los .cmd desde dentro del ZIP**.
2. Abre la carpeta `claude-config-portable`.
3. Haz doble clic en **`INSTALAR.cmd`** (o en PowerShell ejecuta `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1`).
4. Espera al resumen `RESULTADO`. Puedes repetir el instalador sin que borre tu configuración.
5. Reinicia VS Code / Claude Code y comprueba `claude plugin list` y `npx skills ls -g`.
6. Si hay errores, cierra todas las sesiones de Claude y VS Code y ejecuta **`REPARAR.cmd`**.

Si `claude` no se reconoce, instala Claude Code mediante el [instalador oficial](https://code.claude.com/docs/en/setup). En PowerShell, su comando nativo suele ser:

```powershell
irm https://claude.ai/install.ps1 | iex
```

Cierra y abre la terminal tras instalarlo.

### Modo conservador (menos plugins simultáneos)

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1 -Profile Core
```

El modo predeterminado es **Complete**: instala todas las herramientas identificadas del inventario, pero deja **Headroom, Caveman y Anti AI Slop deshabilitados** hasta que los necesites; así no añaden hooks o instrucciones contradictorias en cada sesión.

## ☁️ Guardar el kit en tu repositorio privado

1. Crea en [GitHub](https://github.com/new) un repositorio llamado `claude-config` con visibilidad **Private**. Si ya existe, utiliza ese.
2. Con Git configurado para tu cuenta, dentro de esta carpeta haz doble clic en **`PUBLICAR-EN-GITHUB.cmd`**.
3. El script **clona** `https://github.com/Manuelklk03/claude-config.git` en una carpeta temporal, **sustituye solo los archivos propios de este kit**, crea un commit y hace `git push` sin `--force`.
4. Los demás archivos personales de tu repositorio remoto se respetan. Si quieres eliminar archivos antiguos ajenos al kit, revísalos manualmente.

También puedes ejecutarlo a mano (para otro nombre de repositorio):

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\publish.ps1 -RepoUrl 'https://github.com/TU_USUARIO/claude-config.git'
```

**Importante:** no crea la cuenta ni el repositorio de GitHub por ti; el repo debe existir y tu Git debe tener acceso. Si Git requiere credenciales, realiza antes `gh auth login` (si utilizas GitHub CLI) o autentícate mediante Git Credential Manager.

## 💻 Instalarlo en el segundo ordenador

```powershell
git clone https://github.com/Manuelklk03/claude-config.git
cd claude-config
.\INSTALAR.cmd
```

El instalador instala globalmente los plugins y skills en ese PC. Abre después cualquier repositorio en VS Code y usa la extensión oficial Claude Code. **No hay que copiar este kit dentro de cada proyecto.**

**Actualizar en cualquier PC:** desde la carpeta clonada ejecuta `ACTUALIZAR.cmd`. El script hace `git pull --ff-only`, reinstala los elementos que faltan y actualiza los plugins instalados cuando Claude Code permite hacerlo.

## 🧰 Herramientas incluidas

### Diseño/frontend (sin instalar varias copias de las mismas skills)

Usamos el [Claude Code Frontend Skills](https://github.com/JaimeJunr/claude-code-frontend-skills) como conjunto principal:

- `frontend-stack`: router que selecciona la skill adecuada.
- `frontend-design`: dirección visual de Anthropic.
- `impeccable`: auditoría y mejora UI/UX.
- `ui-ux-pro-max`: estilos, tipografía, sistemas de diseño.
- `taste`: dirección artística y webs menos genéricas.
- `emil-design-eng`: movimiento e interacciones.
- `imagegen-skills`: contiene **Image to Code** de Leonxlnx.
- `web-design-guidelines`: revisión de UI, responsive y accesibilidad.

### Desarrollo y metodología

| Herramienta | Función | Instalación prevista |
|---|---|---|
| Superpowers | Planificación, pruebas, depuración | Plugin global |
| Claude Code Setup oficial | Configuración de Claude Code | Plugin global |
| PonyTail | Soluciones simples y revisión | Plugin global, valores locales sin webhook por defecto |
| Karpathy Skills | Simplicidad y cambios quirúrgicos | Plugin global |
| Grill Me | Preguntas sobre decisiones técnicas | Plugin global |
| Claude-Mem | Memoria persistente entre sesiones | Plugin global; **su runtime/proveedor necesita comprobación** |
| Task Observer | Aprender de observaciones sobre skills | Skill global |
| Graphify | Documentación/visualización según el paquete | Skill global; CLI separada |
| Find Skills | Descubrir skills disponibles | `npx skills find` |
| Playwright CLI | Pruebas/navegación | npm global + skill |
| Agent Browser | Automatización del navegador | npm global + skill |

### SEO, diseño y utilidades

| Recurso | Instalación |
|---|---|
| SEO Audit y AI SEO | Skills globales |
| Anthropic Canvas Design + Skill Creator | Skills globales |
| Awesome DESIGN.md | Colección de referencias en `~/.claude/references/` |
| Anti AI Slop | Plugin instalado pero apagado por defecto |
| Caveman | Plugin instalado pero apagado por defecto |
| Headroom | Plugin instalado pero apagado por defecto; requiere runtime/proxy para funciones avanzadas |
| OmniRoute | CLI global, **sin conectar proveedores automáticamente** |
| GSAP, Lenis, React Bits | **Por proyecto**, no en todos los repositorios |

Si necesitas GSAP o Lenis, dentro de la carpeta del proyecto que contiene `package.json`:

```powershell
npm install gsap lenis
```

React Bits permite incorporar solo los componentes que elijas: https://reactbits.dev/.

## ⚙️ Valores predeterminados y seguridad

| Decisión | Valor | Motivo |
|---|---|---|
| Plugin scope | `user` | Disponible en todos los proyectos de ese PC |
| Perfil | `Complete` | Descarga toda la selección verificada |
| Headroom, Caveman, Anti AI Slop | Deshabilitados tras instalar | Evitar conflictos y procesos innecesarios |
| PonyTail | ledger sí; sin webhook; no enviar nombres | Mantener datos localmente por defecto |
| Timeout de clones Claude | 900.000 ms | Dar tiempo a los repositorios grandes |
| `settings.json` existente | **No se reemplaza** | Preservar permisos, MCP y ajustes propios |
| `CLAUDE.md` existente | **No se reemplaza** | No perder tus reglas |
| Credenciales, tokens y cookies | Nunca en Git | Evitar filtraciones |

El instalador utiliza los métodos documentados de Claude Code: `claude plugin marketplace add`, `claude plugin install --scope user`, `claude plugin disable` y `npx skills add ... -g`. Puede fallar una descarga por red o por una dependencia propia del plugin: **ningún JSON garantiza por sí solo que todos los plugins funcionen automáticamente**.

Para **Claude-Mem**, la memoria persistente no se sincroniza automáticamente entre equipos. Si `npx claude-mem doctor` indica que falta configuración, ejecuta `npx claude-mem install` y elige un proveedor; algunas opciones pueden requerir cuenta o coste. No se toma esa decisión por ti.

Para **OmniRoute**, no ejecutamos `omniroute setup-claude` ni redirigimos el modelo sin que elijas proveedor. Para **Headroom**, no instalamos ni activamos automáticamente un proxy que altere las solicitudes.

## 📁 Estructura del repositorio

```text
claude-config/
├── INSTALAR.cmd                  # Instalación principal (doble clic)
├── REPARAR.cmd                   # Reintentar lo fallido y limpiar clones temporales
├── ACTUALIZAR.cmd                # Git pull + reinstalar lo faltante + actualizar plugins
├── PUBLICAR-EN-GITHUB.cmd        # Actualizar tu repositorio privado
├── CLAUDE.md                     # Reglas globales de referencia
├── config/
│   ├── manifest.json             # Lista real de plugins, skills y programas
│   └── defaults.json             # Valores elegidos por defecto
├── scripts/
│   ├── install.ps1
│   ├── repair.ps1
│   ├── check.ps1
│   ├── update.ps1
│   ├── publish.ps1
│   └── frontend-deps.ps1
├── docs/
│   ├── GUIA-HERRAMIENTAS.md
│   ├── CLAUDE-WEB.md
│   └── SOLUCIONAR-PROBLEMAS.md
└── .gitignore
```

## 🔎 Comprobar errores

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\check.ps1
claude plugin list
npx skills ls -g
```

En `.local/install.log` y `.local/report.json` tienes los resultados completos; `.local/` está ignorada por Git. Si algo falla, consulta [Solucionar problemas](docs/SOLUCIONAR-PROBLEMAS.md).

## 📚 Documentación adicional

- [Qué herramienta usar para cada tarea](docs/GUIA-HERRAMIENTAS.md)
- [Claude Web y sincronización](docs/CLAUDE-WEB.md)
- [Errores y reparación](docs/SOLUCIONAR-PROBLEMAS.md)
- [Documentación oficial de plugins Claude Code](https://code.claude.com/docs/en/discover-plugins)
- [Documentación oficial de configuración](https://code.claude.com/docs/en/settings)

---

**Este repositorio no es un marketplace de plugins propio ni un paquete que sustituya Claude Code.** Es un instalador y un inventario reproducible de herramientas de terceros. Revisa los orígenes antes de ejecutar hooks o herramientas con acceso al sistema de archivos.
