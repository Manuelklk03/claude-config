# Claude Web: qué se sincroniza realmente (octubre 2026)

La cuenta de Claude admite plugins desde **Personalizar > Plugins** y skills desde **Personalizar > Habilidades/Skills** (nombres pueden variar con el idioma). Los plugins y skills que instales directamente en Claude Web pueden sincronizarse a Claude Code con la **misma cuenta** y Claude Code **v2.1.273 o posterior**. 

- Sincronizacion cuenta Claude → Claude Code, no al revés. No implica que el instalador local cree automaticamente plugins en la web.
- No funciona con autenticacion por clave API ni terceros cloud Bedrock.
- Skills/comandos de plugins pueden usarse en chat; hooks, servidores locales y subagentes solo se ejecutan en entornos compatibles como Claude Code/Cowork.
- Para el plugin oficial **Claude Code Setup**, en claude.ai entra en Personalizar > Plugins > Descubrir y busca "Claude Code Setup" (Anthropic verificado).
- Para **Task Observer**, comprime `SKILL.md` junto a `references/` en un ZIP y subelo a Skills en la web, si tu cuenta permite importar skills.
- Los plugins comunitarios de GitHub pueden requerir agregarlos como marketplace desde Personalizar > Plugins > Agregar mercado > repositorio.
- No subas tokens, logs privados ni la carpeta de memoria a GitHub.

Fuentes: https://support.claude.com/es/articles/13837440-usar-plugins-en-claude y https://support.claude.com/es/articles/12512180-usar-habilidades-en-claude
