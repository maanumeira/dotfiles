---
name: sync-ideas
description: >
  Procesa las ideas con estado 'Raw' en Notion generando un título conciso
  para cada una usando Claude Haiku como subproceso independiente.
  Actívala cuando digas "sync ideas", "procesa mis ideas", "pon título a las ideas",
  "titula mis ideas raw" o invocando /sync-ideas.
---

# sync-ideas

Ejecuta el script que lanza Claude Haiku en modo no-interactivo para generar
títulos concisos a todas las ideas con estado `Raw` en Notion.

## Paso único

```bash
python3 ~/.claude/scripts/sync_ideas.py
```

El script:
1. Consulta la base de datos de Notion filtrando ideas con estado `Raw`
2. Lanza `claude -p --model haiku` con todas ellas en un solo prompt
3. Parsea el JSON de respuesta y actualiza cada página en Notion (`estado: Pending`)
4. Imprime los títulos generados

## Tras ejecutarlo

Muestra al usuario el output del script tal cual.

## Si falla

- Sin ideas Raw: el script lo indica y termina limpiamente
- Error de Haiku: reintenta — las páginas de Notion no se modifican hasta parsear correctamente
- JSON malformado en respuesta: Haiku a veces añade markdown, el script extrae el JSON igualmente;
  si persiste, revisa que el CLI `claude` esté en el PATH con `which claude`
- Error de Notion API: verifica que la integración sigue conectada a la página Ideas en Notion
