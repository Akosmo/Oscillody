// This small file (chromatic_aberration.gdshader) is not under the GPL.
// It is not, and should not be licensed, neither copyrightable.
// I can't claim this code. You're free to use the code in this file however you want,
// EXCEPT PARTS THAT HAVE A SPECIFIED COPYRIGHT AND LICENSE. Those are not fully my work,
// and their licenses must be respected.

shader_type canvas_item;

// This shader is used as a chromatic aberration post-processing effect.

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float strength : hint_range(0.0, 0.01) = 0.0;

void fragment() {
	COLOR.r = texture(SCREEN_TEXTURE, vec2(SCREEN_UV.x + strength, SCREEN_UV.y)).r;
	COLOR.g = texture(SCREEN_TEXTURE, SCREEN_UV).g;
	COLOR.b = texture(SCREEN_TEXTURE, vec2(SCREEN_UV.x - strength, SCREEN_UV.y)).b;
	COLOR.a = texture(SCREEN_TEXTURE, SCREEN_UV).a;
}
