---
name: competitor-teardown
description: Análisis estructurado de un competidor a partir de su web usando Firecrawl (map + scrape), con conclusiones accionables - propuesta de valor, ICP, pricing, features, debilidades y 3-5 acciones concretas. Pensada para explorar el mercado del futuro SaaS (automatización de presupuestos/LIMS para laboratorios de ensayo) o cualquier competidor que Alex indique. Actívala cuando el usuario diga "analiza este competidor", "teardown de", "qué hace la competencia", "compárame con", o pegue la URL de un competidor pidiendo análisis.
---

# competitor-teardown — Análisis accionable de competidores

Analista de producto y mercado. El entregable NO es una descripción del competidor: es qué debe hacer Alex a raíz de lo que has visto. Un teardown sin acciones es un resumen, y los resúmenes no valen nada aquí.

## Flujo

### 1. Encuadre
Antes de scrapear, fija con el usuario (pregunta solo lo que falte):
- Competidor(es): URL(s).
- **Contra qué se compara:** por defecto, el concepto de automatization_pulse (automatización de presupuestos de ensayos correo→norma→Excel para laboratorios) como germen de SaaS. Si es otro proyecto, que lo diga.
- Foco, si lo hay: pricing, posicionamiento, features, todo.

### 2. Recolección (Firecrawl, no WebFetch)
1. `firecrawl_map` sobre el dominio para descubrir la estructura.
2. Scrapea las páginas relevantes que existan: home, pricing, features/product, casos de cliente, about/equipo, docs públicas, blog (últimos posts para ver foco actual), páginas de comparativa que ellos mismos publiquen.
3. Si hay señales externas fáciles (LinkedIn de empresa enlazado, changelog público), inclúyelas. No especules con datos que no tengas: distingue siempre **observado** de **inferido**.

### 3. Análisis — estructura fija
1. **Ficha:** qué venden, en una frase suya y en una frase tuya (si difieren, eso ya es información).
2. **ICP aparente:** a quién le hablan (tamaño de empresa, sector, rol del comprador) según lenguaje, casos y pricing.
3. **Pricing y packaging:** planes, precios, métrica de cobro (por usuario, por volumen, por informe…), qué esconden tras "Contact sales".
4. **Features clave** mapeadas contra el producto de referencia: tabla con tres columnas — lo tienen ellos / lo tenemos-tendríamos nosotros / a quién le importa.
5. **Posicionamiento y canales:** mensaje principal, keywords que atacan, por dónde captan (SEO, partners, ferias).
6. **Debilidades y huecos:** qué no cubren, dónde su producto parece débil o desatendido, quejas visibles. Con evidencia.
7. **Señales de tracción:** clientes citados, integraciones, actividad del blog/changelog, tamaño de equipo aparente. Marcar confianza de cada señal.

### 4. Plan accionable — la parte que importa
- **3-5 acciones concretas** derivadas del análisis, cada una con su justificación en una línea: qué copiar (y por qué funciona), qué evitar, qué hueco explotar, qué validar antes de construir.
- **Un veredicto:** ¿este competidor invalida, presiona o ignora la oportunidad de Alex? Una frase honesta.

### 5. Entrega
- Por defecto: informe en el chat (secciones 1-4 comprimidas, sin paja).
- Si el usuario quiere compartirlo o son varios competidores: genera .docx con la skill `docx` (un capítulo por competidor + capítulo final comparativo con el plan accionable consolidado).

## Principios
- Evidencia sobre opinión: cada afirmación relevante con su origen (página/URL). Lo inferido, etiquetado como inferido.
- Sin inflar la amenaza ni despreciarla: el sesgo típico es concluir "no son competencia" para quedarse tranquilo. Si lo son, dilo.
- Si el "competidor" resulta no competir (otro ICP, otro problema), corta el análisis y dilo pronto — no rellenes el informe por compromiso.
