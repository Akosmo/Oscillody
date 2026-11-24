// Oscillody
// Copyright (C) 2025-present Akosmo

// This file (bloom.gdshader) is under the MIT (especifically Expat) License.
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

// This shader is used for a bloom effect.

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform mediump float opacity : hint_range(0.0, 1.0, 0.1) = 0.0;
uniform mediump float radius : hint_range(0.0, 6.0, 0.1) = 1.0;
uniform lowp int blend_mode : hint_enum("Normal", "Soft-Light") = 0;

void fragment() {
	vec3 screen_texture = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	vec3 screen_texture_blurred = vec3(0.0);
	screen_texture_blurred += texture(SCREEN_TEXTURE, SCREEN_UV, 0.0 * radius).rgb * 1.0;
	screen_texture_blurred += texture(SCREEN_TEXTURE, SCREEN_UV, 1.0 * radius).rgb * 0.8;
	screen_texture_blurred += texture(SCREEN_TEXTURE, SCREEN_UV, 2.0 * radius).rgb * 0.6;
	screen_texture_blurred += texture(SCREEN_TEXTURE, SCREEN_UV, 3.0 * radius).rgb * 0.4;
	screen_texture_blurred += texture(SCREEN_TEXTURE, SCREEN_UV, 4.0 * radius).rgb * 0.2;
	screen_texture_blurred += texture(SCREEN_TEXTURE, SCREEN_UV, 5.0 * radius).rgb * 0.1;
	screen_texture_blurred *= opacity;
	if (blend_mode == 0) { // Linear Dodge.
		COLOR = vec4(screen_texture + screen_texture_blurred, 1.0);
	} else { // Screen.
		COLOR = vec4(1.0 - (1.0 - screen_texture) * (1.0 - screen_texture_blurred), 1.0);
	}
}
