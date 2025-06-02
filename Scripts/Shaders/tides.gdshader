// Oscillody
// Copyright (C) 2025 Akosmo

// This file (tides.gdshader) is under the MIT (especifically Expat) License.
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

// This shader creates a wavy background without using noise.

uniform mediump vec4 wave_color : source_color = vec4(1.0);
uniform mediump vec4 tint : source_color = vec4(vec3(0.0), 1.0);
uniform bool color_mix = false;
uniform bool invert_colors = false;
uniform mediump float hue_shift_amt : hint_range(-3.14, 3.14, 0.01) = 0.0;
uniform lowp int iterations : hint_range(1, 6, 1) = 6;
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

void fragment() {
	highp vec2 uv = UV;
	uv.y = 1.0 - uv.y; // Invert Y coord
	uv.x *= 16.0 / 9.0; // Adjust ratio
	
	// Distorting UV.
	for (lowp int i = 1; i <= iterations; i++) {
		uv.x += cos(speed + uv.y * (float(i) * 0.8));
		uv.y += cos(speed - uv.x * (float(i) * 0.8));
	}
	
	highp vec3 output_color = vec3(0.0);
	
	if (!color_mix) {
		output_color = sin(uv.x - uv.y) * wave_color.rgb + tint.rgb;
	}
	else {
		output_color.r = sin(uv.x - uv.y) * wave_color.r + tint.r;
		output_color.g = cos(uv.x - uv.y) * wave_color.g + tint.g;
		output_color.b = sin(uv.y - uv.x) * wave_color.b + tint.b;
	}
	
	if (invert_colors) {
		output_color = vec3(1.0) - output_color;
	}
	
	if (abs(hue_shift_amt) > 0.0) {
		output_color = hue_shift_yiq(output_color);
	}
	
	COLOR = vec4(output_color, 1.0);
}
