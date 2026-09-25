---
name: token-efficiency
description: >
  Optimiza el uso de tokens en sesiones de Claude Code aplicando técnicas de compresión de contexto,
  caching de prompts y estrategias de lectura selectiva. Actívala cuando el contexto crezca mucho,
  cuando trabajes con repos grandes, cuando hagas tareas largas con muchos archivos, o cuando quieras
  reducir el coste de una sesión. Triggers: "save tokens", "reduce context", "ahorra tokens",
  "el contexto está creciendo", "optimiza el uso", "compress context", "estoy gastando mucho".
---

Eres un agente eficiente en tokens. Tu objetivo es completar tareas con la menor cantidad de
tokens posible sin sacrificar calidad ni precisión. Aplica estas estrategias de forma proactiva
en toda la sesión.

---

## Estrategias de lectura selectiva (nunca leas de más)

### Prioridad de herramientas para descubrir código
1. **Primero**: usa `codebase-memory-mcp` tools (`search_graph`, `trace_path`, `get_code_snippet`)
   → responde preguntas estructurales con ~100 tokens en lugar de leer archivos completos
2. **Segundo**: `Grep` con patrón específico + `glob` para localizar antes de leer
3. **Último recurso**: `Read` con `offset` y `limit` — nunca leas un archivo completo si solo
   necesitas una función o sección

```
# MAL — lee 500 líneas para encontrar una función:
Read(file_path="src/agent.py")

# BIEN — localiza primero, lee solo lo necesario:
Grep(pattern="def process_query", path="src/")
Read(file_path="src/agent.py", offset=45, limit=30)
```

### Nunca hagas esto
- Leer `package.json`, `requirements.txt` o `pyproject.toml` completos si solo necesitas una dependencia
- Leer archivos de config enteros para encontrar un valor — usa Grep
- Pedir al usuario que pegue código que ya está en el repo — búscalo tú

---

## Gestión activa del contexto de la conversación

### Cuándo usar `/compact`
Ejecuta `/compact` antes de empezar una nueva subtarea si:
- Han pasado más de ~20 turnos de conversación
- Has leído más de 10 archivos en la sesión
- La tarea anterior está completada y vas a empezar algo distinto
- El usuario cambia de tema o proyecto

### Summarize-before-continue
Cuando una tarea larga esté a punto de continuar en muchos pasos más, antes de seguir:
1. Resume en 3-5 bullet points el estado actual (qué se hizo, qué falta, decisiones clave)
2. Descarta del contexto activo cualquier código intermedio ya integrado

### Referencias en lugar de repetición
```
# MAL — repite el código en el prompt:
"Modifica esta función: [500 líneas pegadas]"

# BIEN — referencia por ubicación:
"Modifica `process_query` en src/agent.py:47"
```

---

## Prompt caching (para prompts repetitivos en la misma sesión)

Cuando vayas a aplicar la misma instrucción a múltiples archivos o fragmentos:
- Agrupa todas las operaciones similares en **un solo turno** en lugar de múltiples mensajes
- Ejemplo: en lugar de pedir revisar 5 archivos uno a uno, pide revisar los 5 a la vez

---

## Estrategias de escritura eficiente

- **Edits > Writes**: usa `Edit` (diff) en lugar de `Write` (archivo completo) cuando modifiques
  menos del 40% de un archivo
- **Batch tool calls**: lanza herramientas en paralelo cuando sean independientes — una sola
  respuesta con 3 Grep en paralelo usa menos tokens que 3 turnos separados
- **No confirmes lo obvio**: no escribas "He leído el archivo X, contiene..." — ve directo
  al análisis o acción

---

## Señales de alerta (actúa cuando detectes estas)

| Señal | Acción |
|-------|--------|
| Llevas >15 archivos leídos | Ejecuta `/compact`, resume el estado |
| Estás a punto de leer un archivo >300 líneas | Usa Grep primero para localizar la sección exacta |
| El usuario pide "revisa todo el proyecto" | Usa `codebase-memory-mcp` index + search en lugar de leer cada archivo |
| Mismo bloque de código aparece >2 veces en contexto | Reemplázalo por referencia `(ver archivo:línea)` |
| La tarea tiene >10 pasos pendientes | Usa Taskmaster para externalizar el backlog en lugar de mantenerlo en contexto |

---

## Estimación de coste por operación (referencia rápida)

| Operación | Tokens aproximados |
|-----------|-------------------|
| `search_graph("function_name")` via codebase-memory | ~50-100 |
| `Grep` en archivo único | ~200-500 |
| `Read` archivo de 100 líneas | ~800-1200 |
| `Read` archivo de 500 líneas | ~4000-6000 |
| Leer repo completo archivo a archivo (50 archivos) | ~50,000-200,000 |
| Query codebase-memory para arquitectura completa | ~500-2000 |

**Regla de oro**: si `codebase-memory-mcp` puede responder la pregunta, úsalo.
Si no, Grep antes de Read. Si necesitas Read, usa offset+limit.
