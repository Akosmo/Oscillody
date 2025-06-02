// Oscillody
// Copyright (C) 2025 Akosmo

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

uniform mediump vec4 main_color : source_color = vec4(1.0);
uniform mediump vec4 background_color : source_color = vec4(vec3(0.0), 1.0);

uniform bool param_20 = false; // UV fract
uniform bool change_origin = false;

uniform lowp int iterations : hint_range(2, 16, 1) = 8;
uniform mediump float param_1 : hint_range(0.5, 8.0, 0.5) = 1.0; // UV scale
uniform mediump float param_2 : hint_range(0.5, 8.0, 0.5) = 1.0; // Vector scale 1
uniform mediump float param_3 : hint_range(0.5, 8.0, 0.5) = 1.0; // Iterator factor 1
uniform mediump float param_4 : hint_range(0.1, 4.0, 0.1) = 1.0; // UV length factor
uniform mediump float param_5 : hint_range(0.5, 8.0, 0.5) = 1.0; // Vector scale 2
uniform mediump float param_6 : hint_range(0.5, 8.0, 0.5) = 1.0; // Iterator factor 2
uniform mediump float param_7 : hint_range(0.01, 16.0, 0.01) = 1.0; // Time scale
uniform mediump float param_8 : hint_range(0.5, 1.0, 0.1) = 1.0; // Iterator factor 3
uniform mediump float param_9 : hint_range(0.5, 1.0, 0.1) = 1.0; // (Dist) scale
uniform mediump float param_10 : hint_range(0.01, 2.0, 0.01) = 0.1; // Pulse frequency
uniform mediump float param_11 : hint_range(0.01, 0.1, 0.01) = 0.1; // Line thickness
uniform lowp float param_12 : hint_range(0.5, 20.0, 0.5) = 1.0; // Iterator factor 4
uniform lowp int param_21 : hint_range(0, 2, 1) = 0; // Assignment mode 1
uniform lowp int param_22 : hint_range(0, 2, 1) = 0; // Thickness variation
uniform lowp int param_23 : hint_range(0, 3, 1) = 0; // Assignment mode 2
uniform bool param_24 = false; // Thin lines
uniform bool param_25 = false; // Assignment mode 3
uniform bool param_26 = false; // Assignment mode 4
uniform bool param_27 = false; // (Dist) fract
uniform highp float speed = 0.0;

// Random math based on a circle SDF.
float circle_sdf(highp float dist, lowp int i, highp vec2 uv) {
	if (param_20) {
		uv = fract(uv * param_1) - 0.5;
	}
	else {
		uv = cos(sin(uv * param_1)) - 0.5;
	}

	if (param_22 == 0) {
		dist = length(uv * param_2) - pow(float(i) * param_3, length(uv) * param_4);
	}
	else if (param_22 == 1) {
		dist += length(uv * param_2) - pow(float(i) * param_3, length(uv) * param_4);
	}
	else if (param_22 == 2) {
		dist -= length(uv * param_2) - pow(float(i) * param_3, length(uv) * param_4);
	}

	if (param_21 == 0) {
		dist *= length(uv * param_5);
	}
	else if (param_21 == 1) {
		dist += length(uv * param_5);
	}
	else if (param_21 == 2) {
		dist -= length(uv * param_5);
	}

	if (param_23 == 0) {
		dist *= abs(sin(speed)) * cos(float(i) * param_12);
	}
	else if (param_23 == 1) {
		dist /= abs(sin(speed)) * cos(float(i) * param_12);
	}
	else if (param_23 == 2) {
		dist += abs(sin(speed)) * cos(float(i) * param_12);
	}
	else if (param_23 == 3) {
		dist -= abs(sin(speed)) * cos(float(i) * param_12);
	}

	if (param_25) {
		dist *= sin(dist * float(i) * param_6 - (speed * param_7));
	}
	else {
		dist = sin(dist * float(i) * param_6 - (speed * param_7));
	}

	if (param_24) {
		 dist *= float(i) * param_8;
	}
	else {
		dist /= float(i) * param_8;
	}

	highp float alt_dist;
	if (param_27) {
		alt_dist = fract(dist);
	}
	else {
		alt_dist = abs(dist);
	}

	if (param_26) {
		alt_dist += alt_dist * param_9;
	}
	else {
		alt_dist = alt_dist * param_9;
	}

	dist = step(abs(sin(speed * float(i) * param_10)) * param_11, alt_dist);
	return dist = 1.0 - dist;
}

void fragment() {
	highp vec2 uv = UV * 2.0 - 1.0;
	if (change_origin) {
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

	COLOR = vec4(mix(background_color.rgb, main_color.rgb, output_color), 1.0);
}
