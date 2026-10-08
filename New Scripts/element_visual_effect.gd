# Oscillody
# Copyright (C) 2025-present Akosmo

# element_visual_effect.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ElementVisualEffect
extends ElementReactive

# NOTE: Gradient Overlay not needed if Elements have blending mode options.
enum VisualEffectType {
	BLOOM,
	CHROMATIC_ABERRATION,
	GLITCH,
	GRAIN,
	LENS_DISTORTION,
	SCANLINES,
	SPIN_ZOOM_BLUR,
	TAPE_DISTORTION,
	VIGNETTE
}

enum BloomBlendMode {
	LINEAR_DODGE,
	SCREEN
}

enum GrainBlendMode {
	NORMAL,
	SOFT_LIGHT
}

enum SpinZoomBlurMode {
	SPIN,
	ZOOM
}

enum VignetteShape {
	ELLIPSE,
	RECTANGLE
}

enum VignetteFalloffFunction {
	LINEAR,
	EXPONENTIAL
}

const VISUAL_EFFECT_TYPES: Array[StringName] = [
	&"(Visual_Effect)_Bloom",
	&"(Visual_Effect)_Chromatic_Aberration",
	&"(Visual_Effect)_Glitch",
	&"(Visual_Effect)_Grain",
	&"(Visual_Effect)_Lens_Distortion",
	&"(Visual_Effect)_Scanlines",
	&"(Visual_Effect)_Spin/Zoom_Blur",
	&"(Visual_Effect)_Tape_Distortion",
	&"(Visual_Effect)_Vignette"
]

const BLOOM_BLEND_MODES: Array[StringName] = [
	&"(Bloom)_Linear_Dodge",
	&"(Bloom)_Screen"
]

const GRAIN_BLEND_MODES: Array[StringName] = [
	&"(Grain)_Normal",
	&"(Grain)_Soft_Light"
]

const SPIN_ZOOM_BLUR_MODES: Array[StringName] = [
	&"(Spin_Zoom_Blur)_Spin",
	&"(Spin_Zoom_Blur)_Zoom"
]

const VIGNETTE_SHAPES: Array[StringName] = [
	&"(Vignette)_Ellipse",
	&"(Vignette)_Rectangle"
]

const VIGNETTE_FALLOFF_FUNCTIONS: Array[StringName] = [
	&"(Vignette)_Linear",
	&"(Vignette)_Exponential"
]

const SN_VISUAL_EFFECT_TYPE: StringName = &"Visual_Effect_Type"

const SN_BLOOM_OPACITY: StringName = &"(Bloom)_Opacity"
const SN_BLOOM_RADIUS: StringName = &"(Bloom)_Radius"
const SN_BLOOM_BLEND_MODE: StringName = &"(Bloom)_Blend_Mode"

const SN_CHROMATIC_ABERRATION_AMOUNT: StringName = &"(Chromatic_Aberration)_Amount"

const SN_GLITCH_BLOCK_OFFSET_AMOUNT: StringName = &"(Glitch)_Block_Offset_Amount"
const SN_GLITCH_BLOCK_SPEED: StringName = &"(Glitch)_Block_Speed"
const SN_GLITCH_LINE_OFFSET_AMOUNT: StringName = &"(Glitch)_Line_Offset_Amount"
const SN_GLITCH_LINE_SPEED: StringName = &"(Glitch)_Line_Speed"

const SN_GRAIN_OPACITY: StringName = &"(Grain)_Opacity"
const SN_GRAIN_BLEND_MODE: StringName = &"(Grain)_Blend_Mode"
const SN_GRAIN_STATIC: StringName = &"(Grain)_Static"
const SN_GRAIN_BLUR: StringName = &"(Grain)_Blur"

const SN_LENS_DISTORTION_AMOUNT: StringName = &"(Lens_Distortion)_Amount"
const SN_LENS_DISTORTION_ZOOM_FACTOR: StringName = &"(Lens_Distortion)_Zoom_Factor"
const SN_LENS_DISTORTION_BORDER: StringName = &"(Lens_Distortion)_Border"
const SN_LENS_DISTORTION_BORDER_COLOR: StringName = &"(Lens_Distortion)_Border_Color"
const SN_LENS_DISTORTION_CHROMATIC_ABERRATION_AMOUNT: StringName = \
&"(Lens_Distortion)_Chromatic_Aberration_Amount"

