// This small file (grain.gdshader) is not under the GPL.
// It is not, and should not be licensed, neither copyrightable.
// I can't claim this code. You're free to use the code in this file however you want,
// EXCEPT PARTS THAT HAVE A SPECIFIED COPYRIGHT AND LICENSE. Those are not fully my work,
// and their licenses must be respected.

shader_type canvas_item;

// This shader creates noise and adds to the visualizer with the soft light blend mode.

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float opacity : hint_range(0.0, 1.0) = 0.0;

// Machine-dependent, but should be fine in this case.
float random(in vec2 uv) {
	return fract(sin(dot(uv.xy + fract(TIME), vec2(12.9898, 78.233))) * 43758.5453123);
}

// The Soft Light functions below are under the MIT (especifically Expat) License.
// Source: https://github.com/jamieowen/glsl-blend
// Copyright (C) 2015 Jamie Owen

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

float soft_light_float(in float base, in float blend) {
	return (blend < 0.5) ? (2.0 * base * blend + base * base * (1.0 - 2.0 * blend)) : (sqrt(base) * (2.0 * blend - 1.0) + 2.0 * base * (1.0 - blend));
}

vec3 soft_light_vec3(in vec3 base, in vec3 blend) {
	return vec3(soft_light_float(base.r, blend.r), soft_light_float(base.g, blend.g), soft_light_float(base.b, blend.b));
}

vec3 soft_light_opa(vec3 base, vec3 blend, float _opacity) {
	return (soft_light_vec3(base, blend) * _opacity + base * (1.0 - _opacity));
}

// End of the Soft Light functions.

void fragment() {
	vec2 uv = SCREEN_UV;
	uv.y = 1.0 - uv.y;
	vec4 screen_tex = texture(SCREEN_TEXTURE, SCREEN_UV);

	vec3 noise = vec3(random(uv));

	vec3 output_color = soft_light_opa(screen_tex.rgb, noise, opacity);

	COLOR = vec4(vec3(output_color), 1.0);
}
