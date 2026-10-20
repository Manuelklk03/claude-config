# Claude Web, Claude Code y VS Code

Son entornos relacionados, pero no idénticos.

| Entorno | Qué recupera este kit |
|---|---|
| Claude Code desde PowerShell | Plugins, skills, reglas globales y programas CLI |
| Claude Code en VS Code (mismo PC) | La misma configuración de usuario y los mismos plugins |
| Claude Web (claude.ai chat) | Las skills/plugins compatibles instalados en la cuenta **desde Web**, no todo el kit local |
| Claude Code cloud remoto | No hereda automáticamente los plugins instalados en tu Windows |

## Configurar Claude Web

1. Abre Claude Web e inicia sesión con la misma cuenta que utilizas en Claude Code.
2. En la sección de personalización o plugins, revisa qué skills/plugins ofrece tu cuenta.
3. Importa o instala solo los que Claude Web permita (por ejemplo, skills compatibles como Task Observer, si el producto permite importarlas).
4. Ciertos plugins de claude.ai pueden sincronizarse **de la cuenta hacia Claude Code**, cuando la versión y la autenticación lo admiten. Los plugins locales instalados con la CLI **no se suben** a Claude Web automáticamente.

### Cómo se ve la sincronización en tu PC

`claude plugin list` muestra una sección **"Synced from claude.ai"** con los plugins de tu cuenta (se guardan en `~/.claude/plugins/synced/`). Si uno se llama igual que un plugin local (por ejemplo `claude-code-setup`), **gana el local** y el sincronizado aparece como *not loaded*: es normal y no hay que hacer nada.

Limitaciones: los hooks locales (Claude-Mem, PonyTail), las CLIs (Playwright, Agent Browser, OmniRoute), las skills de `~/.claude/skills` y la memoria local **no existen** en Claude Web.

## VS Code

1. Instala la extensión oficial **Claude Code** (`anthropic.claude-code`; el instalador lo hace si `code` está en el PATH).
2. La extensión usa la misma carpeta `~/.claude` que la terminal: mismos plugins, skills y reglas en cualquier carpeta que abras.
3. Tras instalar o actualizar algo que toque el PATH (Claude-Mem, Bun, CLIs de npm), **cierra todas las ventanas de VS Code** y vuelve a abrirlo. Abrir una ventana nueva no basta.
4. Las reglas de cada proyecto (`CLAUDE.md`, `.claude/settings.json` del repo) se suman a las globales.

Nunca copies desde GitHub tokens, cookies de sesión, credenciales de OmniRoute ni la base de memoria local.

Documentación: https://code.claude.com/docs/en/discover-plugins
