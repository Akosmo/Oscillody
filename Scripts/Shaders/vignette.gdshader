// This file (vignette.gdshader) is not under the GPL.
// It is not, and should not be licensed, neither copyrightable.
// I can't claim this code. You're free to use the code in this file however you want,
// EXCEPT PARTS THAT HAVE A SPECIFIED COPYRIGHT AND LICENSE. Those are not fully my work,
// and their licenses must be respected.
// Credits to Me (Akosmo) or Oscillody are very appreciated though.

shader_type canvas_item;

// This shader creates a vignette effect.

uniform highp vec4 vignette_color : source_color = vec4(vec3(0.0), 1.0);
uniform mediump float vignette_size : hint_range(0.0, 2.0, 0.05) = 0.0;
uniform lowp float vignette_sharpness : hint_range(0.0, 20.0, 1.0) = 12.0;

void fragment() {
    highp vec2 uv = SCREEN_UV;

	// 0 - 0.5 - 1 -> 1 - 0.75 - 1 ; the smaller the difference, the rounder the vignette.
    uv = 1.0 - (1.0 - uv) * uv;
    highp float vignette_mono = clamp(uv.x * uv.y * vignette_size, 0.0, 1.0);
    vignette_mono = pow(vignette_mono, vignette_sharpness);
    highp vec4 vignette = vec4(vignette_mono * vignette_color);

    COLOR = vignette;
}