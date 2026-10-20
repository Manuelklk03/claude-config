# 🔐 Seguridad y credenciales

## Qué nunca se sube a GitHub

Lo bloquea [`.gitignore`](../.gitignore):

| Tipo | Ejemplos |
|---|---|
| Logs, informes y copias del kit | `.local/` (incluye `install.log`, `report.json`, copias de `settings.json`) |
| Variables y credenciales | `.env`, `.env.*`, `**/credentials*`, `**/secrets*`, `*.pem`, `*.key` |
| Bases de datos | `*.db`, `*.sqlite*`, `.claude-mem/` |
| Ajustes locales de proyecto | `.claude/settings.local.json` |
| Archivos autogenerados | `.windsurf/rules/claude-mem-context.md` |
| Publicación privada | `PUBLICAR-EN-GITHUB.cmd`, `scripts/publish.ps1` |

> [!NOTE]
> `.gitignore` no afecta a archivos que Git **ya** sigue. Para dejar de seguir uno conservando la copia local: `git rm --cached <archivo>` y commit.

Antes de cada commit revisa `git status` y `git diff --cached`.

## Dónde viven las credenciales (fuera del repo)

| Credencial | Ubicación |
|---|---|
| Sesión de Claude Code | `~/.claude/.credentials.json` |
| GitHub | Git Credential Manager (Administrador de credenciales de Windows) |
| Token de webhook de PonyTail | Llavero del sistema (si algún día lo configuras) |
| Claves de Claude-Mem | `~/.claude-mem/.env` (vacío en la configuración recomendada) |
| Proveedores de OmniRoute | Configuración propia de OmniRoute |

## Valores predeterminados seguros

- **PonyTail**: registro local (`ledger=true`), sin webhook, sin enviar nombres de tareas.
- **Claude-Mem**: proveedor `claude`, sin cuenta cmem.ai, sin sincronización en la nube.
- **OmniRoute**: CLI instalada, ningún proveedor conectado ni proxy activo.
- **Headroom, Caveman, Anti AI Slop**: instalados y desactivados.

## Plugins de terceros

Un plugin puede ejecutar hooks con los permisos de tu usuario en cada sesión. Antes de añadir uno nuevo, revisa su repositorio (`hooks/`, scripts) y usa `claude plugin details <id>`.

Si un secreto llega a un commit, **cámbialo** en el servicio de origen: borrar el archivo después no lo elimina del historial.
