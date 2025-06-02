// This file (lens_distortion.gdshader) is not under the GPL.
// It is not, and should not be licensed, neither copyrightable.
// I can't claim this code. You're free to use the code in this file however you want,
// EXCEPT PARTS THAT HAVE A SPECIFIED COPYRIGHT AND LICENSE. Those are not fully my work,
// and their licenses must be respected.
// Credits to Me (Akosmo) or Oscillody are very appreciated though.

shader_type canvas_item;

// This shader creates a lens distortion effect.

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform mediump float strength : hint_range(-0.5, 1.5, 0.05) = 0.0;
uniform mediump float zoom : hint_range(0.1, 2.0, 0.1) = 1.0;
uniform bool border = true;
uniform mediump vec4 border_color : source_color = vec4(vec3(0.0), 1.0);
uniform mediump float chromatic_aberration_strength : hint_range(0.0, 6.0, 0.1) = 0.0;

// Applying lens distortion by scaling UV around the corners.
void fragment() {
	highp vec2 uv = SCREEN_UV;
	uv = uv * 2.0 - 1.0; // Changing UV range from (0 to 1) to (-1 to 1)

	// Exponential value from 0.0 to 1.0, mapping distortion.
	highp float magnitude = (pow(uv.x, 2.0) + pow(uv.y, 2.0)) * 0.5;
	uv *= 1.0 + strength * magnitude; // Applying distortion by scaling UV where magnitude is present

	// Scaling UV based on strength to match viewport
	// Scaling factor by aleklesovoi: https://www.shadertoy.com/view/DldXWS
	highp float scale = 1.0 / (abs(strength) + 1.0);
	uv *= scale * zoom;

	uv = uv * 0.5 + 0.5; // Recentering distorted UV, back to (0 to 1) range

	highp float color_offset = 0.005;
	highp float channel_offset = magnitude * strength * chromatic_aberration_strength * color_offset;
	highp vec4 screen_tex = vec4(0.0);
	if (chromatic_aberration_strength > 0.0) {
		screen_tex.r = texture(SCREEN_TEXTURE, uv + channel_offset).r;
		screen_tex.g = texture(SCREEN_TEXTURE, uv).g;
		screen_tex.b = texture(SCREEN_TEXTURE, uv - channel_offset).b;
		screen_tex.a = texture(SCREEN_TEXTURE, uv).a;
	}
	else {
		screen_tex = texture(SCREEN_TEXTURE, uv);
	}

	if ((uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) && border) {
		COLOR = border_color;
	}
	else {
		COLOR = screen_tex;
	}
}
