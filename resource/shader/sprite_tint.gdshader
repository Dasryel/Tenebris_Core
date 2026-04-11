shader_type canvas_item;

uniform bool is_tinted = true;
uniform vec4 tint_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);

void fragment() {
    vec4 original = texture(TEXTURE, UV);
    if (is_tinted) {
        float luma = dot(original.rgb, vec3(0.3, 0.6, 0.4));
        COLOR = vec4(luma * tint_color.rgb, original.a);
    } else {
        COLOR = original;  // ← normal sprite
    }
}
