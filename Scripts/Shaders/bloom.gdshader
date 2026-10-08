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

uniform lowp int blur_mode : hint_range(0, 2, 1) = 2;

// w0, w1, w2, and w3 are the four cubic B-spline basis functions
float w0(float a) {
	return (1.0f / 6.0f) * (a * (a * (-a + 3.0f) - 3.0f) + 1.0f);
}

float w1(float a) {
	return (1.0f / 6.0f) * (a * a * (3.0f * a - 6.0f) + 4.0f);
}

float w2(float a) {
	return (1.0f / 6.0f) * (a * (a * (-3.0f * a + 3.0f) + 3.0f) + 1.0f);
}

float w3(float a) {
	return (1.0f / 6.0f) * (a * a * a);
}

// g0 and g1 are the two amplitude functions
float g0(float a) {
	return w0(a) + w1(a);
}

float g1(float a) {
	return w2(a) + w3(a);
}

// h0 and h1 are the two offset functions
float h0(float a) {
	return -1.0f + w1(a) / (w0(a) + w1(a));
}

float h1(float a) {
	return 1.0f + w3(a) / (w2(a) + w3(a));
}

vec4 texture_2d_bicubic(sampler2D p_texture, vec2 p_uv, vec2 p_size, int p_lod) {
	float lod = float(p_lod);
	vec2 texture_size = vec2(float(int(p_size.x) >> p_lod), float(int(p_size.y) >> p_lod));
	vec2 pixel_size = vec2(1.0) / texture_size;
	
	p_uv = p_uv * texture_size + vec2(0.5);
	
	vec2 iuv = floor(p_uv);
	vec2 fuv = fract(p_uv);

	float g0x = g0(fuv.x);
	float g1x = g1(fuv.x);
	float h0x = h0(fuv.x);
	float h1x = h1(fuv.x);
	float h0y = h0(fuv.y);
	float h1y = h1(fuv.y);

	vec2 p0 = (vec2(iuv.x + h0x, iuv.y + h0y) - vec2(0.5f)) * pixel_size;
	vec2 p1 = (vec2(iuv.x + h1x, iuv.y + h0y) - vec2(0.5f)) * pixel_size;
	vec2 p2 = (vec2(iuv.x + h0x, iuv.y + h1y) - vec2(0.5f)) * pixel_size;
	vec2 p3 = (vec2(iuv.x + h1x, iuv.y + h1y) - vec2(0.5f)) * pixel_size;
	
	return (g0(fuv.y) * (g0x * textureLod(p_texture, p0, lod) + g1x * textureLod(p_texture, p1, lod))) +
			(g1(fuv.y) * (g0x * textureLod(p_texture, p2, lod) + g1x * textureLod(p_texture, p3, lod)));
}

vec3 gather_glow_levels(sampler2D p_texture, vec2 p_uv, vec2 p_size) {
	vec3 glow = vec3(0.0);
	glow += texture_2d_bicubic(p_texture, p_uv, p_size, 0).rgb + 1.0;
	glow += texture_2d_bicubic(p_texture, p_uv, p_size, 1).rgb + 0.8;
	glow += texture_2d_bicubic(p_texture, p_uv, p_size, 2).rgb + 0.6;
	glow += texture_2d_bicubic(p_texture, p_uv, p_size, 3).rgb + 0.4;
	glow += texture_2d_bicubic(p_texture, p_uv, p_size, 4).rgb + 0.2;
	glow += texture_2d_bicubic(p_texture, p_uv, p_size, 5).rgb + 0.1;
	
	return glow;
}

vec3 apply_glow(vec3 p_color, vec3 p_glow) {
	if (blend_mode == 0) { // Linear Dodge.
		return p_color + p_glow;
	} else { // Screen.
		p_glow = clamp(p_glow, 0.0, 1.0);
		return p_color + p_glow - p_color * p_glow;
	}
}

