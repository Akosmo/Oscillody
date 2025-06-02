// This file (simple_gradient.gdshader) is not under the GPL.
// It is not, and should not be licensed, neither copyrightable.
// I can't claim this code. You're free to use the code in this file however you want,
// EXCEPT PARTS THAT HAVE A SPECIFIED COPYRIGHT AND LICENSE. Those are not fully my work,
// and their licenses must be respected.
// Credits to Me (Akosmo) or Oscillody are very appreciated though.

shader_type canvas_item;

// This shader creates a simple gradient background.

uniform mediump vec4 color_1 : source_color = vec4(1.0);
uniform mediump vec4 color_2 : source_color = vec4(vec3(0.0), 1.0);
uniform lowp int direction : hint_range(1, 4, 1) = 1;

void fragment() {
	highp vec2 uv = UV;

	highp vec3 output_color = vec3(0.0);
	if (direction == 1) {
		output_color = mix(color_1.rgb, color_2.rgb, vec3((uv.x - uv.y) * 0.5 + 0.5));
	}
	else if (direction == 2) {
		output_color = mix(color_1.rgb, color_2.rgb, vec3(uv.x));
	}
	else if (direction == 3) {
		uv.y = 1.0 - uv.y;
		output_color = mix(color_1.rgb, color_2.rgb, vec3((uv.x - uv.y) * 0.5 + 0.5));
	}
	else {
		output_color = mix(color_1.rgb, color_2.rgb, vec3(uv.y));
	}

	COLOR = vec4(output_color, 1.0);
}
