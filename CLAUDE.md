# Reglas globales propuestas para Claude Code

- Antes de cambios complejos, presenta un plan conciso, los archivos afectados y criterios de comprobacion.
- No implementes funcionalidades nuevas ni hagas refactorizaciones no solicitadas.
- Modifica solo lo imprescindible y conserva el estilo actual de cada proyecto.
- Explica las decisiones tecnicas importantes; la meta es aprender, no delegar todo.
- Indica comandos exactos y verifica con tests/lint/build cuando proceda.
- Solicita aprobacion antes de borrar datos, sustituir archivos de configuracion, cambiar credenciales o ejecutar operaciones irreversibles.
- Respeta CLAUDE.md especificos de cada repositorio.
- Usa GitHub Flow (rama feature, commit, PR, merge a main) cuando este configurado en el proyecto.
- Actualiza README, CHANGELOG y docs existentes cuando un cambio funcional lo justifique.
- UI: utiliza primero frontend-stack y su router; no fuerces multiples estéticas incompatibles.
- GSAP y Lenis son dependencias por proyecto, no globales.