void fragment() {
	if (blur_mode == 0) {
		vec3 screen_texture = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
		vec3 screen_texture_blurred = texture(SCREEN_TEXTURE, SCREEN_UV, radius).rgb * opacity;
		if (blend_mode == 0) { // Linear Dodge.
			COLOR = vec4(screen_texture + screen_texture_blurred, 1.0);
		} else { // Screen.
			COLOR = vec4(1.0 - (1.0 - screen_texture) * (1.0 - screen_texture_blurred), 1.0);
		}
	} else if (blur_mode == 1) {
		vec2 uv = SCREEN_UV;
		vec4 color_1 = textureLod(SCREEN_TEXTURE, uv, 0.0);
		//vec3 screen_texture = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
		
		vec3 glow = gather_glow_levels(SCREEN_TEXTURE, uv, FRAGCOORD.xy) * 0.8;
		glow = mix(glow, vec3(0.0), 0.8);
		color_1.rgb = apply_glow(color_1.rgb, glow * opacity * 0.5);
		COLOR = color_1;
		//
		//uv = SCREEN_UV * 0.5;
		//
		//vec2 half_pixel = SCREEN_PIXEL_SIZE * 0.5;
		//
		//vec3 color_2 = color_1.rgb * uv * 4.0;
		//color_2 += textureLod(SCREEN_TEXTURE, SCREEN_UV - half_pixel, 0.0).rgb;
		//color_2 += textureLod(SCREEN_TEXTURE, SCREEN_UV + half_pixel, 0.0).rgb;
		//color_2 += textureLod(SCREEN_TEXTURE, SCREEN_UV - vec2(half_pixel.x, -half_pixel.y), 0.0).rgb;
		//color_2 += textureLod(SCREEN_TEXTURE, SCREEN_UV + vec2(half_pixel.x, -half_pixel.y), 0.0).rgb;
		//color_2 /= 8.0;
		//float max_value = max(color_2.r, max(color_2.g, color_2.b));
		//float feedback = max(max_value, opacity);
		//output_color = min(output_color * feedback, vec3(12.0));
		//if (blend_mode == 0) { // Linear Dodge.
			//COLOR = vec4(screen_texture + output_color, 1.0);
		//} else { // Screen.
			//COLOR = vec4(1.0 - (1.0 - screen_texture) * (1.0 - output_color), 1.0);
		//}
	} else if (blur_mode == 2) {
		//highp vec2 uv = UV;
		//uv.y = 1.0 - uv.y; // Invert Y coord
		//uv.x *= 16.0 / 9.0; // Adjust ratio
		
		vec3 screen_texture = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
		vec3 screen_texture_blurred = vec3(0.0);
		screen_texture_blurred += texture(SCREEN_TEXTURE, SCREEN_UV, 0.0 * radius).rgb * 1.0;
		screen_texture_blurred += texture(SCREEN_TEXTURE, SCREEN_UV, 1.0 * radius).rgb * 0.8;
		screen_texture_blurred += texture(SCREEN_TEXTURE, SCREEN_UV, 2.0 * radius).rgb * 0.6;
		screen_texture_blurred += texture(SCREEN_TEXTURE, SCREEN_UV, 3.0 * radius).rgb * 0.4;
		screen_texture_blurred += texture(SCREEN_TEXTURE, SCREEN_UV, 4.0 * radius).rgb * 0.2;
		screen_texture_blurred += texture(SCREEN_TEXTURE, SCREEN_UV, 5.0 * radius).rgb * 0.1;
		//for (lowp int i = 0; i <= int(radius); i++) {
			//screen_texture_blurred += texture(SCREEN_TEXTURE, SCREEN_UV, 1.0 / float(i)).rgb;
		//}
		//screen_texture_blurred /= vec3(radius);
		screen_texture_blurred *= opacity;
		if (blend_mode == 0) { // Linear Dodge.
			COLOR = vec4(screen_texture + screen_texture_blurred, 1.0);
		} else { // Screen.
			COLOR = vec4(1.0 - (1.0 - screen_texture) * (1.0 - screen_texture_blurred), 1.0);
		}
	}
}
