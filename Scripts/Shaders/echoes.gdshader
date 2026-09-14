// Oscillody
// Copyright (C) 2025-present Akosmo

// This file (echoes.gdshader) is under the MIT (especifically Expat) License.
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

// This shader creates a warping background based on a circle SDF.

uniform mediump vec4 pulse_color : source_color = vec4(1.0);
uniform mediump vec4 background_color : source_color = vec4(vec3(0.0), 1.0);
uniform lowp int iterations : hint_range(2, 16, 1) = 8;
uniform mediump float uv_scale : hint_range(0.5, 8.0, 0.5) = 1.0;
uniform bool fractional_uv = false;
uniform bool split = false;
uniform mediump float iterator_factor : hint_range(0.5, 8.0, 0.5) = 1.0;
uniform mediump float pulse_duration : hint_range(0.01, 16.0, 0.01) = 1.0;
uniform mediump float pulse_oscillation : hint_range(0.01, 2.0, 0.01) = 0.1;
uniform mediump float pulse_thickness : hint_range(0.01, 0.1, 0.01) = 0.1;
uniform lowp int pulse_mode : hint_range(0, 3, 1) = 0;
uniform highp float speed = 0.0;

// Random math based on a circle SDF.
float circle_sdf(highp float dist, lowp int i, highp vec2 uv) {
	if (fractional_uv) {
		uv = fract(uv * uv_scale) - 0.5;
	}
	else {
		uv = cos(sin(uv * uv_scale)) - 0.5;
	}

	dist = (length(uv) - pow(float(i) * iterator_factor, length(uv))) * length(uv);

	if (pulse_mode == 0) {
		dist *= abs(sin(speed)) * cos(float(i));
	}
	else if (pulse_mode == 1) {
		dist /= abs(sin(speed)) * cos(float(i));
	}
	else if (pulse_mode == 2) {
		dist += abs(sin(speed)) * cos(float(i));
	}
	else if (pulse_mode == 3) {
		dist -= abs(sin(speed)) * cos(float(i));
	}

	dist = (sin(dist * float(i) - (speed * pulse_duration))) / float(i);

	highp float alt_dist;
	alt_dist = abs(dist);
	dist = step(abs(sin(speed * float(i) * pulse_oscillation)) * pulse_thickness, alt_dist);
	return dist = 1.0 - dist;
}

void fragment() {
	highp vec2 uv = UV * 2.0 - 1.0;
	if (split) {
		highp float temp_uv_x = uv.x;
		uv.x *= cos(uv.y);
		uv.y *= sin(temp_uv_x);
	}
	uv.x *= 16.0 / 9.0; // Adjust ratio

	highp float dist = 0.0;
	for (lowp int i = 0; i < iterations; i++) {
		dist = circle_sdf(dist, i, uv);
	}

	highp vec3 output_color = vec3(dist);

	COLOR = vec4(mix(background_color.rgb, pulse_color.rgb, output_color), 1.0);
}
