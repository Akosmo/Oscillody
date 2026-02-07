// Oscillody
// Copyright (C) 2025-present Akosmo

// This file (domain_warping.gdshader) is under the MIT (especifically Expat) License.
// "Software" in the license text refers to this single script only.

// Permission is hereby granted, free of charge,
// to any person obtaining a copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

shader_type canvas_item;

// This shader creates a domain warping background using fBm.

uniform mediump vec4 noise_color : source_color = vec4(1.0);
uniform bool color_mix = false;
uniform bool invert_colors = false;
uniform mediump float hue_shift_amt : hint_range(-3.14, 3.14, 0.01) = 0.0;
uniform lowp int octaves : hint_range(1, 10) = 6; // Amount of noise layers
uniform mediump float frequency_factor : hint_range(0.5, 6.0, 0.5) = 2.0;
uniform mediump float amplitude : hint_range(0.1, 1.0, 0.05) = 0.5;
uniform mediump float frequency_increment : hint_range(1.0, 4.0, 0.5) = 2.0;
uniform mediump float amplitude_decrement : hint_range(0.1, 1.0, 0.05) = 0.5;
uniform highp float speed = 0.0;

// Using the FCC YIQ color space to rotate hue independent of grayscale.
// Read: https://en.wikipedia.org/wiki/YIQ
vec3 to_yiq(highp vec3 col) {
	highp mat3 to_yiq_conversion_matrix = mat3(
		vec3(0.30, 0.59, 0.11),
		vec3(0.599, -0.2773, -0.3217),
		vec3(0.213, -0.5251, 0.3121)
		);

	return col * to_yiq_conversion_matrix;
}

vec3 to_rgb(highp vec3 col) {
	highp mat3 to_rgb_conversion_matrix = mat3(
		vec3(1.0, 0.9496, 0.6236),
		vec3(1.0, -0.2748, -0.6357),
		vec3(1.0, -1.1, 1.7)
		);

	return col * to_rgb_conversion_matrix;
}

// Rotating hue.
vec3 hue_shift_yiq(highp vec3 col) {
	highp vec3 color_in_yiq = to_yiq(col);

	mediump mat2 rotation_matrix = mat2(
		vec2(cos(hue_shift_amt), -sin(hue_shift_amt)),
		vec2(sin(hue_shift_amt), cos(hue_shift_amt))
		);

	color_in_yiq.yz *= rotation_matrix;

	return to_rgb(color_in_yiq);
}

// Hash function from https://www.shadertoy.com/view/MdcfDj
// This hash function is dedicated to the public domain under the Unlicense.
// See [http://unlicense.org/] for more details.
float hash(in highp vec2 seed) {
	highp uvec2 a = uvec2(seed);
	highp uint m1 = 1597334677U;
	highp uint m2 = 3812015801U;

	a *= uvec2(m1, m2);
	highp uint b = (a.x ^ a.y) * m1;

	return float(b) * (1.0/float(0xffffffffU));
}

// Value Noise function. Cheaper than gradient, but produces blocky patterns.
// Watch: https://www.youtube.com/watch?v=DxUY42r_6Cg
float value_noise(in mediump vec2 uv) {
	// UV is scaled down when calling this function (and it's already modified when calling fbm()),
	// since it's being passed multiplied by frequency_factor.
	// This looks like the original UV map becomes repeated and form a grid, where
	// each integer part is where the UV repeats, and the fractional part is each UV map.
	// Read: https://thebookofshaders.com/10/
	mediump vec2 integer_part = floor(uv);
	highp vec2 fractional_part = fract(uv);

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

// Fractional Brownian Motion: fractal, pseudo-random noise.
// Read: https://en.wikipedia.org/wiki/Fractional_Brownian_motion
// Read: https://thebookofshaders.com/13/
float fbm(in highp vec2 uv) {
	highp float waves = 0.0;
	mediump float _amplitude = amplitude;

	for (lowp int i = 0; i < octaves; i++) {
		// Following the equation y = A * sin(x * w) where A is amplitude and w is frequency
		waves += _amplitude * value_noise(uv * frequency_factor); // uv is frequency
		uv *= frequency_increment;
		_amplitude *= amplitude_decrement;
	}
	return waves;
}

// Where Domain Warping happens.
void fragment() {
	highp vec2 uv = UV;
	uv.y = 1.0 - uv.y; // Invert Y coord
	uv.x *= 16.0 / 9.0; // Adjust ratio

	//fBm's that are going to warp the base noise.
	highp vec2 warper1 = vec2(0.0);
	warper1.x = fbm(uv + 2.4); // Random numbers
	warper1.y = fbm(uv * 0.842);

	highp vec2 warper2 = vec2(0.0);
	warper2.x = fbm(uv + warper1) + speed;
	warper2.y = fbm(uv + warper1 * 1.48) + speed;

	highp vec3 output_color = vec3(0.0);

	if (!color_mix) {
		output_color = vec3(fbm(uv + warper2) * noise_color.rgb);
	}
	else {
		output_color.r = fbm(uv + warper2 * 0.82) * noise_color.r;
		output_color.g = fbm(uv + warper2 * 1.32) * noise_color.g;
		output_color.b = fbm(uv + warper2) * noise_color.b;
	}

	if (invert_colors) {
		output_color = vec3(1.0) - output_color;
	}

	if (abs(hue_shift_amt) > 0.0) {
		output_color = hue_shift_yiq(output_color);
	}

	COLOR = vec4(output_color, 1.0);
}
