shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0; // 0=alive, 1=gone
uniform float split_strength : hint_range(0.0, 1.0) = 0.25;

void fragment() {
    float offset = progress * split_strength;

    // sample R, G, B channels at slightly different UV positions
    float r = texture(TEXTURE, UV + vec2(-offset, 0.0)).r;
    float g = texture(TEXTURE, UV).g;
    float b = texture(TEXTURE, UV + vec2(offset, 0.0)).b;
    float a = texture(TEXTURE, UV).a;

    // fade out + slight upward UV drift (ghost rising)
    vec2 drift_uv = UV + vec2(0.0, -progress * 0.15);
    a *= texture(TEXTURE, drift_uv).a;

    COLOR = vec4(r, g, b, a * (1.0 - progress));
}
