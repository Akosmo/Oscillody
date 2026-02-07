// This file (tape_distortion.gdshader) is not under the GPL.
// It is not, and should not be licensed, neither copyrightable.
// I can't claim this code. You're free to use the code in this file however you want,
// EXCEPT PARTS THAT HAVE A SPECIFIED COPYRIGHT AND LICENSE. Those are not fully my work,
// and their licenses must be respected.
// Credits to Me (Akosmo) or Oscillody are very appreciated though.

shader_type canvas_item;

// This shader creates a tape distortion effect.

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;

uniform mediump float wave_strength : hint_range(0.0, 0.5, 0.01) = 0.0;
uniform mediump float wave_speed : hint_range(0.0, 2.0, 0.1) = 0.5;
uniform lowp float wave_freq : hint_range(2.0, 6.0, 0.5) = 2.0;
uniform lowp int wave_thickness : hint_range(10, 100, 5) = 25;
uniform highp float block_strength : hint_range(0.0, 0.05, 0.001) = 0.0;
uniform mediump float block_speed : hint_range(0.0, 4.0, 0.1) = 1.0;
uniform lowp float block_freq : hint_range(1.0, 8.0, 0.5) = 4.0;

// Hash function from https://www.shadertoy.com/view/MdcfDj
// This hash function is dedicated to the public domain under the Unlicense.
// See [http://unlicense.org/] for more details.
float hash(in highp vec2 seed) {
	highp uvec2 a = uvec2(seed + TIME * block_speed);
	highp uint m1 = 1597334677U;
	highp uint m2 = 3812015801U;

	a *= uvec2(m1, m2);
	highp uint b = (a.x ^ a.y) * m1;

	return float(b) * (1.0/float(0xffffffffU)) * 2.0 - 1.0;
}

// Wave distortion by JT: https://www.shadertoy.com/view/ltSSWV under CC0.
vec2 wave_distortion(highp vec2 uv) {
	highp float wave = pow(0.5 - 0.5 * cos(wave_freq * PI * uv.y), float(wave_thickness)) * sin(wave_freq * PI * uv.y);
	uv.x += wave * wave_strength;
	return uv;
}

void fragment() {
	highp vec2 uv = SCREEN_UV;
	uv.x += hash(vec2(uv.y) * block_freq) * block_strength;
	uv = wave_distortion(uv + vec2(0.0, fract(TIME * wave_speed))) - vec2(0.0, fract(TIME * wave_speed));

	highp vec4 screen_tex = texture(SCREEN_TEXTURE, uv);

	COLOR = vec4(screen_tex);
}
