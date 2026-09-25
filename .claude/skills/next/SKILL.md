---
name: next
description: Cierra la sesión y prepara la siguiente. Deja la bitácora y el «por dónde seguir» al día, y genera el prompt de compactación listo para pegar. Actívala cuando el usuario diga "/next", "prepara el prompt para compactar", "cierra la sesión", "prepárame el siguiente Claude" o "vamos a compactar".
---

# next — cerrar una sesión y preparar la siguiente

Tu trabajo es dejar el proyecto en un estado en el que **otro Claude sin memoria pueda seguir
sin preguntar nada**, y darle a Alex una sola línea que pegar.

**Lo que NO puedes hacer, y hay que decirlo en vez de simularlo**: ejecutar `/compact`. Es un
comando del cliente, no una herramienta. Tú lo dejas todo escrito y le das el comando montado.

---

## 1 · Mide el estado antes de escribirlo

**Nada de memoria: comandos.** Si un número va a un documento, sale de ejecutarlo ahora.

```bash
git status --short && git log --oneline origin/main..HEAD | wc -l
```

Y las suites, con los comandos de verificación **que valen en este proyecto**:

- backend: `mypy` **a secas** (nunca `mypy app`), `pytest -q`, `ruff check .`, `ruff format --check .`
- frontend: `npm run build` o `npx tsc -b` (**nunca** `tsc --noEmit`), `npx vitest run`, `npm run lint`
- CI remoto: `gh run list --limit 1` — **el verde que vale es ése**, no el local

Si algo está en rojo o sin pushear, **eso va en el prompt en mayúsculas**. Un traspaso que
oculta un rojo es peor que no traspasar.

## 2 · Deja el rastro en disco, que es lo que sobrevive a la compactación

Dos ficheros, si el proyecto los tiene (créalos sólo si ya existe la convención):

**`docs/BITACORA.md`** — entrada nueva **al principio**, en el «📍 Estado actual», con:
- qué entró, con cifras medidas;
- las decisiones que tomó Alex, citadas;
- **lo que se rompió y cómo se encontró** — este proyecto aprende de eso más que de lo que salió bien;
- **retro de proceso en una línea**: la fricción de la metodología, no del código.

**`docs/PROXIMA-SESION.md`** — reescrito entero, no parcheado: dónde estamos, qué queda
nuestro, qué espera a terceros, y lo que quedó abierto y declarado.

> **Actualizar solo lo que cambia deja mintiendo a lo que lo rodea.** Antes de dar por bueno
> ese fichero, **relee lo que NO has tocado** y comprueba que sigue siendo cierto. En este
> proyecto ha pasado tres veces en un día.

Commitea los dos. El merge y el push **los decide Alex**, no tú.

## 3 · Monta el prompt de compactación

Va en un bloque ```` ``` ```` para que se pegue de una vez, empezando por `/compact`. Estructura:

1. **La metodología**, innegociable, en una frase por paso, con los comandos de verificación.
2. **Las lecciones**, que son el activo real: las de siempre más las de hoy, cada una con **el
   caso concreto que la ganó**. Una lección sin su ejemplo se olvida.
3. **El estado**: ramas, commits sin pushear, suites con sus números, CI.
4. **Lo abierto**: criterios sin cerrar, decisiones que esperan a Alex, deuda activa.
5. **Qué se puede descartar**: recorridos de depuración y salidas de tests, **salvo las cifras
   medidas** — ésas se conservan siempre.

## 4 · Y el prompt de continuación

**No lo pegues en el chat: ya está en `docs/PROXIMA-SESION.md`.** Lo que le das a la sesión
siguiente es una línea corta que lo mande leer, más la hoja de ruta en pasos numerados, en
orden, con **por qué ese orden**.

Regla dura del proyecto y la que más ha rendido: **si un paso implica escribir código, el
primer sub-paso es escribir el criterio y pedir el OK.** Un alcance aprobado sin criterio
escrito no es trabajo pendiente, es trabajo invisible.

## 5 · Lo que entregas, en este orden

1. Dos frases con el estado real (verde/rojo, pusheado/no).
2. El bloque ```` ``` ```` con el `/compact …` listo para pegar.
3. La hoja de ruta en pasos, y el recordatorio de que vive en `docs/PROXIMA-SESION.md`.
4. Si algo quedó sin resolver esperando a Alex, **la pregunta concreta**, no «¿seguimos?».

---

## Lo que no se hace nunca aquí

- **No inventes que has compactado.** Tú preparas; el comando lo ejecuta Alex.
- **No metas cifras de memoria.** Si no la has ejecutado esta sesión, no va.
- **No maquilles.** Si la sesión rompió algo, se escribe en la bitácora y en el prompt.
- **No dejes trabajo sin commitear** antes de proponer la compactación: lo que no está en un
  commit no sobrevive.
