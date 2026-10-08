// This file (grain.gdshader) is not under the GPL.
// It is not, and should not be licensed, neither copyrightable.
// I can't claim this code. You're free to use the code in this file however you want,
// EXCEPT PARTS THAT HAVE A SPECIFIED COPYRIGHT AND LICENSE. Those are not fully my work,
// and their licenses must be respected.
// Credits to Me (Akosmo) or Oscillody are very appreciated though.

shader_type canvas_item;

// This shader creates noise and adds to the visualizer with the soft light blend mode.

#include "res://Scripts/Shaders/Includes/blend_modes.gdshaderinc"

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;

uniform mediump float opacity : hint_range(0.0, 1.0, 0.05) = 0.0;
uniform lowp int blend_mode : hint_enum("Normal", "Soft-Light") = 1;
uniform bool static = false;
uniform bool blur = true;

// Hash function from https://www.shadertoy.com/view/MdcfDj
// This hash function is dedicated to the public domain under the Unlicense.
// See [http://unlicense.org/] for more details.
float hash(in highp vec2 p_seed) {
	if (!static) {
		p_seed += fract(TIME) * 8192.0;
	}
	
	highp uvec2 a = uvec2(p_seed);
	highp uint m1 = 1597334677U;
	highp uint m2 = 3812015801U;

	a *= uvec2(m1, m2);
	highp uint b = (a.x ^ a.y) * m1;

	return float(b) * (1.0/float(0xffffffffU));
}

// Value Noise function. Cheaper than gradient, but produces blocky patterns.
// Watch: https://www.youtube.com/watch?v=DxUY42r_6Cg
float value_noise(in mediump vec2 p_uv) {
	// UV is scaled down when calling this function (and it's already modified when calling `fbm()`),
	// since it's being passed multiplied by `frequency_factor`.
	// This looks like the original UV map becomes repeated and form a grid, where
	// each integer part is where the UV repeats, and the fractional part is each UV map.
	// Read: https://thebookofshaders.com/10/
	mediump vec2 integer_part = floor(p_uv);
	highp vec2 fractional_part = fract(p_uv);

	// Assigning pseudo-random values to vertices that will compose the final lattice.
	// This works in GPU because the same seed will return the same value, that's why
	// a single vertex will have the same value attached to it.
	highp float vert_00 = hash(integer_part);
	highp float vert_10 = hash(integer_part + vec2(1.0, 0.0));
	highp float vert_01 = hash(integer_part + vec2(0.0, 1.0));
	highp float vert_11 = hash(integer_part + vec2(1.0, 1.0));

	// Using Hermite interpolation (smoothstep) to get the weight for linear interpolation.
	// Since fractional part is already between 0.0 and 1.0, we only perform the last part of the process.
	// Read: https://registry.khronos.org/OpenGL-Refpages/gl4/html/smoothstep.xhtml
	// Read: https://thebookofshaders.com/11/
	highp vec2 weight = pow(fractional_part, vec2(2.0)) * (3.0 - 2.0 * fractional_part);

	// Bilinear interpolation, with a "smoothstep'd" weight.
	// This is basically blurring the grid.
	highp float x1 = mix(vert_00, vert_10, weight.x);
	highp float x2 = mix(vert_01, vert_11, weight.x);
	return mix(x1, x2, weight.y);
}

void fragment() {
	highp vec2 uv = UV;
	uv.y = 1.0 - uv.y; // Invert `Y` coord.
	uv.x *= 16.0 / 9.0; // Adjust ratio.
	
	highp vec4 screen_tex = texture(SCREEN_TEXTURE, SCREEN_UV);

	highp vec3 noise = vec3(0.0);
	if (blur) {
		noise = vec3(value_noise(FRAGCOORD.xy));
	} else {
		noise = vec3(hash(FRAGCOORD.xy));
	}

	if (blend_mode == 0) {
		COLOR = vec4(noise, opacity);
	} else {
		COLOR = vec4(blend_mode_soft_light(screen_tex.rgb, noise), opacity);
	}
}
