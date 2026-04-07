shader_type canvas_item;

uniform bool is_locked = false;
uniform vec4 tint_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);

void fragment() {
    vec4 original = texture(TEXTURE, UV);

    if (is_locked) {
        // Luminance-weighted grayscale (perceptual brightness)
        float luma = dot(original.rgb, vec3(0.3, 0.6, 0.4));

        // Multiply grayscale by tint — preserves light/dark variation
        COLOR = vec4(luma * tint_color.rgb, original.a);
    } else {
        COLOR = original;
    }
}
