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

#include "res://Scripts/Shaders/Includes/blend_modes.gdshaderinc"

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

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
uniform lowp int pulse_mode : hint_enum("Multiplication", "Division", "Addition", "Subtraction") = 0;

uniform highp float speed = 0.0;
uniform lowp int blend_mode : hint_enum(
	"Normal",
	"Multiply",
	"Screen",
	"Overlay",
	"Soft-Light",
	"Color Dodge",
	"Linear Dodge",
	"Color Burn",
	"Linear Burn",
	"Simple Divide",
	"Simple Subtract",
	"Simple Difference"
) = 0;

// Random math based on a circle SDF.
float circle_sdf(highp float p_distance, lowp int p_iteration, highp vec2 p_uv) {
	float iteration = float(p_iteration);
	
	if (fractional_uv) {
		p_uv = fract(p_uv * uv_scale) - 0.5;
	}
	else {
		p_uv = cos(sin(p_uv * uv_scale)) - 0.5;
	}

	p_distance = (length(p_uv) - pow(iteration * iterator_factor, length(p_uv))) * length(p_uv);

	if (pulse_mode == 0) {
		p_distance *= abs(sin(speed)) * cos(iteration);
	}
	else if (pulse_mode == 1) {
		p_distance /= abs(sin(speed)) * cos(iteration);
	}
	else if (pulse_mode == 2) {
		p_distance += abs(sin(speed)) * cos(iteration);
	}
	else if (pulse_mode == 3) {
		p_distance -= abs(sin(speed)) * cos(iteration);
	}

	p_distance = (sin(p_distance * iteration - (speed * pulse_duration))) / iteration;

	highp float alt_distance;
	alt_distance = abs(p_distance);
	p_distance = step(abs(sin(speed * iteration * pulse_oscillation)) * pulse_thickness, alt_distance);
	return p_distance = 1.0 - p_distance;
}

void fragment() {
	highp vec2 uv = UV * 2.0 - 1.0;
	if (split) {
		highp float temp_uv_x = uv.x;
		uv.x *= cos(uv.y);
		uv.y *= sin(temp_uv_x);
	}
	uv.x *= 16.0 / 9.0; // Adjust ratio.

	highp float dist = 0.0;
	for (lowp int i = 0; i < iterations; i++) {
		dist = circle_sdf(dist, i, uv);
	}

	highp vec4 output_color = vec4(mix(background_color, pulse_color, vec4(dist)));

	vec3 base_layer = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	COLOR = vec4(get_blend(blend_mode, base_layer, output_color.rgb), output_color.a);
}
