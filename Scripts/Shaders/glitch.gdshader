// This file (glitch.gdshader) is not under the GPL.
// It is not, and should not be licensed, neither copyrightable.
// I can't claim this code. You're free to use the code in this file however you want,
// EXCEPT PARTS THAT HAVE A SPECIFIED COPYRIGHT AND LICENSE. Those are not fully my work,
// and their licenses must be respected.
// Credits to Me (Akosmo) or Oscillody are very appreciated though.

shader_type canvas_item;

// This shader creates a glitch effect.

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;

uniform highp float block_offset_amount : hint_range(0.0, 0.02, 0.001) = 0.0;
uniform highp float pixel_offset_amount : hint_range(0.0, 0.02, 0.001) = 0.0;
uniform lowp float speed_factor : hint_range(0.0, 50.0, 1.0) = 100.0;

// Hash function from https://www.shadertoy.com/view/MdcfDj
// This hash function is dedicated to the public domain under the Unlicense.
// See [http://unlicense.org/] for more details.
float hash(in highp vec2 seed) {
	highp uvec2 a = uvec2(seed + TIME * speed_factor);
	highp uint m1 = 1597334677U;
	highp uint m2 = 3812015801U;

	a *= uvec2(m1, m2);
	highp uint b = (a.x ^ a.y) * m1;

	return float(b) * (1.0/float(0xffffffffU));
}

void fragment() {
	highp vec2 uv = SCREEN_UV;

	// Return value changes depending on UV.
	highp float block_offset = hash(vec2(1.0, abs(sin(uv.y) * 20.0)));
	highp float pixel_offset = hash(vec2(1.0, uv.y * sin(uv.y * 1000.0) * 1000.0));

	highp float offset = block_offset * block_offset_amount - pixel_offset * pixel_offset_amount;

	highp vec4 screen_tex = vec4(0.0);
	screen_tex.r = texture(SCREEN_TEXTURE, vec2(uv.x + offset, uv.y)).r;
	screen_tex.g = texture(SCREEN_TEXTURE, vec2(uv.x, uv.y + offset)).g;
	screen_tex.b = texture(SCREEN_TEXTURE, vec2(uv.x - offset, uv.y)).b;
	screen_tex.a = texture(SCREEN_TEXTURE, uv).a;

	COLOR = screen_tex;
}
