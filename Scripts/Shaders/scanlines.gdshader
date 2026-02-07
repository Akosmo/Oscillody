// This file (scanlines.gdshader) is not under the GPL.
// It is not, and should not be licensed, neither copyrightable.
// I can't claim this code. You're free to use the code in this file however you want,
// EXCEPT PARTS THAT HAVE A SPECIFIED COPYRIGHT AND LICENSE. Those are not fully my work,
// and their licenses must be respected.
// Credits to Me (Akosmo) or Oscillody are very appreciated though.

shader_type canvas_item;

// This shader creates a scanline overlay.

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;

uniform mediump float darkness : hint_range(0.0, 1.0, 0.05) = 0.0;
uniform lowp float amount_of_lines : hint_range(200.0, 800.0, 10.0) = 400.0;
uniform bool interlaced_scan = false;
uniform highp float speed = 0.0;

void fragment() {
	highp vec2 uv = SCREEN_UV;
	if (interlaced_scan) {
		uv.x -= sin(uv.y * 1024.0 + speed) * 0.001;
	}

	highp vec4 screen_tex = texture(SCREEN_TEXTURE, uv);

	highp float scanlines = abs(sin(uv.y * amount_of_lines + speed) * darkness);

	COLOR = vec4(mix(screen_tex.rgb, vec3(0.0), scanlines), 1.0);
}
