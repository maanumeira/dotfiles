// cursor_pulse.glsl — Blink "expand" estilo VSCode para Ghostty
// El shader es el UNICO que dibuja el cursor (cursor-opacity = 0.0).

const float PULSE_SPEED   = 6.2831853;  // velocidad del latido (rad/s)
const float PULSE_MIN     = 0.72;       // altura minima (fraccion de la real). Mas alto = menos adelgaza
const float PULSE_MAX     = 1.0;        // altura maxima
const float WIDTH_SCALE   = 2.2;        // multiplicador de ancho de la barra. >1 = mas gruesa
const float EDGE_SOFTNESS = 1.5;        // suavizado de bordes (px)

const vec3 CURSOR_COLOR = vec3(1.0, 1.0, 1.0);  // blanco puro

vec3 sRGBToLinear(vec3 c) {
    return mix(c / 12.92, pow((c + 0.055) / 1.055, vec3(2.4)), step(vec3(0.04045), c));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 base = texture(iChannel0, fragCoord / iResolution.xy);

    vec2 curPos  = iCurrentCursor.xy;
    vec2 curSize = iCurrentCursor.zw;

    if (curSize.x < 0.5 || curSize.y < 0.5) { fragColor = base; return; }

    float t = 0.5 + 0.5 * sin(iTime * PULSE_SPEED);
    float scaleY = mix(PULSE_MIN, PULSE_MAX, t);
    float newH = curSize.y * scaleY;
    float yGap = (curSize.y - newH) * 0.5;

    // Ensanchar la barra centrandola sobre su posicion original
    float newW = curSize.x * WIDTH_SCALE;
    float xGap = (newW - curSize.x) * 0.5;

    float boxTop    = curPos.y - yGap;
    float boxBottom = curPos.y - curSize.y + yGap;
    float boxLeft   = curPos.x - xGap;
    float boxRight  = curPos.x + curSize.x + xGap;

    vec2 p = fragCoord;
    float dx = min(p.x - boxLeft, boxRight - p.x);
    float dy = min(p.y - boxBottom, boxTop - p.y);
    float inside = smoothstep(0.0, EDGE_SOFTNESS, min(dx, dy));

    fragColor = mix(base, vec4(sRGBToLinear(CURSOR_COLOR), 1.0), inside);
}
