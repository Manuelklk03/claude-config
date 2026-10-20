# Qué herramienta utilizar en cada situación

| Necesidad | Principal | Cuándo usarla |
|---|---|---|
| Planificar una función sin que la IA la programe entera | Superpowers / Karpathy | Antes de tocar muchos archivos |
| Recordar decisiones anteriores | Claude-Mem | Al retomar sesiones en el mismo PC; tras configurar su proveedor |
| Mejorar una landing/portfolio | Frontend Stack → Taste / Impeccable | Diseño visual y pulido |
| UI con formularios, tablas, dashboards | Frontend Stack → Frontend Design / UI UX Pro Max | Diseño de aplicaciones |
| Mejorar animaciones | Frontend Stack → Emil Kowalski | Motion y microinteracciones |
| Pasar una captura a código | Image to Code | Referencias visuales |
| Revisar responsive y accesibilidad | Web Design Guidelines | Antes de publicar |
| Auditar el posicionamiento | SEO Audit / AI SEO | SEO técnico y búsquedas IA |
| Automatizar un navegador | Playwright CLI / Agent Browser | Tests e interacción web; elige uno por tarea |
| Crear un skill propio | Anthropic Skill Creator | Nuevos flujos de trabajo |
| Aprender de correcciones repetidas | Task Observer | Seguimiento de patrones del agente |
| Diseñar un póster o composición visual | Canvas Design | Salidas visuales |
| Reducir respuestas | Caveman (apagado) | Solo si quieres respuestas ultracortas |
| Comprimir contexto / proxy | Headroom (apagado) | Tras configurar su runtime |
| Probar proveedores de modelos | OmniRoute (sin configurar) | Solo tras revisar credenciales y posibles costes |
| Ver referencias de marcas y sistemas | Awesome DESIGN.md | Inspiración y documentación por proyecto |
| Elegir componentes de React | React Bits | Integrar componente concreto |
| Animaciones programáticas | GSAP | `npm install gsap` dentro del proyecto |
| Scroll suave | Lenis | `npm install lenis` dentro del proyecto |

## Ejemplos de peticiones a Claude

- «Analiza el frontend de Digital-Fit y prepara un plan de rediseño; no implementes todavía.»
- «Usa el router frontend-stack para diseñar esta landing y audítala con Impeccable.»
- «Haz una auditoría SEO de estas rutas de Next.js y ordénalas por prioridad.»
- «Con Playwright comprueba login, navegación y vista móvil.»
- «Aplica los principios de Karpathy y evita refactorizaciones fuera de la tarea.»

## Inventario y estado (comprobado el 20/10/2026)

**Claude Frontend Skills** (`frontend-stack`) es el coordinador del diseño: decide qué skill lidera cada fase. No instales por separado duplicados de sus seis plugins.

| Herramienta | Origen | Estado | Configuración / precauciones |
|---|---|---|---|
| Frontend Stack, Frontend Design, Impeccable, UI/UX Pro Max, Taste, Emil Kowalski | Marketplace `JaimeJunr/claude-code-frontend-skills` | ✅ Activos | Ninguna |
| Imagegen Skills (Image to Code) | `Leonxlnx/imagegen-skills` | ✅ Activo | Necesita un agente capaz de generar imágenes |
| Claude-Mem | `thedotmack/claude-mem` | ✅ Activo | Ver [Claude-Mem](CLAUDE-MEM.md): reinicia VS Code tras instalar |
| PonyTail | `DietrichGebert/ponytail` | ✅ Activo | Registro local, sin webhook, `sendNames=false` |
| Superpowers, Claude Code Setup | Marketplace oficial de Anthropic | ✅ Activos | Superpowers puede ser más estricto que tus reglas |
| Karpathy Skills | `multica-ai/andrej-karpathy-skills` | ✅ Activo | Ninguna |
| Grill Me | `joshuawheelock/grill-me` | ✅ Activo | Ninguna |
| Anti AI Slop | `muris11/anti-ai-slop` | ⏸️ Desactivado | Se solapa con el frontend stack |
| Caveman | `Karnonson/caveman` | ⏸️ Desactivado | Respuestas comprimidas: choca con explicaciones didácticas |
| Headroom | `headroomlabs-ai/headroom` | ⏸️ Desactivado | El plugin no instala su runtime/proxy; no lo combines con otro proxy |
| Web Design Guidelines | Skill `vercel-labs/agent-skills` | ✅ | Ninguna |
| SEO Audit, AI SEO | Skills `coreyhaines31/marketingskills` | ✅ | Ninguna |
| Canvas Design, Skill Creator | Skills `anthropics/skills` | ✅ | Solo esas dos, no la colección completa |
| Find Skills | Skill `vercel-labs/skills` | ✅ | Busca skills; instala solo las que revises |
| Graphify | Skill `safishamsi/graphify` | ⚠️ Skill lista; CLI no instalada | La skill instala su CLI (`uv tool install graphifyy`) la primera vez que se usa |
| Task Observer | `SquidyInk/task-observer` (copiado) | ✅ | Solo local, sin nube |
| Playwright CLI | npm `@playwright/cli` + skill | ✅ | Descarga navegador bajo demanda |
| Agent Browser | npm `agent-browser` + skill | ✅ | Usa uno de los dos navegadores por tarea |
| OmniRoute | npm `omniroute` | ⚠️ Instalado, sin configurar | No conectes proveedores sin revisar autenticación y costes |
| Awesome DESIGN.md | Clon en `~/.claude/references/awesome-design-md` | ✅ Referencia | Copia un DESIGN.md a cada proyecto; no es una regla global |
| GSAP, Lenis, React Bits | Por proyecto | — | Ver [Librerías frontend](LIBRERIAS-FRONTEND.md) |

Solapamientos a tener en cuenta: Anti AI Slop ↔ Taste/Impeccable; Caveman ↔ PonyTail (ambos acortan respuestas); Playwright CLI ↔ Agent Browser; además, Claude Web puede sincronizar plugins con el mismo nombre (ver [Claude Web](CLAUDE-WEB.md)).

## Datos que NO se sincronizan

- Bases de datos locales de Claude-Mem.
- Cookies o tokens de Claude, GitHub u otros servicios.
- API keys de OmniRoute / Anthropic / OpenRouter / otros proveedores.
- Dependencias `node_modules` y configuraciones de proyectos privados.
