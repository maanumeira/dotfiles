// cursor_smooth_pulse.glsl — Movimiento smooth + blinking expand, barra fina con y sin foco.
// El shader es el UNICO que dibuja el cursor (cursor-opacity = 0.0).
// En desenfoque borra el hollow block muestreando el fondo real (no hardcodea color).

const float MOVE_DURATION = 0.16;

const float PULSE_SPEED   = 6.2831853;
const float PULSE_MIN     = 0.15;
const float PULSE_MAX     = 1.0;

// Estilo VS Code: sólido mientras escribes, parpadeo al quedarte quieto.
// iTimeCursorChange se refresca en cada tecleo (el cursor avanza), asi que
// "actividad reciente" = escribiendo -> se suprime el pulso.
const float IDLE_DELAY    = 0.5;   // seg. quieto antes de empezar a parpadear
const float PULSE_RAMP    = 0.2;   // suavizado de entrada del parpadeo

const float BAR_WIDTH_PX  = 3.0;
const float EDGE_SOFTNESS = 1.5;
const vec3  CURSOR_COLOR  = vec3(1.0, 1.0, 1.0);

vec3 sRGBToLinear(vec3 c) {
    return mix(c / 12.92, pow((c + 0.055) / 1.055, vec3(2.4)), step(vec3(0.04045), c));
}

float ease(float x) { return 1.0 - pow(1.0 - x, 3.0); }

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 base = texture(iChannel0, fragCoord / iResolution.xy);

    vec2 curPos  = iCurrentCursor.xy;
    vec2 prevPos = iPreviousCursor.xy;
    vec2 curSize = iCurrentCursor.zw;

    if (curSize.y < 0.5) { fragColor = base; return; }

    float moveT = clamp((iTime - iTimeCursorChange) / MOVE_DURATION, 0.0, 1.0);
    float e = ease(moveT);
    vec2 pos = mix(prevPos, curPos, e);

    vec2 p = fragCoord;

    // Sin foco: borrar el hollow block muestreando el fondo real de una celda
    // a la derecha del cursor (zona vacia), en vez de hardcodear el color.
    if (iFocus < 0.5) {
        vec2 sampleFc = vec2(pos.x + curSize.x * 1.5, pos.y - curSize.y * 0.5);
        vec3 bgReal = texture(iChannel0, sampleFc / iResolution.xy).rgb;

        vec2 cellMin = vec2(pos.x, pos.y - curSize.y);
        vec2 cellMax = vec2(pos.x + curSize.x, pos.y);
        vec2 cd = min(p - cellMin, cellMax - p);
        float inCell = step(0.0, min(cd.x, cd.y));
        base.rgb = mix(base.rgb, bgReal, inCell);
    }

    // Solo late cuando el cursor lleva quieto (no escribiendo). Al reanudar,
    // 'cos' arranca en 1.0 (solido) y el ramp evita el salto -> transicion suave.
    float timeSinceChange = iTime - iTimeCursorChange;
    float pulseAmount = smoothstep(IDLE_DELAY, IDLE_DELAY + PULSE_RAMP, timeSinceChange);
    float blinkTime = max(0.0, timeSinceChange - IDLE_DELAY);
    float rawPulse = 0.5 + 0.5 * cos(blinkTime * PULSE_SPEED);
    float t = mix(1.0, rawPulse, pulseAmount);
    float scaleY = mix(PULSE_MIN, PULSE_MAX, t);
    float newH = curSize.y * scaleY;
    float yGap = (curSize.y - newH) * 0.5;

    float boxTop    = pos.y - yGap;
    float boxBottom = pos.y - curSize.y + yGap;
    float boxLeft   = pos.x;
    float boxRight  = pos.x + BAR_WIDTH_PX;

    float dx = min(p.x - boxLeft, boxRight - p.x);
    float dy = min(p.y - boxBottom, boxTop - p.y);
    float inside = smoothstep(0.0, EDGE_SOFTNESS, min(dx, dy));

    fragColor = mix(base, vec4(sRGBToLinear(CURSOR_COLOR), 1.0), inside);
}
