// Oscillody
// Copyright (C) 2025 Akosmo

// This file (current_flow.gdshader) is under the MIT (especifically Expat) License.
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

// This shader creates an almost wavy background without using noise.

uniform mediump vec4 main_color : source_color = vec4(1.0);
uniform mediump vec4 background_color : source_color = vec4(vec3(0.0), 1.0);
uniform bool filled = false;
uniform mediump float uv_scale : hint_range(1.0, 10.0, 0.1) = 5.0;
uniform lowp float iterations : hint_range(4.0, 14.0, 1.0) = 10.0;
uniform mediump float wave_thickness : hint_range(0.01, 0.5, 0.01) = 0.05;
uniform highp float speed = 0.0;

vec2 waves(highp vec2 uv) {
	// Manipulating UV to create cool patterns.
	uv *= uv_scale;
	for (lowp float i = 1.0; i <= iterations; i++) {
		lowp float i2 = i * 0.75;
		mediump float wave_fact = smoothstep(0.5, 0.25, i / iterations);
		uv.x += wave_fact * cos(i2 * uv.y + speed * 0.01);
		uv.y -= wave_fact * sin(i2 * uv.x - speed * 2.0);
	}

	highp float wave = 0.0;
	if (filled) {
		wave = sin(uv.x + uv.y);
	}
	else {
		wave = abs(sin(uv.x + uv.y));
	}
	wave = step(wave, wave_thickness);

	lowp float zero_step = 0.0; // Allowing background color to not conflict with main color.
	if (abs(wave) > 0.0) {
		zero_step = 1.0;
	}

	return vec2(wave, zero_step);
}

void fragment() {
	highp vec2 uv = UV;
	uv.y = 1.0 - uv.y; // Invert Y coord
	uv.x *= 16.0 / 9.0; // Adjust ratio

	highp vec3 output_color = vec3(waves(uv).x * main_color.rgb);

	if (output_color.r * waves(uv).y < 0.0001 && output_color.g * waves(uv).y < 0.0001 && output_color.b * waves(uv).y < 0.0001) {
		output_color = background_color.rgb;
	}

	COLOR = vec4(vec3(output_color), 1.0);
}
