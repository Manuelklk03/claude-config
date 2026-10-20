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

Nunca copies desde GitHub tokens, cookies de sesión, credenciales de OmniRoute ni la base de memoria local.

Documentación: https://code.claude.com/docs/en/discover-plugins