const SN_SCANLINES_OPACITY: StringName = &"(Scanlines)_Opacity"
const SN_SCANLINES_INTERLACED_SCAN: StringName = &"(Scanlines)_Interlaced_Scan"
const SN_SCANLINES_SCALE: StringName = &"(Scanlines)_Scale"
const SN_SCANLINES_SPEED: StringName = &"(Scanlines)_Speed"

const SN_SPIN_ZOOM_BLUR_AMOUNT: StringName = &"(Spin_Zoom_Blur)_Amount"
const SN_SPIN_ZOOM_BLUR_MODE: StringName = &"(Spin_Zoom_Blur)_Mode"

const SN_TAPE_DISTORTION_WAVE_OFFSET_AMOUNT: StringName = &"(Tape_Distortion)_Wave_Offset_Amount"
const SN_TAPE_DISTORTION_WAVE_AMOUNT: StringName = &"(Tape_Distortion)_Wave_Amount"
const SN_TAPE_DISTORTION_WAVE_THICKNESS: StringName = &"(Tape_Distortion)_Wave_Thickness"
const SN_TAPE_DISTORTION_WAVE_SPEED: StringName = &"(Tape_Distortion)_Wave_Speed"
const SN_TAPE_DISTORTION_BLOCK_OFFSET_AMOUNT: StringName = &"(Tape_Distortion)_Block_Offset_Amount"
const SN_TAPE_DISTORTION_BLOCK_AMOUNT: StringName = &"(Tape_Distortion)_Block_Amount"
const SN_TAPE_DISTORTION_BLOCK_SPEED: StringName = &"(Tape_Distortion)_Block_Speed"

const SN_VIGNETTE_SIZE: StringName = &"(Vignette)_Size"
const SN_VIGNETTE_COLOR: StringName = &"(Vignette)_Color"
const SN_VIGNETTE_SHARPNESS: StringName = &"(Vignette)_Sharpness"
const SN_VIGNETTE_CURVE: StringName = &"(Vignette)_Curve"
const SN_VIGNETTE_SHAPE: StringName = &"(Vignette)_Shape"
const SN_VIGNETTE_FALLOFF_FUNCTION: StringName = &"(Vignette)_Falloff_Function"

const SN_BLOOM_OPACITY_REACTION: StringName = &"(Bloom)_Opacity_Reaction"
const SN_CHROMATIC_ABERRATION_AMOUNT_REACTION: StringName = &"(Chromatic_Aberration)_Amount_Reaction"
const SN_GLITCH_BLOCK_OFFSET_AMOUNT_REACTION: StringName = &"(Glitch)_Block_Offset_Amount_Reaction"
const SN_GLITCH_BLOCK_SPEED_REACTION: StringName = &"(Glitch)_Block_Speed_Reaction"
const SN_GLITCH_LINE_OFFSET_AMOUNT_REACTION: StringName = &"(Glitch)_Line_Offset_Amount_Reaction"
const SN_GLITCH_LINE_SPEED_REACTION: StringName = &"(Glitch)_Line_Speed_Reaction"
const SN_LENS_DISTORTION_AMOUNT_REACTION: StringName = &"(Lens_Distortion)_Amount_Reaction"
const SN_LENS_DISTORTION_ZOOM_FACTOR_REACTION: StringName = &"(Lens_Distortion)_Zoom_Factor_Reaction"
const SN_SCANLINES_SPEED_REACTION: StringName = &"(Scanlines)_Speed_Reaction"
const SN_SPIN_ZOOM_BLUR_AMOUNT_REACTION: StringName = &"(Spin_Zoom_Blur)_Amount_Reaction"
const SN_VIGNETTE_SIZE_REACTION: StringName = &"(Vignette)_Size_Reaction"

var _visual_effect_type: VisualEffectType = VisualEffectType.BLOOM

var _bloom_opacity: float = 0.0
var _bloom_radius: float = 1.0
var _bloom_blend_mode: BloomBlendMode = BloomBlendMode.LINEAR_DODGE

var _chromatic_aberration_amount: float = 0.0

var _glitch_block_offset_amount: float = 0.0
var _glitch_block_speed: float = 0.2
var _glitch_line_offset_amount: float = 0.0
var _glitch_line_speed: float = 0.2

var _grain_opacity: float = 0.0
var _grain_blend_mode: GrainBlendMode = GrainBlendMode.SOFT_LIGHT
var _grain_static: bool = false
var _grain_blur: bool = true

