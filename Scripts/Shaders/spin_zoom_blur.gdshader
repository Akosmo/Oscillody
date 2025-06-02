// This file (spin_zoom_blur.gdshader) is not under the GPL.
// It is not, and should not be licensed, neither copyrightable.
// I can't claim this code. You're free to use the code in this file however you want,
// EXCEPT PARTS THAT HAVE A SPECIFIED COPYRIGHT AND LICENSE. Those are not fully my work,
// and their licenses must be respected.
// Credits to Me (Akosmo) or Oscillody are very appreciated though.

shader_type canvas_item;

// This shader creates spin and zoom blur effects.

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;

uniform bool zoom_mode = false;

uniform mediump float blur_strength : hint_range(0.0, 1.0, 0.05) = 0.0;

vec2 rotate(highp vec2 uv, highp float angle) {
	highp mat2 rotation_matrix = mat2(
		vec2(cos(angle), -sin(angle)),
		vec2(sin(angle), cos(angle))
		);

	uv -= 0.5;
	uv *= rotation_matrix;
	uv += 0.5;
	return uv;
}

void fragment() {
	highp vec2 uv = SCREEN_UV;
	highp vec3 output_color = vec3(0.0); // Must be initialized for some reason
	if (zoom_mode) {
		// Range, original at 1.0 (from 0 to 1). This represents final texel coords range.
		mediump float scale = 1.0 - 2.0 * (blur_strength * 0.1);
		lowp float offset = blur_strength * 0.1; // For easier understanding

		// Adding textures at different scales and averaging later. We first change the range of UV,
		// then offset it to the minimum of new range. Example: if uv becomes (0.1 to 0.9), offset = 0.1.
		// the textures at higher scales have lesser weight (getting closer to 0.0).
		// This operation is very expensive, so samples (32.0) is kept at a low amount.
		for (lowp float i = 0.0; i <= 32.0; i++) {
			highp float scale_pct = i / 32.0;
			highp float lerp_scale = mix(1.0, scale, scale_pct);
			highp float lerp_offset = mix(0.0, offset, scale_pct);
			highp float weight = 1.0 - scale_pct;
			output_color += texture(SCREEN_TEXTURE, uv * lerp_scale + lerp_offset).rgb * weight;
		}

		output_color = output_color / 32.0 * 2.0;
	}
	else {
		// Adding textures at different rotations and averaging later. We first offset the UV to change the
		// pivot of rotation, multiply it by the rotation matrix, then undo the offset.
		// We sample the texture twice to have them rotating both directions.
		// This operation is very expensive, so samples (32.0) is kept at a low amount.
		for (lowp float i = 0.0; i <= 32.0; i++) {
			highp float rot_pct = i / 32.0;
			highp float lerp_rot = mix(0.0, blur_strength * 0.1, rot_pct);
			highp float weight = 1.0 - rot_pct;

			output_color += texture(SCREEN_TEXTURE, rotate(uv, lerp_rot)).rgb * weight;
			output_color += texture(SCREEN_TEXTURE, rotate(uv, lerp_rot / -1.0)).rgb * weight;
		}

		output_color = output_color / 64.0 * 2.0;
	}

	COLOR = vec4(output_color, 1.0);
}
