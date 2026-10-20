# ✨ Lenis, GSAP y React Bits — Guía para proyectos web

Estos recursos son **dependencias de una aplicación**, no plugins globales de Claude Code. Se instalan dentro del proyecto que los vaya a utilizar.

## 1. Antes de empezar

Abre **la carpeta raíz del proyecto** (donde está `package.json`) en VS Code. Si ejecutas los comandos en el repositorio `claude-config`, instalarás las dependencias **en el sitio equivocado**.

```powershell
# Comprueba que estás en la raíz de tu aplicación
Test-Path .\package.json
```

Debe mostrar `True`.

## 2. Lenis: scroll suave

[Documentación](https://github.com/darkroomengineering/lenis) · [Web](https://lenis.darkroom.engineering/)

Instalar:

```powershell
npm install lenis
```

### Ejemplo: Next.js con App Router

Crea `src/components/SmoothScroll.tsx`:

```tsx
"use client";

import { useEffect } from "react";
import Lenis from "lenis";

export default function SmoothScroll() {
  useEffect(() => {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
      return;
    }

    const lenis = new Lenis({ autoRaf: true });
    return () => lenis.destroy();
  }, []);

  return null;
}
```

Importa los estilos globales del paquete en `src/app/layout.tsx`:

```tsx
import "lenis/dist/lenis.css";
```

Y añade el componente al interior del `<body>` que **ya tengas** en ese layout:

```tsx
<>
  <SmoothScroll />
  {children}
</>
```

Recuerda importar `SmoothScroll` en el layout desde `@/components/SmoothScroll` (o tu ruta correspondiente). Mantén los demás elementos y proveedores ya existentes en tu `layout.tsx`.

**Consejo:** evita aplicarlo sin revisar a páginas con mucho scroll anidado, formularios delicados o requisitos especiales de accesibilidad. Respeta `prefers-reduced-motion`.

## 3. GSAP: animaciones

[Documentación oficial](https://gsap.com/docs/v3/Installation/)

En proyectos React/Next.js:

```powershell
npm install gsap @gsap/react
```

Crea `src/components/FadeInHeading.tsx`:

```tsx
"use client";

import { useRef } from "react";
import gsap from "gsap";
import { useGSAP } from "@gsap/react";

gsap.registerPlugin(useGSAP);

export default function FadeInHeading() {
  const container = useRef<HTMLDivElement>(null);

  useGSAP(() => {
    gsap.fromTo(
      ".heading",
      { opacity: 0, y: 24 },
      { opacity: 1, y: 0, duration: 0.65, ease: "power2.out" }
    );
  }, { scope: container });

  return (
    <div ref={container}>
      <h1 className="heading">Mi proyecto</h1>
    </div>
  );
}
```

Este componente debe utilizarse desde una página o componente React. En Next.js, las animaciones con GSAP se ejecutan en componentes cliente.

## 4. GSAP + Lenis en el mismo proyecto

Puedes usar ambas librerías en páginas que combinan scroll suave y animaciones al desplazarse. La documentación oficial explica cómo conectar los eventos de Lenis con `ScrollTrigger` para mantenerlas sincronizadas:

- [Integración de Lenis y GSAP](https://www.npmjs.com/package/lenis)
- [GSAP ScrollTrigger](https://gsap.com/docs/v3/Plugins/ScrollTrigger/)

No montes **dos bucles de animación** diferentes sin coordinarlos. Tampoco actives Lenis y GSAP ScrollSmoother a la vez sin una razón concreta, porque ambos alteran el comportamiento del desplazamiento.

## 5. React Bits: componentes listos para adaptar

[React Bits](https://reactbits.dev/) · [Repositorio](https://github.com/DavidHDev/react-bits)

**Opción sencilla:** abre un componente en React Bits, selecciona **TypeScript + Tailwind** (o CSS si tu proyecto no usa Tailwind), copia el código y añade las dependencias que indique su ficha. Es lo más cómodo para uno o dos componentes.

**Opción CLI:** si ya tienes `shadcn/ui` configurado y el registro `@react-bits` en tu `components.json`, puedes instalar un componente concreto:

```powershell
npx shadcn@latest add @react-bits/SplitText-TS-TW
```

Para configurar el registro, añade dentro del objeto raíz de `components.json` (sin borrar lo que ya exista):

```json
{
  "registries": {
    "@react-bits": "https://reactbits.dev/r/{name}.json"
  }
}
```

El bloque anterior es **solo el fragmento de configuración** que se debe fusionar con tu archivo actual; no reemplaces todo `components.json` por ese ejemplo.

La variante, el nombre y las dependencias exactas pueden variar entre componentes. Utiliza siempre el comando que muestre la ficha de React Bits.

## 6. Instalar GSAP + Lenis con el script del kit

Si prefieres reutilizar el script incluido en `claude-config`, abre **PowerShell en tu proyecto** y ejecuta, sustituyendo la ruta por la ubicación real del kit:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\ruta\a\claude-config\scripts\frontend-deps.ps1" -GSAP -Lenis -ReactGSAP
```

El script instala `gsap`, `lenis` y `@gsap/react` en el proyecto actual. Si no usas React, omite `-ReactGSAP`.

## 7. ¿Qué usar en cada proyecto?

| Proyecto | Recomendación |
|---|---|
| Portfolio Next.js | Lenis opcional, GSAP para animaciones concretas, React Bits solo donde aporte valor |
| ValveDex | React Bits para algunos componentes y GSAP si hay interacciones específicas; Lenis no es imprescindible |
| Digital-Fit (Angular) | GSAP y Lenis son compatibles; **React Bits es para React**, no para Angular |
| Landing informativa | Priorizar rendimiento, accesibilidad y animaciones discretas antes que instalar las tres herramientas |

## 8. Guardar dependencias en Git

Cuando ejecutes `npm install`, se actualizarán `package.json` y el archivo de bloqueo. Sube **esos archivos al repositorio del proyecto**, no `node_modules`.

En otro ordenador recuperarás las dependencias entrando en el proyecto y ejecutando:

```powershell
npm ci
```

`npm ci` utiliza las versiones bloqueadas en `package-lock.json`. Es independiente del instalador global de Claude Code.