var _lens_distortion_amount: float = 0.0
var _lens_distortion_zoom_factor: float = 1.0
var _lens_distortion_border: bool = true
var _lens_distortion_border_color: Color = Color.BLACK
var _lens_distortion_chromatic_aberration_amount: float = 0.0

var _scanlines_opacity: float = 0.0
var _scanlines_interlaced_scan: bool = false # TODO: Make this a float?
var _scanlines_scale: float = 0.2
var _scanlines_speed: float = 0.2

var _spin_zoom_blur_amount: float = 0.0
var _spin_zoom_blur_mode: SpinZoomBlurMode = SpinZoomBlurMode.SPIN

# TODO: Add reaction to Tape Distortion properties, once fixed.
var _tape_distortion_wave_offset_amount: float = 0.0
var _tape_distortion_wave_amount: float = 0.2
var _tape_distortion_wave_thickness: float = 0.2
var _tape_distortion_wave_speed: float = 0.2
var _tape_distortion_block_offset_amount: float = 0.0
var _tape_distortion_block_amount: float = 0.4
var _tape_distortion_block_speed: float = 0.2

var _vignette_size: float = 0.0
var _vignette_color: Color = Color.BLACK
var _vignette_sharpness: float = 0.05
var _vignette_curve: float = 0.05
var _vignette_shape: VignetteShape = VignetteShape.ELLIPSE
var _vignette_falloff_function: VignetteFalloffFunction = VignetteFalloffFunction.LINEAR

var _bloom_opacity_reaction: float = 0.0
var _chromatic_aberration_amount_reaction: float = 0.0
var _glitch_block_offset_amount_reaction: float = 0.0
var _glitch_block_speed_reaction: float = 0.0
var _glitch_line_offset_amount_reaction: float = 0.0
var _glitch_line_speed_reaction: float = 0.0
var _lens_distortion_amount_reaction: float = 0.0
var _lens_distortion_zoom_factor_reaction: float = 0.0
var _scanlines_speed_reaction: float = 0.0
var _spin_zoom_blur_amount_reaction: float = 0.0
var _vignette_size_reaction: float = 0.0

func set_visual_effect_type(p_value: VisualEffectType) -> void:
	_visual_effect_type = p_value
	property_changed.emit(SN_VISUAL_EFFECT_TYPE)

func get_visual_effect_type() -> VisualEffectType:
	return _visual_effect_type

func set_bloom_opacity(p_value: float) -> void:
	_bloom_opacity = p_value
	property_changed.emit(SN_BLOOM_OPACITY)

func get_bloom_opacity() -> float:
	return _bloom_opacity

func set_bloom_radius(p_value: float) -> void:
	_bloom_radius = p_value
	property_changed.emit(SN_BLOOM_RADIUS)

func get_bloom_radius() -> float:
	return _bloom_radius

func set_bloom_blend_mode(p_value: BloomBlendMode) -> void:
	_bloom_blend_mode = p_value
	property_changed.emit(SN_BLOOM_BLEND_MODE)

func get_bloom_blend_mode() -> BloomBlendMode:
	return _bloom_blend_mode

func set_chromatic_aberration_amount(p_value: float) -> void:
	_chromatic_aberration_amount = p_value
	property_changed.emit(SN_CHROMATIC_ABERRATION_AMOUNT)

func get_chromatic_aberration_amount() -> float:
	return _chromatic_aberration_amount

func set_glitch_block_offset_amount(p_value: float) -> void:
	_glitch_block_offset_amount = p_value
	property_changed.emit(SN_GLITCH_BLOCK_OFFSET_AMOUNT)

func get_glitch_block_offset_amount() -> float:
	return _glitch_block_offset_amount

func set_glitch_block_speed(p_value: float) -> void:
	_glitch_block_speed = p_value
	property_changed.emit(SN_GLITCH_BLOCK_SPEED)

func get_glitch_block_speed() -> float:
	return _glitch_block_speed

func set_glitch_line_offset_amount(p_value: float) -> void:
	_glitch_line_offset_amount = p_value
	property_changed.emit(SN_GLITCH_LINE_OFFSET_AMOUNT)

func get_glitch_line_offset_amount() -> float:
	return _glitch_line_offset_amount

func set_glitch_line_speed(p_value: float) -> void:
	_glitch_line_speed = p_value
	property_changed.emit(SN_GLITCH_LINE_SPEED)

func get_glitch_line_speed() -> float:
	return _glitch_line_speed

func set_grain_opacity(p_value: float) -> void:
	_grain_opacity = p_value
	property_changed.emit(SN_GRAIN_OPACITY)

