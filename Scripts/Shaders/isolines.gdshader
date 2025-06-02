// Oscillody
// Copyright (C) 2025 Akosmo

// This file (isolines.gdshader) is under the MIT (especifically Expat) License.
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

// This shader creates a background with isolines.

uniform mediump vec4 line_color : source_color = vec4(1.0);
uniform mediump vec4 background_color : source_color = vec4(vec3(0.0), 1.0);
uniform bool filled = false;
uniform lowp float line_thickness : hint_range(1.0, 20.0, 1.0) = 10.0;
uniform mediump float thickness_variation : hint_range(0.5, 1.10, 0.01) = 0.5;
uniform lowp float line_amount : hint_range(1.0, 50.0, 1.0) = 10.0;
uniform mediump float uv_scale : hint_range(1.0, 10.0, 0.5) = 5.0;
uniform highp float speed = 0.0;

// Random gradient function from https://github.com/SuboptimalEng/shader-tutorials
// This hash function is under the MIT (especifically Expat) License.
// Copyright (c) 2022 Suboptimal Engineer

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

// Values slighly changed from original.
vec2 random_gradient(highp vec2 seed) {
	highp float x = dot(seed, vec2(742.0, 328.0)); // Random values
	highp float y = dot(seed, vec2(138.0, 947.0));
	highp vec2 gradient = sin(vec2(x, y));
	gradient *= 3831.4389;
	return sin(gradient + speed);
}

// Perlin Noise, better than value noise for smooth isolines.
// Watch: https://www.youtube.com/watch?v=DxUY42r_6Cg
// Watch: https://www.youtube.com/watch?v=7fd331zsie0
float perlin_noise(in highp vec2 uv) {
	// UV is scaled down when calling this function.
	// This looks like the original UV map becomes repeated and form a grid, where
	// each integer part is where the UV repeats, and the fractional part is each UV map.
	// Read: https://thebookofshaders.com/10/
	mediump vec2 integer_part = floor(uv);
	highp vec2 fractional_part = fract(uv);
	
	// Assigning pseudo-random gradients to vertices that will compose the final lattice
	// (this works in GPU because the same seed will return the same value, that's why
	// a single vertex will have the same gradient attached to it),
	// then getting the dot product of the random gradient and another one in the lattice.
	highp float vert_00 = dot(random_gradient(integer_part), vec2(0.0, 0.0) - fractional_part);
	highp float vert_10 = dot(random_gradient(integer_part + vec2(1.0, 0.0)), vec2(1.0, 0.0) - fractional_part);
	highp float vert_01 = dot(random_gradient(integer_part + vec2(0.0, 1.0)), vec2(0.0, 1.0) - fractional_part);
	highp float vert_11 = dot(random_gradient(integer_part + vec2(1.0, 1.0)), vec2(1.0, 1.0) - fractional_part);
	
	// Using quintic interpolation to get the weight for linear interpolation.
	highp vec2 weight = pow(fractional_part, vec2(3.0)) * (10.0 + fractional_part * (-15.0 + 6.0 * fractional_part));
	
	// Bilinear interpolation, with a quintic-interpolated weight.
	// This is basically blurring the grid.
	highp float x1 = mix(vert_00, vert_10, weight.x);
	highp float x2 = mix(vert_01, vert_11, weight.x);
	return mix(x1, x2, weight.y) * 0.7 + 0.5; // Balancing
}

void fragment() {
	highp vec2 uv = UV;
	uv.y = 1.0 - uv.y; // Invert Y coord
	uv.x *= 16.0 / 9.0; // Adjust ratio
	
	highp float noise = perlin_noise(uv * uv_scale);
	
	highp vec3 output_color = vec3(0.0);
	if (filled) {
		output_color = step(noise, vec3(0.5));
	}
	else {
		// Formula used in different isoline and grid shaders.
		// I'm not skilled enough in math to explain fwidth() well.
		// AFAIK, fwidth() is the sum of absolutes of x and y partial derivatives. It can be used to show
		// where there's greater value change in the argument passed to it.
		// What the formula does is computing anti-aliased screen-space grid lines... except it's not a grid,
		// since noise is passed as an argument instead of UV.
		// fract(number_of_lines * noise) is what creates something resembling isolines,
		// by multiplying the noise and using fract() on it, so every time a value goes above 1.0,
		// it returns to 0.0 and ramps up again.
		// thickness_variation is used to darken the result, and we get the absolute to get a more "rounded" result.
		highp float noise_weight = abs(fract(line_amount * noise) - thickness_variation) / fwidth(noise);
		output_color = vec3(smoothstep(line_thickness, 0.0, noise_weight));
	}
	
	COLOR = vec4(mix(background_color.rgb, line_color.rgb, output_color), 1.0);
}
