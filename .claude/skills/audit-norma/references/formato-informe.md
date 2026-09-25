# Formato del informe de auditoría

El informe se entrega en markdown (archivo `informe-auditoria-<documento>.md` si el usuario quiere archivo; en chat si no). Estructura fija:

## 1. Resumen ejecutivo
- Documento(s) auditado(s), fecha de auditoría y modo (A o B).
- Recuento de hallazgos por severidad: 🔴 Alta / 🟡 Media / 🔵 Baja.
- Las 1-3 conclusiones que el lector necesita aunque no lea el resto.

## 2. Tabla de hallazgos

| ID | Sev. | Tipo | Descripción | Ubicación | Evidencia |
|----|------|------|-------------|-----------|-----------|
| H1 | 🔴 | Valores en conflicto | ... | §4.2 (p. 12) vs. Anexo B (p. 34) | "cita A" / "cita B" |

Ordenada por severidad descendente. Tipos válidos: Valores en conflicto · Unidades · Referencia rota · Norma citada inconsistente · Condiciones incompatibles · Criterio ambiguo · Omisión (modo B) · Extra (modo B) · Discrepancia (modo B).

## 3. Detalle de hallazgos Alta
Solo los 🔴: un bloque por hallazgo con las dos citas completas, por qué es un conflicto real y qué interpretación recomendarías pedir/adoptar.

## 4. Sospechas sin evidencia concluyente
Posibles problemas que no se pudieron confirmar con citas localizables. Separados explícitamente para que nadie los confunda con hallazgos.

## Criterios de severidad
- **🔴 Alta:** afecta al resultado del ensayo, al importe del presupuesto o a la conformidad (valores/criterios de aceptación en conflicto, omisiones de ensayos exigidos).
- **🟡 Media:** ambigüedad que obliga a interpretar y podría resolverse de dos formas con consecuencias distintas (unidades ambiguas, criterios interpretables, discrepancias menores de cantidades).
- **🔵 Baja:** erratas, referencias rotas sin impacto en requisitos, inconsistencias de estilo o numeración.