func get_grain_opacity() -> float:
	return _grain_opacity

func set_grain_blend_mode(p_value: GrainBlendMode) -> void:
	_grain_blend_mode = p_value
	property_changed.emit(SN_GRAIN_BLEND_MODE)

func get_grain_blend_mode() -> GrainBlendMode:
	return _grain_blend_mode

func set_grain_static(p_value: bool) -> void:
	_grain_static = p_value
	property_changed.emit(SN_GRAIN_STATIC)

func get_grain_static() -> bool:
	return _grain_static

func set_grain_blur(p_value: bool) -> void:
	_grain_blur = p_value
	property_changed.emit(SN_GRAIN_BLUR)

func get_grain_blur() -> bool:
	return _grain_blur

func set_lens_distortion_amount(p_value: float) -> void:
	_lens_distortion_amount = p_value
	property_changed.emit(SN_LENS_DISTORTION_AMOUNT)

func get_lens_distortion_amount() -> float:
	return _lens_distortion_amount

func set_lens_distortion_zoom_factor(p_value: float) -> void:
	_lens_distortion_zoom_factor = p_value
	property_changed.emit(SN_LENS_DISTORTION_ZOOM_FACTOR)

func get_lens_distortion_zoom_factor() -> float:
	return _lens_distortion_zoom_factor

func set_lens_distortion_border(p_value: bool) -> void:
	_lens_distortion_border = p_value
	property_changed.emit(SN_LENS_DISTORTION_BORDER)

func get_lens_distortion_border() -> bool:
	return _lens_distortion_border

func set_lens_distortion_border_color(p_value: Color) -> void:
	_lens_distortion_border_color = p_value
	property_changed.emit(SN_LENS_DISTORTION_BORDER_COLOR)

func get_lens_distortion_border_color() -> Color:
	return _lens_distortion_border_color

func set_lens_distortion_chromatic_aberration_amount(p_value: float) -> void:
	_lens_distortion_chromatic_aberration_amount = p_value
	property_changed.emit(SN_LENS_DISTORTION_CHROMATIC_ABERRATION_AMOUNT)

func get_lens_distortion_chromatic_aberration_amount() -> float:
	return _lens_distortion_chromatic_aberration_amount

func set_scanlines_opacity(p_value: float) -> void:
	_scanlines_opacity = p_value
	property_changed.emit(SN_SCANLINES_OPACITY)

func get_scanlines_opacity() -> float:
	return _scanlines_opacity

func set_scanlines_interlaced_scan(p_value: bool) -> void:
	_scanlines_interlaced_scan = p_value
	property_changed.emit(SN_SCANLINES_INTERLACED_SCAN)

func get_scanlines_interlaced_scan() -> bool:
	return _scanlines_interlaced_scan

func set_scanlines_scale(p_value: float) -> void:
	_scanlines_scale = p_value
	property_changed.emit(SN_SCANLINES_SCALE)

func get_scanlines_scale() -> float:
	return _scanlines_scale

func set_scanlines_speed(p_value: float) -> void:
	_scanlines_speed = p_value
	property_changed.emit(SN_SCANLINES_SPEED)

func get_scanlines_speed() -> float:
	return _scanlines_speed

func set_spin_zoom_blur_amount(p_value: float) -> void:
	_spin_zoom_blur_amount = p_value
	property_changed.emit(SN_SPIN_ZOOM_BLUR_AMOUNT)

func get_spin_zoom_blur_amount() -> float:
	return _spin_zoom_blur_amount

func set_spin_zoom_blur_mode(p_value: SpinZoomBlurMode) -> void:
	_spin_zoom_blur_mode = p_value
	property_changed.emit(SN_SPIN_ZOOM_BLUR_MODE)

func get_spin_zoom_blur_mode() -> SpinZoomBlurMode:
	return _spin_zoom_blur_mode

func set_tape_distortion_wave_offset_amount(p_value: float) -> void:
	_tape_distortion_wave_offset_amount = p_value
	property_changed.emit(SN_TAPE_DISTORTION_WAVE_OFFSET_AMOUNT)

func get_tape_distortion_wave_offset_amount() -> float:
	return _tape_distortion_wave_offset_amount

func set_tape_distortion_wave_amount(p_value: float) -> void:
	_tape_distortion_wave_amount = p_value
	property_changed.emit(SN_TAPE_DISTORTION_WAVE_AMOUNT)

