// This file (vignette.gdshader) is not under the GPL.
// It is not, and should not be licensed, neither copyrightable.
// I can't claim this code. You're free to use the code in this file however you want,
// EXCEPT PARTS THAT HAVE A SPECIFIED COPYRIGHT AND LICENSE. Those are not fully my work,
// and their licenses must be respected.
// Credits to Me (Akosmo) or Oscillody are very appreciated though.

shader_type canvas_item;

// This shader creates a vignette effect.

uniform mediump float size : hint_range(0.0, 2.0, 0.05) = 0.0;
uniform highp vec4 color : source_color = vec4(vec3(0.0), 1.0);
uniform lowp float sharpness : hint_range(0.0, 20.0, 1.0) = 12.0;
uniform lowp float curve :  hint_range(1.0, 32.0, 1.0) = 2.0;
uniform lowp int shape : hint_enum("Ellipse", "Rectangle") = 0;
uniform lowp int falloff_function : hint_enum("Linear", "Exponential") = 0;

void fragment() {
	highp vec2 uv = SCREEN_UV;
	highp float vignette;

	// All equations are based on `uv = abs(uv * size - size * 0.5)`, to change UV range from (0-1) to (1-0-1).
	if (falloff_function == 0) {
		if (shape == 0) {
			uv.x = pow(abs(uv.x * size - size * 0.5), curve) * sharpness * 0.5;
			uv.y = pow(abs(uv.y * size - size * 0.5), curve) * sharpness * 0.5;
			vignette = uv.x + uv.y - (sharpness - 2.0) * 0.5;
		} else {
			float angle = size * sharpness;
			uv = abs(uv * angle * 0.5 - angle * 0.25);
			vignette = max(uv.x, uv.y) - ((sharpness - 2.0) * 0.5);
		}
	} else {
		uv = abs(uv * size - size * 0.5);
		if (shape == 0) {
			vignette = pow(pow(uv.x, curve) + pow(uv.y, curve), sharpness);
		} else {
			vignette = pow(max(uv.x, uv.y), sharpness);
		}
	}

	COLOR = vec4(clamp(vignette, 0.0, 1.0) * color);
}