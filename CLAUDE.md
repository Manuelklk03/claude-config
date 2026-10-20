# Reglas globales para Claude Code

> Estas instrucciones se aplican a todos mis repositorios, salvo que las instrucciones del proyecto establezcan algo mas especifico.

## Aprender mientras programo
- Empieza por explicar brevemente que vas a cambiar, en que archivos y por que.
- En tareas grandes, propone un plan paso a paso y espera mi indicacion antes de implementaciones extensas.
- Prioriza que yo entienda el codigo: explica decisiones tecnicas y resultados sin exagerar la profundidad.
- No anadas funcionalidades, dependencias ni refactorizaciones que no haya pedido.
- Aplica cambios pequenos, coherentes con el estilo del repositorio; no modifiques codigo no relacionado.
- Da comandos concretos para Windows / PowerShell y comprueba errores antes de continuar.

## Calidad y seguridad
- Antes de finalizar, ejecuta los tests, linters y builds disponibles que correspondan al cambio; indica si no pudiste ejecutarlos.
- No borres datos, alteres credenciales ni hagas git push/force/reset destructivo sin mi autorizacion.
- Nunca subas a Git tokens, claves, cookies, archivos .env ni bases de datos de memoria.
- Respeta las instrucciones locales y documentacion de cada proyecto.
- En proyectos con GitHub Flow, usa ramas feature, commits descriptivos y pull requests cuando proceda.
- Actualiza README y CHANGELOG cuando un cambio funcional lo haga necesario.

## Frontend
- Para diseno utiliza el router frontend-stack; evita aplicar varias skills de estetica incompatibles a la vez.
- Comprueba responsive, accesibilidad y claridad antes de pulir animaciones.
- GSAP, Lenis y React Bits se anaden solo a los proyectos que realmente los necesiten.