func get_tape_distortion_wave_amount() -> float:
	return _tape_distortion_wave_amount

func set_tape_distortion_wave_thickness(p_value: float) -> void:
	_tape_distortion_wave_thickness = p_value
	property_changed.emit(SN_TAPE_DISTORTION_WAVE_THICKNESS)

func get_tape_distortion_wave_thickness() -> float:
	return _tape_distortion_wave_thickness

func set_tape_distortion_wave_speed(p_value: float) -> void:
	_tape_distortion_wave_speed = p_value
	property_changed.emit(SN_TAPE_DISTORTION_WAVE_SPEED)

func get_tape_distortion_wave_speed() -> float:
	return _tape_distortion_wave_speed

func set_tape_distortion_block_offset_amount(p_value: float) -> void:
	_tape_distortion_block_offset_amount = p_value
	property_changed.emit(SN_TAPE_DISTORTION_BLOCK_OFFSET_AMOUNT)

func get_tape_distortion_block_offset_amount() -> float:
	return _tape_distortion_block_offset_amount

func set_tape_distortion_block_amount(p_value: float) -> void:
	_tape_distortion_block_amount = p_value
	property_changed.emit(SN_TAPE_DISTORTION_BLOCK_AMOUNT)

func get_tape_distortion_block_amount() -> float:
	return _tape_distortion_block_amount

func set_tape_distortion_block_speed(p_value: float) -> void:
	_tape_distortion_block_speed = p_value
	property_changed.emit(SN_TAPE_DISTORTION_BLOCK_SPEED)

func get_tape_distortion_block_speed() -> float:
	return _tape_distortion_block_speed

func set_vignette_size(p_value: float) -> void:
	_vignette_size = p_value
	property_changed.emit(SN_VIGNETTE_SIZE)

func get_vignette_size() -> float:
	return _vignette_size

func set_vignette_color(p_value: Color) -> void:
	_vignette_color = p_value
	property_changed.emit(SN_VIGNETTE_COLOR)

func get_vignette_color() -> Color:
	return _vignette_color

func set_vignette_sharpness(p_value: float) -> void:
	_vignette_sharpness = p_value
	property_changed.emit(SN_VIGNETTE_SHARPNESS)

func get_vignette_sharpness() -> float:
	return _vignette_sharpness

func set_vignette_curve(p_value: float) -> void:
	_vignette_curve = p_value
	property_changed.emit(SN_VIGNETTE_CURVE)

func get_vignette_curve() -> float:
	return _vignette_curve

func set_vignette_shape(p_value: VignetteShape) -> void:
	_vignette_shape = p_value
	property_changed.emit(SN_VIGNETTE_SHAPE)

func get_vignette_shape() -> VignetteShape:
	return _vignette_shape

func set_vignette_falloff_function(p_value: VignetteFalloffFunction) -> void:
	_vignette_falloff_function = p_value
	property_changed.emit(SN_VIGNETTE_FALLOFF_FUNCTION)

func get_vignette_falloff_function() -> VignetteFalloffFunction:
	return _vignette_falloff_function

func set_bloom_opacity_reaction(p_value: float) -> void:
	_bloom_opacity_reaction = p_value
	property_changed.emit(SN_BLOOM_OPACITY_REACTION)

func get_bloom_opacity_reaction() -> float:
	return _bloom_opacity_reaction

func set_chromatic_aberration_amount_reaction(p_value: float) -> void:
	_chromatic_aberration_amount_reaction = p_value
	property_changed.emit(SN_CHROMATIC_ABERRATION_AMOUNT_REACTION)

func get_chromatic_aberration_amount_reaction() -> float:
	return _chromatic_aberration_amount_reaction

func set_glitch_block_offset_amount_reaction(p_value: float) -> void:
	_glitch_block_offset_amount_reaction = p_value
	property_changed.emit(SN_GLITCH_BLOCK_OFFSET_AMOUNT_REACTION)

func get_glitch_block_offset_amount_reaction() -> float:
	return _glitch_block_offset_amount_reaction

func set_glitch_block_speed_reaction(p_value: float) -> void:
	_glitch_block_speed_reaction = p_value
	property_changed.emit(SN_GLITCH_BLOCK_SPEED_REACTION)

func get_glitch_block_speed_reaction() -> float:
	return _glitch_block_speed_reaction

func set_glitch_line_offset_amount_reaction(p_value: float) -> void:
	_glitch_line_offset_amount_reaction = p_value
	property_changed.emit(SN_GLITCH_LINE_OFFSET_AMOUNT_REACTION)

