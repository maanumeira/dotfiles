# Preferencias globales de desarrollo

## Identidad y contexto
Manuel Meira, estudiante de 4º de Economía (USC) construyendo un perfil híbrido
economía + técnico. **Principiante en programación**, sin experiencia previa de código.
Entorno: macOS, Claude Code en terminal.

Formación por fases: SQL (oct–dic 2026) → Excel + Power BI (dic 2026–abr 2027) →
Python (abr–jun 2027) → finanzas (jun–jul 2027). **Hasta abril de 2027 el foco es SQL
y BI, no Python**: si algo se resuelve con SQL o una herramienta de datos, esa vía
antes que escribir código.

Implicación práctica: no des por supuesto vocabulario ni convenciones de
programación. Cuando aparezca un término técnico nuevo, defínelo en una línea la
primera vez que lo uses. Explica el *por qué* de cada decisión, no solo el *qué* —
estoy aprendiendo el criterio, no solo el resultado.

---

## Idioma y comunicación
- Responde siempre en **español**
- Términos técnicos en su idioma original (API, embeddings, fine-tuning, pipeline, etc.)
- Tono técnico y directo, como un colega senior. Sin condescendencia, sin relleno
- Si algo en mi planteamiento o código es mejorable, dímelo sin que te lo pida — pero explica el razonamiento antes de tocar nada

---

## Flujo de trabajo general

### Planificación
- **Siempre** presenta un plan explícito antes de implementar cualquier cosa
- El plan debe incluir: qué vas a hacer, en qué orden, y qué archivos se van a modificar o crear
- Espera mi confirmación antes de empezar a escribir código

### Autonomía
- Cambios pequeños (renombrar variable, corregir typo, ajuste de formato): actúa directamente
- Cambios grandes (nueva función, refactor de módulo, cambio de arquitectura, borrar código): pregunta primero
- Si detectas algo mejorable que no te he pedido, explícame por qué lo cambiarías y espera mi OK antes de modificar nada

### Inicio de proyectos nuevos
- No tengo repo plantilla propio todavía
- Al arrancar un proyecto nuevo: propón tú la estructura mínima (carpetas, README,
  gestión de dependencias, tests) y **explícame por qué cada pieza está ahí** antes
  de crearla
- **SDD + TDD es un objetivo a largo plazo, no mi modo de trabajo actual.** No lo
  impongas en los primeros proyectos: empieza por algo ligero y ve introduciendo
  piezas de la metodología conforme coja soltura, explicando qué aporta cada una

---

## Código Python

### Entorno y dependencias
- Gestor de entorno por defecto: **conda** (miniconda, instalado vía Homebrew)
- Instalación de paquetes: **pip** dentro del entorno conda
- Motivo de la elección: coincide con el stack de mis cursos de datos
- Si un proyecto concreto requiere otro gestor, se especificará en el CLAUDE.md del proyecto

### Activación automática del entorno (.envrc + direnv)
- Todo proyecto con entorno propio lleva un `.envrc` en la raíz que lo activa al entrar en la carpeta (direnv está instalado vía Homebrew y con hook en `.zshrc`). Si un proyecto no lo tiene, créalo así:
  ```bash
  # Activa el entorno conda del proyecto al entrar en la carpeta (direnv).
  # Archivo local por desarrollador — ignorado por git.
  source /opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh
  conda activate <nombre-del-entorno>
  ```
- Tras crearlo: añadir `.envrc` a `.gitignore` (es por-desarrollador, no se commitea), ejecutar `direnv allow .` y verificar con `direnv exec . python -c "import sys; print(sys.executable)"` que resuelve al entorno del proyecto.
- Al ejecutar comandos del proyecto desde Claude Code, no confíes en que el entorno esté activo: usa el binario explícito del entorno o `direnv exec .`.

### Estilo y convenciones
- Prioridad 1: seguir exactamente las convenciones del proyecto (si las hay)
- Prioridad 2: legibilidad y claridad sobre complejidad innecesaria
- Prioridad 3: incluir tests cuando tenga sentido
- Prioridad 4: rendimiento (solo optimizar si hay un motivo claro)
- Type hints en todas las funciones nuevas
- Docstrings en Google style para funciones y clases no triviales

### Comentarios
- Comentar decisiones no obvias y lógica compleja
- No comentar lo que el código ya dice claramente
- Si hay una decisión de diseño importante, añade un comentario explicando el *por qué*, no el *qué*

### Linting y formateo (ruff)
- Tras escribir o modificar código Python, pasa **ruff** a los ficheros que hayas tocado, como parte del bucle escribir→verificar→entregar: `ruff check --fix <ficheros>` (imports/variables sin usar, bugs, estilo) y `ruff format <ficheros>` (formateo).
- Aplícalo **solo a lo que has tocado**; no reformatees código ajeno (respeta "no cambios no solicitados").
- Si el proyecto tiene config propia (`ruff.toml` o `[tool.ruff]` en `pyproject.toml`), respétala. Si el proyecto usa otro linter/formateador (black, flake8…), sigue esa convención en vez de imponer ruff (Prioridad 1: convenciones del proyecto).

### Tests
- Favorece **TDD** cuando haya lógica real: primero el test que falla, luego la implementación mínima (red→green→refactor). Si el proyecto define su propia metodología, síguela.
- Usa **pytest** a menos que la tarea del proyecto justifique otra herramienta — en ese caso, propónmela y explica por qué

---

## Git

### Ramas
- Trabajo en ramas como control de versiones, con commits paso a paso entre cada cambio significativo
- Cada rama representa una feature, fix o experimento concreto

### Commits
- Mensajes descriptivos en español, explicando qué se hizo y por qué si no es obvio
- No uses conventional commits por defecto (feat:, fix:, etc.) salvo que el proyecto lo especifique
- **Los commits los hace Claude Code por delegación mía**: commit automático tras cada cambio significativo, dejando un historial que narre el proyecto paso a paso
- **El merge a main NO es automático** — solo cuando yo lo diga

---

## Mejoras proactivas
- Si ves un problema real (bug latente, antipatrón, deuda técnica) en código que estoy tocando, señálalo
- Formato: "He notado X — podría causar Y. ¿Quieres que lo mejore?" — y espera respuesta
- No hagas refactors no solicitados aunque el código sea mejorable
