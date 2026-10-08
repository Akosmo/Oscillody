// This file (simple_gradient.gdshader) is not under the GPL.
// It is not, and should not be licensed, neither copyrightable.
// I can't claim this code. You're free to use the code in this file however you want,
// EXCEPT PARTS THAT HAVE A SPECIFIED COPYRIGHT AND LICENSE. Those are not fully my work,
// and their licenses must be respected.
// Credits to Me (Akosmo) or Oscillody are very appreciated though.

shader_type canvas_item;

// This shader creates a simple gradient background.

#include "res://Scripts/Shaders/Includes/blend_modes.gdshaderinc"

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform mediump vec4 color_1 : source_color = vec4(1.0);
uniform mediump vec4 color_2 : source_color = vec4(vec3(0.0), 1.0);
uniform lowp int origin : hint_enum("Bottom-Left", "Left", "Top-Left", "Top") = 0; // Location of `color_1`.

uniform lowp int blend_mode : hint_enum(
	"Normal",
	"Multiply",
	"Screen",
	"Overlay",
	"Soft-Light",
	"Color Dodge",
	"Linear Dodge",
	"Color Burn",
	"Linear Burn",
	"Simple Divide",
	"Simple Subtract",
	"Simple Difference"
) = 0;

void fragment() {
	highp vec2 uv = UV;

	highp vec4 output_color = vec4(0.0);
	if (origin == 0) {
		output_color = mix(color_1, color_2, vec4((uv.x - uv.y) * 0.5 + 0.5));
	}
	else if (origin == 1) {
		output_color = mix(color_1, color_2, vec4(uv.x));
	}
	else if (origin == 2) {
		uv.y = 1.0 - uv.y;
		output_color = mix(color_1, color_2, vec4((uv.x - uv.y) * 0.5 + 0.5));
	}
	else {
		output_color = mix(color_1, color_2, vec4(uv.y));
	}

	vec3 base_layer = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	COLOR = vec4(get_blend(blend_mode, base_layer, output_color.rgb), output_color.a);
}