func get_glitch_line_offset_amount_reaction() -> float:
	return _glitch_line_offset_amount_reaction

func set_glitch_line_speed_reaction(p_value: float) -> void:
	_glitch_line_speed_reaction = p_value
	property_changed.emit(SN_GLITCH_LINE_SPEED_REACTION)

func get_glitch_line_speed_reaction() -> float:
	return _glitch_line_speed_reaction

func set_lens_distortion_amount_reaction(p_value: float) -> void:
	_lens_distortion_amount_reaction = p_value
	property_changed.emit(SN_LENS_DISTORTION_AMOUNT_REACTION)

func get_lens_distortion_amount_reaction() -> float:
	return _lens_distortion_amount_reaction

func set_lens_distortion_zoom_factor_reaction(p_value: float) -> void:
	_lens_distortion_zoom_factor_reaction = p_value
	property_changed.emit(SN_LENS_DISTORTION_ZOOM_FACTOR_REACTION)

func get_lens_distortion_zoom_factor_reaction() -> float:
	return _lens_distortion_zoom_factor_reaction

func set_scanlines_speed_reaction(p_value: float) -> void:
	_scanlines_speed_reaction = p_value
	property_changed.emit(SN_SCANLINES_SPEED_REACTION)

func get_scanlines_speed_reaction() -> float:
	return _scanlines_speed_reaction

func set_spin_zoom_blur_amount_reaction(p_value: float) -> void:
	_spin_zoom_blur_amount_reaction = p_value
	property_changed.emit(SN_SPIN_ZOOM_BLUR_AMOUNT_REACTION)

func get_spin_zoom_blur_amount_reaction() -> float:
	return _spin_zoom_blur_amount_reaction

func set_vignette_size_reaction(p_value: float) -> void:
	_vignette_size_reaction = p_value
	property_changed.emit(SN_VIGNETTE_SIZE_REACTION)

func get_vignette_size_reaction() -> float:
	return _vignette_size_reaction

