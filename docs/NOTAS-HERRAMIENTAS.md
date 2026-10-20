# Inventario y límites

| Pedido | Instalación dentro del kit | Precauciones |
|---|---|---|
| Claude frontend skills: Anthropic Frontend Design, Impeccable, UI/UX Pro Max, Taste, Emil Kowalski | Marketplace frontend-stack, seis plugins | No instales otros duplicados por separado. |
| Image to Code | Plugin imagegen-skills del autor Leonxlnx | El enlace original apuntaba a taste-skill; desde octubre 2026 se movió a Leonxlnx/imagegen-skills. Usa un agente capaz de generar imágenes. |
| Claude Code Setup | claude-code-setup@claude-plugins-official | Anthropic verificado. No es akuroglo ni Zamaniego. |
| Karpathy skills | andrej-karpathy-skills@karpathy-skills | Repositorio multica-ai/andrej-karpathy-skills. |
| Claude-Mem | claude-mem@thedotmack | Servicio/almacenamiento local: puede requerir dependencias, configuración y revisión de privacidad. Las memorias NO se sincronizan por Git. |
| Task Observer | SKILL.md + references copiados a ~/.claude/skills | No añade persistencia en la nube. |
| PonyTail | ponytail@ponytail | Hooks de cada sesión; comprobar interacciones con otros hooks. |
| Superpowers | superpowers@claude-plugins-official | Activa metodología de desarrollo; puede ser más estricta que las reglas propias. |
| Headroom | headroom@headroom-marketplace (opcional) | El plugin no sustituye al runtime de headroom-ai; Windows puede necesitar ajustes. Evita enrutar otro proxy simultáneo. |
| Caveman | caveman@caveman (opcional) | Respuestas comprimidas: no recomendado para explicaciones educativas. |
| Anti AI Slop | antislop@anti-ai-slop (opcional) | Se solapa con reglas del frontend stack, úsalo selectivamente. |
| Grill me | grill-me@grill-me | Preguntas sobre tu código para evaluar comprensión. |
| Web Design Guidelines | Skill vercel-labs/agent-skills | Auditoría de interfaz. |
| Graphify | Skill safishamsi/graphify | Skill distinto del CLI/runtime; revisar si requiere un indexador. |
| SEO Audit y AI SEO | Dos skills coreyhaines31/marketingskills | Disponibles en todos los proyectos aunque solo se invocan si corresponden. |
| Canvas Design | Skill anthropics/skills | Puede generar artefactos y requerir soporte de archivos. |
| Anthropic skills / Agent Skills | Skill creator + canvas; gestor skills de Vercel | No se instala la colección completa de Anthropic para evitar docenas de skills no solicitadas. |
| Find Skills | npx skills find | Comando del gestor, no plugin adicional. |
| Awesome DESIGN.md | Clon de referencias, opt-in -IncludeReferences | Se selecciona un DESIGN.md por proyecto; no instalarlo como reglas globales. |
| Playwright CLI | npm + skill global | Descarga navegador bajo demanda. |
| Agent Browser | npm + skill global | Descarga navegador separado; usa solo uno de los dos navegadores por tarea. |
| OmniRoute | npm global opt-in -IncludeOmniRoute | No configura proveedores ni modifica automáticamente Claude. Revisar costes y autenticacion. |
| GSAP, Lenis | npm por proyecto | No global. |
| React Bits | Componentes por proyecto | No es plugin global. |

El instalador registra errores y no promete éxito cuando una dependencia o plugin falla. Las instalaciones de plugins externos ejecutan software de terceros con los permisos de tu usuario; revísalos antes.
