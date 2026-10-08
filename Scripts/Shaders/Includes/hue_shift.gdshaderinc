// This file (hue_shift.gdshaderinc) is not under the GPL.
// It is not, and should not be licensed, neither copyrightable.
// I can't claim this code. You're free to use the code in this file however you want,
// EXCEPT PARTS THAT HAVE A SPECIFIED COPYRIGHT AND LICENSE. Those are not fully my work,
// and their licenses must be respected.

// Using the FCC YIQ color space to rotate hue independent of grayscale.
// Read: https://en.wikipedia.org/wiki/YIQ
vec3 to_yiq(highp vec3 p_color) {
	highp mat3 to_yiq_conversion_matrix = mat3(
		vec3(0.30, 0.59, 0.11),
		vec3(0.599, -0.2773, -0.3217),
		vec3(0.213, -0.5251, 0.3121)
		);

	return p_color * to_yiq_conversion_matrix;
}

vec3 to_rgb(highp vec3 p_color) {
	highp mat3 to_rgb_conversion_matrix = mat3(
		vec3(1.0, 0.9496, 0.6236),
		vec3(1.0, -0.2748, -0.6357),
		vec3(1.0, -1.1, 1.7)
		);

	return p_color * to_rgb_conversion_matrix;
}

// Rotating hue.
vec3 hue_shift_yiq(highp vec3 p_color, mediump float p_hue_shift) {
	highp vec3 color_in_yiq = to_yiq(p_color);

	mediump mat2 rotation_matrix = mat2(
		vec2(cos(p_hue_shift), -sin(p_hue_shift)),
		vec2(sin(p_hue_shift), cos(p_hue_shift))
		);

	color_in_yiq.yz *= rotation_matrix;

	return to_rgb(color_in_yiq);
}