func get_properties() -> Dictionary[StringName, Variant]:
	var _property_dictionary: Dictionary[StringName, Variant] = {
		SN_ELEMENT_NAME: _element_name,
		SN_ELEMENT_TYPE: _element_type,
		SN_ELEMENT_LAYER: _element_layer,
		SN_ELEMENT_VISIBILITY: _element_visibility,
		SN_VISUAL_EFFECT_TYPE: _visual_effect_type,
		SN_BLOOM_OPACITY: _bloom_opacity,
		SN_BLOOM_RADIUS: _bloom_radius,
		SN_BLOOM_BLEND_MODE: _bloom_blend_mode,
		SN_CHROMATIC_ABERRATION_AMOUNT: _chromatic_aberration_amount,
		SN_GLITCH_BLOCK_OFFSET_AMOUNT: _glitch_block_offset_amount,
		SN_GLITCH_BLOCK_SPEED: _glitch_block_speed,
		SN_GLITCH_LINE_OFFSET_AMOUNT: _glitch_line_offset_amount,
		SN_GLITCH_LINE_SPEED: _glitch_line_speed,
		SN_GRAIN_OPACITY: _grain_opacity,
		SN_GRAIN_BLEND_MODE: _grain_blend_mode,
		SN_GRAIN_STATIC: _grain_static,
		SN_GRAIN_BLUR: _grain_blur,
		SN_LENS_DISTORTION_AMOUNT: _lens_distortion_amount,
		SN_LENS_DISTORTION_ZOOM_FACTOR: _lens_distortion_zoom_factor,
		SN_LENS_DISTORTION_BORDER: _lens_distortion_border,
		SN_LENS_DISTORTION_BORDER_COLOR: _lens_distortion_border_color,
		SN_LENS_DISTORTION_CHROMATIC_ABERRATION_AMOUNT: _lens_distortion_chromatic_aberration_amount,
		SN_SCANLINES_OPACITY: _scanlines_opacity,
		SN_SCANLINES_INTERLACED_SCAN: _scanlines_interlaced_scan,
		SN_SCANLINES_SCALE: _scanlines_scale,
		SN_SCANLINES_SPEED: _scanlines_speed,
		SN_SPIN_ZOOM_BLUR_AMOUNT: _spin_zoom_blur_amount,
		SN_SPIN_ZOOM_BLUR_MODE: _spin_zoom_blur_mode,
		SN_TAPE_DISTORTION_WAVE_OFFSET_AMOUNT: _tape_distortion_wave_offset_amount,
		SN_TAPE_DISTORTION_WAVE_AMOUNT: _tape_distortion_wave_amount,
		SN_TAPE_DISTORTION_WAVE_THICKNESS: _tape_distortion_wave_thickness,
		SN_TAPE_DISTORTION_WAVE_SPEED: _tape_distortion_wave_speed,
		SN_TAPE_DISTORTION_BLOCK_OFFSET_AMOUNT: _tape_distortion_block_offset_amount,
		SN_TAPE_DISTORTION_BLOCK_AMOUNT: _tape_distortion_block_amount,
		SN_TAPE_DISTORTION_BLOCK_SPEED: _tape_distortion_block_speed,
		SN_VIGNETTE_SIZE: _vignette_size,
		SN_VIGNETTE_COLOR: _vignette_color,
		SN_VIGNETTE_SHARPNESS: _vignette_sharpness,
		SN_VIGNETTE_CURVE: _vignette_curve,
		SN_VIGNETTE_SHAPE: _vignette_shape,
		SN_VIGNETTE_FALLOFF_FUNCTION: _vignette_falloff_function,
		SN_AUDIO_SOURCE: _audio_source,
		SN_BEGIN_FREQUENCY: _begin_frequency,
		SN_END_FREQUENCY: _end_frequency,
		SN_MINIMUM_DECIBELS: _minimum_decibels,
		SN_SMOOTHING_TYPE: _smoothing_type,
		SN_SMOOTHING_AMOUNT: _smoothing_amount,
		SN_BLOOM_OPACITY_REACTION: _bloom_opacity_reaction,
		SN_CHROMATIC_ABERRATION_AMOUNT_REACTION: _chromatic_aberration_amount_reaction,
		SN_GLITCH_BLOCK_OFFSET_AMOUNT_REACTION: _glitch_block_offset_amount_reaction,
		SN_GLITCH_BLOCK_SPEED_REACTION: _glitch_block_speed_reaction,
		SN_GLITCH_LINE_OFFSET_AMOUNT_REACTION: _glitch_line_offset_amount_reaction,
		SN_GLITCH_LINE_SPEED_REACTION: _glitch_line_speed_reaction,
		SN_LENS_DISTORTION_AMOUNT_REACTION: _lens_distortion_amount_reaction,
		SN_LENS_DISTORTION_ZOOM_FACTOR_REACTION: _lens_distortion_zoom_factor_reaction,
		SN_SCANLINES_SPEED_REACTION: _scanlines_speed_reaction,
		SN_SPIN_ZOOM_BLUR_AMOUNT_REACTION: _spin_zoom_blur_amount_reaction,
		SN_VIGNETTE_SIZE_REACTION: _vignette_size_reaction
	}
	
	return _property_dictionary

