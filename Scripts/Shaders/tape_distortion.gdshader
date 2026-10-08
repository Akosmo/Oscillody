// This file (tape_distortion.gdshader) is not under the GPL.
// It is not, and should not be licensed, neither copyrightable.
// I can't claim this code. You're free to use the code in this file however you want,
// EXCEPT PARTS THAT HAVE A SPECIFIED COPYRIGHT AND LICENSE. Those are not fully my work,
// and their licenses must be respected.
// Credits to Me (Akosmo) or Oscillody are very appreciated though.

shader_type canvas_item;

// This shader creates a tape distortion effect.

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;

uniform mediump float wave_offset_amount : hint_range(0.0, 0.5, 0.01) = 0.0;
uniform lowp float wave_amount : hint_range(2.0, 6.0, 0.5) = 2.0;
uniform lowp int wave_thickness : hint_range(10, 100, 5) = 20;
uniform mediump float wave_speed = 0.0;
uniform highp float block_offset_amount : hint_range(0.0, 0.05, 0.01) = 0.0;
uniform lowp float block_amount : hint_range(1.0, 8.0, 0.5) = 4.0;
uniform mediump float block_speed = 0.0;

// Hash function from https://www.shadertoy.com/view/MdcfDj
// This hash function is dedicated to the public domain under the Unlicense.
// See [http://unlicense.org/] for more details.
float hash(in highp vec2 p_seed) {
	highp uvec2 a = uvec2(p_seed + block_speed);
	highp uint m1 = 1597334677U;
	highp uint m2 = 3812015801U;

	a *= uvec2(m1, m2);
	highp uint b = (a.x ^ a.y) * m1;

	return float(b) * (1.0/float(0xffffffffU)) * 2.0 - 1.0;
}

// Wave distortion by JT: https://www.shadertoy.com/view/ltSSWV under CC0.
vec2 wave_distortion(highp vec2 p_uv) {
	highp float wave = pow(0.5 - 0.5 * cos(wave_amount * PI * p_uv.y), float(wave_thickness)) * sin(wave_amount * PI * p_uv.y);
	p_uv.x += wave * wave_offset_amount;
	return p_uv;
}

void fragment() {
	highp vec2 uv = SCREEN_UV;
	uv.x += hash(vec2(uv.y) * block_amount) * block_offset_amount;
	uv = wave_distortion(uv + vec2(0.0, fract(wave_speed))) - vec2(0.0, fract(wave_speed));

	highp vec4 screen_tex = texture(SCREEN_TEXTURE, uv);

	COLOR = vec4(screen_tex);
}
