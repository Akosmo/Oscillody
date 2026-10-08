// This file (blend_modes.gdshaderinc) is not under the GPL.
// It is not licensed nor copyrighted to me.
// I can't claim this code. You're free to use the code in this file however you want,
// EXCEPT PARTS THAT HAVE A SPECIFIED COPYRIGHT AND LICENSE. Those are not fully my work,
// and their licenses must be respected.

// All formulas taken from: https://en.wikipedia.org/wiki/Blend_modes

// Private.

float _blend_mode_overlay_channel(float p_base, float p_blend) {
	return p_base < 0.5 ? 2.0 * p_base * p_blend : 1.0 - 2.0 * (1.0 - p_base) * (1.0 - p_blend);
}

float _divide_channel(float p_numerator, float p_denominator) {
	if (p_denominator < 0.0001) {
		return 0.0;
	}
	return min(p_numerator / p_denominator, 1.0);
}

// Public.

vec3 blend_mode_multiply(vec3 p_base, vec3 p_blend) {
	return p_base * p_blend;
}

vec3 blend_mode_screen(vec3 p_base, vec3 p_blend) {
	return 1.0 - (1.0 - p_base) * (1.0 - p_blend);
}

vec3 blend_mode_overlay(vec3 p_base, vec3 p_blend) {
	vec3 ret = vec3(0.0);
	ret.r = _blend_mode_overlay_channel(p_base.r, p_blend.r);
	ret.g = _blend_mode_overlay_channel(p_base.g, p_blend.g);
	ret.b = _blend_mode_overlay_channel(p_base.b, p_blend.b);
	return ret;
}

// https://www.pegtop.net/delphi/articles/blendmodes/softlight.htm
vec3 blend_mode_soft_light(vec3 p_base, vec3 p_blend) {
	return clamp((1.0 - 2.0 * p_blend) * pow(p_base, vec3(2.0)) + 2.0 * p_base * p_blend, 0.0, 1.0);
}

vec3 blend_mode_color_dodge(vec3 p_base, vec3 p_blend) {
	vec3 ret = vec3(0.0);
	ret.r = _divide_channel(p_base.r, 1.0 - p_blend.r);
	ret.g = _divide_channel(p_base.g, 1.0 - p_blend.g);
	ret.b = _divide_channel(p_base.b, 1.0 - p_blend.b);
	return ret;
}

vec3 blend_mode_linear_dodge(vec3 p_base, vec3 p_blend) {
	return min(p_base + p_blend, 1.0);
}

vec3 blend_mode_color_burn(vec3 p_base, vec3 p_blend) {
	vec3 ret = vec3(0.0);
	ret.r = 1.0 - _divide_channel(1.0 - p_base.r, p_blend.r);
	ret.g = 1.0 - _divide_channel(1.0 - p_base.g, p_blend.g);
	ret.b = 1.0 - _divide_channel(1.0 - p_base.b, p_blend.b);
	return ret;
}

vec3 blend_mode_linear_burn(vec3 p_base, vec3 p_blend) {
	return p_base + p_blend - 1.0;
}

vec3 blend_mode_simple_divide(vec3 p_base, vec3 p_blend) {
	vec3 ret = vec3(0.0);
	ret.r = _divide_channel(p_base.r, p_blend.r);
	ret.g = _divide_channel(p_base.g, p_blend.g);
	ret.b = _divide_channel(p_base.b, p_blend.b);
	return ret;
}

vec3 blend_mode_simple_subtract(vec3 p_base, vec3 p_blend) {
	return max(p_base - p_blend, vec3(0.0));
}

vec3 blend_mode_simple_difference(vec3 p_base, vec3 p_blend) {
	return abs(p_base - p_blend);
}

vec3 get_blend(int p_blend_mode, vec3 p_base, vec3 p_blend) {
	if (p_blend_mode == 1) {
		return blend_mode_multiply(p_base, p_blend);
	} else if (p_blend_mode == 2) {
		return blend_mode_screen(p_base, p_blend);
	} else if (p_blend_mode == 3) {
		return blend_mode_overlay(p_base, p_blend);
	} else if (p_blend_mode == 4) {
		return blend_mode_soft_light(p_base, p_blend);
	} else if (p_blend_mode == 5) {
		return blend_mode_color_dodge(p_base, p_blend);
	} else if (p_blend_mode == 6) {
		return blend_mode_linear_dodge(p_base, p_blend);
	} else if (p_blend_mode == 7) {
		return blend_mode_color_burn(p_base, p_blend);
	} else if (p_blend_mode == 8) {
		return blend_mode_linear_burn(p_base, p_blend);
	} else if (p_blend_mode == 9) {
		return blend_mode_simple_divide(p_base, p_blend);
	} else if (p_blend_mode == 10) {
		return blend_mode_simple_subtract(p_base, p_blend);
	} else if (p_blend_mode == 11) {
		return blend_mode_simple_difference(p_base, p_blend);
	} else {
		return p_blend;
	}
}