func get_setters() -> Dictionary[StringName, StringName]:
	var _setter_dictionary: Dictionary[StringName, StringName] = {
		SN_ELEMENT_NAME: set_element_name.get_method(),
		SN_ELEMENT_TYPE: set_element_type.get_method(),
		SN_ELEMENT_LAYER: set_element_layer.get_method(),
		SN_ELEMENT_VISIBILITY: set_element_visibility.get_method(),
		SN_VISUAL_EFFECT_TYPE: set_visual_effect_type.get_method(),
		SN_BLOOM_OPACITY: set_bloom_opacity.get_method(),
		SN_BLOOM_RADIUS: set_bloom_radius.get_method(),
		SN_BLOOM_BLEND_MODE: set_bloom_blend_mode.get_method(),
		SN_CHROMATIC_ABERRATION_AMOUNT: set_chromatic_aberration_amount.get_method(),
		SN_GLITCH_BLOCK_OFFSET_AMOUNT: set_glitch_block_offset_amount.get_method(),
		SN_GLITCH_BLOCK_SPEED: set_glitch_block_speed.get_method(),
		SN_GLITCH_LINE_OFFSET_AMOUNT: set_glitch_line_offset_amount.get_method(),
		SN_GLITCH_LINE_SPEED: set_glitch_line_speed.get_method(),
		SN_GRAIN_OPACITY: set_grain_opacity.get_method(),
		SN_GRAIN_BLEND_MODE: set_grain_blend_mode.get_method(),
		SN_GRAIN_STATIC: set_grain_static.get_method(),
		SN_GRAIN_BLUR: set_grain_blur.get_method(),
		SN_LENS_DISTORTION_AMOUNT: set_lens_distortion_amount.get_method(),
		SN_LENS_DISTORTION_ZOOM_FACTOR: set_lens_distortion_zoom_factor.get_method(),
		SN_LENS_DISTORTION_BORDER: set_lens_distortion_border.get_method(),
		SN_LENS_DISTORTION_BORDER_COLOR: set_lens_distortion_border_color.get_method(),
		SN_LENS_DISTORTION_CHROMATIC_ABERRATION_AMOUNT:\
		set_lens_distortion_chromatic_aberration_amount.get_method(),
		SN_SCANLINES_OPACITY: set_scanlines_opacity.get_method(),
		SN_SCANLINES_INTERLACED_SCAN: set_scanlines_interlaced_scan.get_method(),
		SN_SCANLINES_SCALE: set_scanlines_scale.get_method(),
		SN_SCANLINES_SPEED: set_scanlines_speed.get_method(),
		SN_SPIN_ZOOM_BLUR_AMOUNT: set_spin_zoom_blur_amount.get_method(),
		SN_SPIN_ZOOM_BLUR_MODE: set_spin_zoom_blur_mode.get_method(),
		SN_TAPE_DISTORTION_WAVE_OFFSET_AMOUNT: set_tape_distortion_wave_offset_amount.get_method(),
		SN_TAPE_DISTORTION_WAVE_AMOUNT: set_tape_distortion_wave_amount.get_method(),
		SN_TAPE_DISTORTION_WAVE_THICKNESS: set_tape_distortion_wave_thickness.get_method(),
		SN_TAPE_DISTORTION_WAVE_SPEED: set_tape_distortion_wave_speed.get_method(),
		SN_TAPE_DISTORTION_BLOCK_OFFSET_AMOUNT: set_tape_distortion_block_offset_amount.get_method(),
		SN_TAPE_DISTORTION_BLOCK_AMOUNT: set_tape_distortion_block_amount.get_method(),
		SN_TAPE_DISTORTION_BLOCK_SPEED: set_tape_distortion_block_speed.get_method(),
		SN_VIGNETTE_SIZE: set_vignette_size.get_method(),
		SN_VIGNETTE_COLOR: set_vignette_color.get_method(),
		SN_VIGNETTE_SHARPNESS: set_vignette_sharpness.get_method(),
		SN_VIGNETTE_CURVE: set_vignette_curve.get_method(),
		SN_VIGNETTE_SHAPE: set_vignette_shape.get_method(),
		SN_VIGNETTE_FALLOFF_FUNCTION: set_vignette_falloff_function.get_method(),
		SN_AUDIO_SOURCE: set_audio_source.get_method(),
		SN_BEGIN_FREQUENCY: set_begin_frequency.get_method(),
		SN_END_FREQUENCY: set_end_frequency.get_method(),
		SN_MINIMUM_DECIBELS: set_minimum_decibels.get_method(),
		SN_SMOOTHING_TYPE: set_smoothing_type.get_method(),
		SN_SMOOTHING_AMOUNT: set_smoothing_amount.get_method(),
		SN_BLOOM_OPACITY_REACTION: set_bloom_opacity_reaction.get_method(),
		SN_CHROMATIC_ABERRATION_AMOUNT_REACTION: set_chromatic_aberration_amount_reaction.get_method(),
		SN_GLITCH_BLOCK_OFFSET_AMOUNT_REACTION: set_glitch_block_offset_amount_reaction.get_method(),
		SN_GLITCH_BLOCK_SPEED_REACTION: set_glitch_block_speed_reaction.get_method(),
		SN_GLITCH_LINE_OFFSET_AMOUNT_REACTION: set_glitch_line_offset_amount_reaction.get_method(),
		SN_GLITCH_LINE_SPEED_REACTION: set_glitch_line_speed_reaction.get_method(),
		SN_LENS_DISTORTION_AMOUNT_REACTION: set_lens_distortion_amount_reaction.get_method(),
		SN_LENS_DISTORTION_ZOOM_FACTOR_REACTION: set_lens_distortion_zoom_factor_reaction.get_method(),
		SN_SCANLINES_SPEED_REACTION: set_scanlines_speed_reaction.get_method(),
		SN_SPIN_ZOOM_BLUR_AMOUNT_REACTION: set_spin_zoom_blur_amount_reaction.get_method(),
		SN_VIGNETTE_SIZE_REACTION: set_vignette_size_reaction.get_method()
	}
	
	return _setter_dictionary
