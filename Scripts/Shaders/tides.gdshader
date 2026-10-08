// Oscillody
// Copyright (C) 2025-present Akosmo

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

#include "res://Scripts/Shaders/Includes/hue_shift.gdshaderinc"
#include "res://Scripts/Shaders/Includes/blend_modes.gdshaderinc"

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform mediump vec4 wave_color : source_color = vec4(1.0);
uniform mediump vec4 tint : source_color = vec4(vec3(0.0), 1.0);
uniform bool color_mix = false;
uniform bool invert_colors = false;
uniform mediump float hue_shift : hint_range(-3.14, 3.14, 0.01) = 0.0;
uniform lowp int iterations : hint_range(1, 6, 1) = 6;

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

void fragment() {
	highp vec2 uv = UV;
	uv.y = 1.0 - uv.y; // Invert `Y` coord.
	uv.x *= 16.0 / 9.0; // Adjust ratio.

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

	if (abs(hue_shift) > 0.0) {
		output_color = hue_shift_yiq(output_color, hue_shift);
	}

	vec3 base_layer = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	COLOR = vec4(get_blend(blend_mode, base_layer, output_color), wave_color.a);
}
