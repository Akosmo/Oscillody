// This file (blur.gdshader) is not under the GPL.
// It is not, and should not be licensed, neither copyrightable.
// I can't claim this code. You're free to use the code in this file however you want,
// EXCEPT PARTS THAT HAVE A SPECIFIED COPYRIGHT AND LICENSE. Those are not fully my work,
// and their licenses must be respected.
// Credits to Me (Akosmo) or Oscillody are very appreciated though.

shader_type canvas_item;

// This shader is used for blurring.

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform mediump float blur_strength : hint_range(0.0, 5.0, 1.0) = 0.0;

void fragment() {
	// Blurring using LoD.
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV, blur_strength);
}
