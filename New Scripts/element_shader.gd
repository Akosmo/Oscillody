# Oscillody
# Copyright (C) 2025-present Akosmo

# element_shader.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ElementShader
extends ElementShakable

enum ShaderType {
	CURRENT_FLOW,
	DOMAIN_WARPING,
	ECHOES,
	ISOLINES,
	SIMPLE_GRADIENT,
	TIDES
}

enum EchoesPulseMode {
	MULTIPLICATION,
	DIVISION,
	ADDITION,
	SUBTRACTION
}

enum SimpleGradientDirection {
	BOTTOM_LEFT,
	LEFT,
	TOP_LEFT,
	TOP
}

const SHADER_TYPES: Array[StringName] = [
	&"Current Flow",
	&"Domain Warping",
	&"Echoes",
	&"Isolines",
	&"Simple Gradient",
	&"Tides"
]

const ECHOES_PULSE_MODES: Array[StringName] = [
	&"Multiplication",
	&"Division",
	&"Addition",
	&"Subtraction"
]

const SIMPLE_GRADIENT_DIRECTIONS: Array[StringName] = [
	&"Bottom-Left",
	&"Left",
	&"Top-Left",
	&"Top"
]

const SN_SHADER_TYPE: StringName = &"Shader_Type"

const SN_CURRENT_FLOW_WAVE_COLOR: StringName = &"(Current_Flow)_Wave_Color"
const SN_CURRENT_FLOW_BACKGROUND_COLOR: StringName = &"(Current_Flow)_Background_Color"
const SN_CURRENT_FLOW_ITERATIONS: StringName = &"(Current_Flow)_Iterations"
const SN_CURRENT_FLOW_UV_SCALE: StringName = &"(Current_Flow)_UV_Scale"
const SN_CURRENT_FLOW_FILLED: StringName = &"(Current_Flow)_Filled"
const SN_CURRENT_FLOW_WAVE_THICKNESS: StringName = &"(Current_Flow)_Wave_Thickness"

const SN_DOMAIN_WARPING_COLOR: StringName = &"(Domain_Warping)_Color"
const SN_DOMAIN_WARPING_COLOR_MIX: StringName = &"(Domain_Warping)_Color_Mix"
const SN_DOMAIN_WARPING_INVERT_COLORS: StringName = &"(Domain_Warping)_Invert_Colors"
const SN_DOMAIN_WARPING_HUE_SHIFT: StringName = &"(Domain_Warping)_Hue_Shift"
const SN_DOMAIN_WARPING_OCTAVES: StringName = &"(Domain_Warping)_Octaves"
const SN_DOMAIN_WARPING_FREQUENCY_FACTOR: StringName = &"(Domain_Warping)_Frequency_Factor"
const SN_DOMAIN_WARPING_AMPLITUDE: StringName = &"(Domain_Warping)_Amplitude"
const SN_DOMAIN_WARPING_FREQUENCY_INCREMENT: StringName = &"(Domain_Warping)_Frequency_Increment"
const SN_DOMAIN_WARPING_AMPLITUDE_DECREMENT: StringName = &"(Domain_Warping)_Amplitude_Decrement"

const SN_ECHOES_PULSE_COLOR: StringName = &"(Echoes)_Pulse_Color"
const SN_ECHOES_BACKGROUND_COLOR: StringName = &"(Echoes)_Background_Color"
const SN_ECHOES_ITERATIONS: StringName = &"(Echoes)_Iterations"
const SN_ECHOES_UV_SCALE: StringName = &"(Echoes)_UV_Scale"
const SN_ECHOES_FRACTIONAL_UV: StringName = &"(Echoes)_Fractional_UV"
const SN_ECHOES_SPLIT: StringName = &"(Echoes)_Split"
const SN_ECHOES_ITERATOR_FACTOR: StringName = &"(Echoes)_Iterator_Factor"
const SN_ECHOES_PULSE_DURATION: StringName = &"(Echoes)_Pulse_Duration"
const SN_ECHOES_PULSE_OSCILLATION: StringName = &"(Echoes)_Pulse_Oscillation"
const SN_ECHOES_PULSE_THICKNESS: StringName = &"(Echoes)_Pulse_Thickness"
const SN_ECHOES_PULSE_MODE: StringName = &"(Echoes)_Pulse_Mode"

const SN_ISOLINES_LINE_COLOR: StringName = &"(Isolines)_Line_Color"
const SN_ISOLINES_BACKGROUND_COLOR: StringName = &"(Isolines)_Background_Color"
const SN_ISOLINES_UV_SCALE: StringName = &"(Isolines)_UV_Scale"
const SN_ISOLINES_FILLED: StringName = &"(Isolines)_Filled"
const SN_ISOLINES_LINE_THICKNESS: StringName = &"(Isolines)_Line_Thickness"
const SN_ISOLINES_THICKNESS_VARIATION: StringName = &"(Isolines)_Thickness_Variation"
const SN_ISOLINES_LINE_AMOUNT: StringName = &"(Isolines)_Line_Amount"

const SN_SIMPLE_GRADIENT_COLOR_1: StringName = &"(Simple_Gradient)_Color_1"
const SN_SIMPLE_GRADIENT_COLOR_2: StringName = &"(Simple_Gradient)_Color_2"
const SN_SIMPLE_GRADIENT_DIRECTION: StringName = &"(Simple_Gradient)_Direction"

const SN_TIDES_COLOR: StringName = &"(Tides)_Color"
const SN_TIDES_TINT: StringName = &"(Tides)_Tint"
const SN_TIDES_COLOR_MIX: StringName = &"(Tides)_Color_Mix"
const SN_TIDES_INVERT_COLORS: StringName = &"(Tides)_Invert_Colors"
const SN_TIDES_HUE_SHIFT: StringName = &"(Tides)_Hue_Shift"
const SN_TIDES_ITERATIONS: StringName = &"(Tides)_Iterations"

const SN_SHADER_SPEED: StringName = &"(Shader)_Speed"

const SN_SHADER_X_POSITION: StringName = &"(Shader)_X_Position"
const SN_SHADER_Y_POSITION: StringName = &"(Shader)_Y_Position"
const SN_SHADER_ROTATION: StringName = &"(Shader)_Rotation"
const SN_SHADER_SCALE: StringName = &"(Shader)_Scale"
const SN_SHADER_BLUR: StringName = &"(Shader)_Blur"
const SN_SHADER_BRIGHTNESS: StringName = &"(Shader)_Brightness"

const SN_SHADER_SPEED_REACTION: StringName = &"(Shader)_Speed_Reaction"
const SN_SHADER_ROTATION_REACTION: StringName = &"(Shader)_Rotation_Reaction"
const SN_SHADER_SCALE_REACTION: StringName = &"(Shader)_Scale_Reaction"

var _shader_type: ShaderType = ShaderType.DOMAIN_WARPING

var _current_flow_wave_color: Color = Color.WHITE
var _current_flow_background_color: Color = Color.BLACK
var _current_flow_iterations: int = 10
var _current_flow_uv_scale: float = 0.5 # TODO: `remap(x, 0.05, 1.0, 1.0, 20.0)`
var _current_flow_filled: bool = false
var _current_flow_wave_thickness: float = 0.25 # TODO: `remap(x, 0.1, 1.0, 0.01, 0.5)`

var _domain_warping_color: Color = Color.WHITE
var _domain_warping_color_mix: bool = false
var _domain_warping_invert_colors: bool = false
var _domain_warping_hue_shift: float = 0.0
var _domain_warping_octaves: int = 6
var _domain_warping_frequency_factor: float = 2.0
var _domain_warping_amplitude: float = 0.5
var _domain_warping_frequency_increment: float = 2.0
var _domain_warping_amplitude_decrement: float = 0.5

var _echoes_pulse_color: Color = Color.WHITE
var _echoes_background_color: Color = Color.BLACK
var _echoes_iterations: int = 8
var _echoes_uv_scale: float = 0.1
var _echoes_fractional_uv: bool = false
var _echoes_split: bool = false
var _echoes_iterator_factor: float = 1.0
var _echoes_pulse_duration: float = 0.1 # TODO: `remap(x, 0.05, 1.0, 0.01, 16.0)`
var _echoes_pulse_oscillation: float = 0.1 # TODO: `remap(x, 0.05, 1.0, 0.01, 2.0)`
var _echoes_pulse_thickness: float = 1.0 # TODO: x * 0.1 (original: 0.01 to 0.1).
var _echoes_pulse_mode: EchoesPulseMode = EchoesPulseMode.MULTIPLICATION

var _isolines_line_color: Color = Color.WHITE
var _isolines_background_color: Color = Color.BLACK
var _isolines_uv_scale: float = 0.25 # TODO: x * 20.0 (original: 1.0 to 20.0).
var _isolines_filled: bool = false
var _isolines_line_thickness: float = 0.5 # TODO: x * 20.0 (original: 1.0, 20.0).
var _isolines_thickness_variation: float = 0.0 # TEST: Maybe this could be a boolean.
var _isolines_line_amount: float = 0.25 # TODO: `remap(x, 0.05, 1.0, 1.0, 50.0)`

var _simple_gradient_color_1: Color = Color.WHITE
var _simple_gradient_color_2: Color = Color.BLACK
var _simple_gradient_direction: SimpleGradientDirection = SimpleGradientDirection.BOTTOM_LEFT

var _tides_color: Color = Color.WHITE
var _tides_tint: Color = Color.BLACK
var _tides_color_mix: bool = false
var _tides_invert_colors: bool = false
var _tides_hue_shift: float = 0.0
var _tides_iterations: int = 6

var _shader_speed: float = 0.1 # TODO: x * 20.0 (original: 0.0 to 20.0).

var _shader_x_position: float = 0.5
var _shader_y_position: float = 0.5
var _shader_rotation: float = 0.0
var _shader_scale: float = 1.0
var _shader_blur: float = 0.0
var _shader_brightness: float = 0.0

var _shader_speed_reaction: float = 0.0
var _shader_rotation_reaction: float = 0.0
var _shader_scale_reaction: float = 0.0

func set_shader_type(p_value: ShaderType) -> void:
	_shader_type = p_value
	property_changed.emit(SN_SHADER_TYPE)

func get_shader_type() -> ShaderType:
	return _shader_type

func set_current_flow_wave_color(p_value: Color) -> void:
	_current_flow_wave_color = p_value
	property_changed.emit(SN_CURRENT_FLOW_WAVE_COLOR)

func get_current_flow_wave_color() -> Color:
	return _current_flow_wave_color

func set_current_flow_background_color(p_value: Color) -> void:
	_current_flow_background_color = p_value
	property_changed.emit(SN_CURRENT_FLOW_BACKGROUND_COLOR)

func get_current_flow_background_color() -> Color:
	return _current_flow_background_color

func set_current_flow_iterations(p_value: int) -> void:
	_current_flow_iterations = p_value
	property_changed.emit(SN_CURRENT_FLOW_ITERATIONS)

func get_current_flow_iterations() -> int:
	return _current_flow_iterations

func set_current_flow_uv_scale(p_value: float) -> void:
	_current_flow_uv_scale = p_value
	property_changed.emit(SN_CURRENT_FLOW_UV_SCALE)

func get_current_flow_uv_scale() -> float:
	return _current_flow_uv_scale

func set_current_flow_filled(p_value: bool) -> void:
	_current_flow_filled = p_value
	property_changed.emit(SN_CURRENT_FLOW_FILLED)

func get_current_flow_filled() -> bool:
	return _current_flow_filled

func set_current_flow_wave_thickness(p_value: float) -> void:
	_current_flow_wave_thickness = p_value
	property_changed.emit(SN_CURRENT_FLOW_WAVE_THICKNESS)

func get_current_flow_wave_thickness() -> float:
	return _current_flow_wave_thickness

func set_domain_warping_color(p_value: Color) -> void:
	_domain_warping_color = p_value
	property_changed.emit(SN_DOMAIN_WARPING_COLOR)

func get_domain_warping_color() -> Color:
	return _domain_warping_color

func set_domain_warping_color_mix(p_value: bool) -> void:
	_domain_warping_color_mix = p_value
	property_changed.emit(SN_DOMAIN_WARPING_COLOR_MIX)

func get_domain_warping_color_mix() -> bool:
	return _domain_warping_color_mix

func set_domain_warping_invert_colors(p_value: bool) -> void:
	_domain_warping_invert_colors = p_value
	property_changed.emit(SN_DOMAIN_WARPING_INVERT_COLORS)

func get_domain_warping_invert_colors() -> bool:
	return _domain_warping_invert_colors

func set_domain_warping_hue_shift(p_value: float) -> void:
	_domain_warping_hue_shift = p_value
	property_changed.emit(SN_DOMAIN_WARPING_HUE_SHIFT)

func get_domain_warping_hue_shift() -> float:
	return _domain_warping_hue_shift

func set_domain_warping_octaves(p_value: int) -> void:
	_domain_warping_octaves = p_value
	property_changed.emit(SN_DOMAIN_WARPING_OCTAVES)

func get_domain_warping_octaves() -> int:
	return _domain_warping_octaves

func set_domain_warping_frequency_factor(p_value: float) -> void:
	_domain_warping_frequency_factor = p_value
	property_changed.emit(SN_DOMAIN_WARPING_FREQUENCY_FACTOR)

func get_domain_warping_frequency_factor() -> float:
	return _domain_warping_frequency_factor

func set_domain_warping_amplitude(p_value: float) -> void:
	_domain_warping_amplitude = p_value
	property_changed.emit(SN_DOMAIN_WARPING_AMPLITUDE)

func get_domain_warping_amplitude() -> float:
	return _domain_warping_amplitude

func set_domain_warping_frequency_increment(p_value: float) -> void:
	_domain_warping_frequency_increment = p_value
	property_changed.emit(SN_DOMAIN_WARPING_FREQUENCY_INCREMENT)

func get_domain_warping_frequency_increment() -> float:
	return _domain_warping_frequency_increment

func set_domain_warping_amplitude_decrement(p_value: float) -> void:
	_domain_warping_amplitude_decrement = p_value
	property_changed.emit(SN_DOMAIN_WARPING_AMPLITUDE_DECREMENT)

func get_domain_warping_amplitude_decrement() -> float:
	return _domain_warping_amplitude_decrement

func set_echoes_pulse_color(p_value: Color) -> void:
	_echoes_pulse_color = p_value
	property_changed.emit(SN_ECHOES_PULSE_COLOR)

func get_echoes_pulse_color() -> Color:
	return _echoes_pulse_color

func set_echoes_background_color(p_value: Color) -> void:
	_echoes_background_color = p_value
	property_changed.emit(SN_ECHOES_BACKGROUND_COLOR)

func get_echoes_background_color() -> Color:
	return _echoes_background_color

func set_echoes_iterations(p_value: int) -> void:
	_echoes_iterations = p_value
	property_changed.emit(SN_ECHOES_ITERATIONS)

func get_echoes_iterations() -> int:
	return _echoes_iterations

func set_echoes_uv_scale(p_value: float) -> void:
	_echoes_uv_scale = p_value
	property_changed.emit(SN_ECHOES_UV_SCALE)

func get_echoes_uv_scale() -> float:
	return _echoes_uv_scale

func set_echoes_fractional_uv(p_value: bool) -> void:
	_echoes_fractional_uv = p_value
	property_changed.emit(SN_ECHOES_FRACTIONAL_UV)

func get_echoes_fractional_uv() -> bool:
	return _echoes_fractional_uv

func set_echoes_split(p_value: bool) -> void:
	_echoes_split = p_value
	property_changed.emit(SN_ECHOES_SPLIT)

func get_echoes_split() -> bool:
	return _echoes_split

func set_echoes_iterator_factor(p_value: float) -> void:
	_echoes_iterator_factor = p_value
	property_changed.emit(SN_ECHOES_ITERATOR_FACTOR)

func get_echoes_iterator_factor() -> float:
	return _echoes_iterator_factor

func set_echoes_pulse_duration(p_value: float) -> void:
	_echoes_pulse_duration = p_value
	property_changed.emit(SN_ECHOES_PULSE_DURATION)

func get_echoes_pulse_duration() -> float:
	return _echoes_pulse_duration

func set_echoes_pulse_oscillation(p_value: float) -> void:
	_echoes_pulse_oscillation = p_value
	property_changed.emit(SN_ECHOES_PULSE_OSCILLATION)

func get_echoes_pulse_oscillation() -> float:
	return _echoes_pulse_oscillation

func set_echoes_pulse_thickness(p_value: float) -> void:
	_echoes_pulse_thickness = p_value
	property_changed.emit(SN_ECHOES_PULSE_THICKNESS)

func get_echoes_pulse_thickness() -> float:
	return _echoes_pulse_thickness

func set_echoes_pulse_mode(p_value: EchoesPulseMode) -> void:
	_echoes_pulse_mode = p_value
	property_changed.emit(SN_ECHOES_PULSE_MODE)

func get_echoes_pulse_mode() -> EchoesPulseMode:
	return _echoes_pulse_mode

func set_isolines_line_color(p_value: Color) -> void:
	_isolines_line_color = p_value
	property_changed.emit(SN_ISOLINES_LINE_COLOR)

func get_isolines_line_color() -> Color:
	return _isolines_line_color

func set_isolines_background_color(p_value: Color) -> void:
	_isolines_background_color = p_value
	property_changed.emit(SN_ISOLINES_BACKGROUND_COLOR)

func get_isolines_background_color() -> Color:
	return _isolines_background_color

func set_isolines_uv_scale(p_value: float) -> void:
	_isolines_uv_scale = p_value
	property_changed.emit(SN_ISOLINES_UV_SCALE)

func get_isolines_uv_scale() -> float:
	return _isolines_uv_scale

func set_isolines_filled(p_value: bool) -> void:
	_isolines_filled = p_value
	property_changed.emit(SN_ISOLINES_FILLED)

func get_isolines_filled() -> bool:
	return _isolines_filled

func set_isolines_line_thickness(p_value: float) -> void:
	_isolines_line_thickness = p_value
	property_changed.emit(SN_ISOLINES_LINE_THICKNESS)

func get_isolines_line_thickness() -> float:
	return _isolines_line_thickness

func set_isolines_thickness_variation(p_value: float) -> void:
	_isolines_thickness_variation = p_value
	property_changed.emit(SN_ISOLINES_THICKNESS_VARIATION)

func get_isolines_thickness_variation() -> float:
	return _isolines_thickness_variation

func set_isolines_line_amount(p_value: float) -> void:
	_isolines_line_amount = p_value
	property_changed.emit(SN_ISOLINES_LINE_AMOUNT)

func get_isolines_line_amount() -> float:
	return _isolines_line_amount

func set_simple_gradient_color_1(p_value: Color) -> void:
	_simple_gradient_color_1 = p_value
	property_changed.emit(SN_SIMPLE_GRADIENT_COLOR_1)

func get_simple_gradient_color_1() -> Color:
	return _simple_gradient_color_1

func set_simple_gradient_color_2(p_value: Color) -> void:
	_simple_gradient_color_2 = p_value
	property_changed.emit(SN_SIMPLE_GRADIENT_COLOR_2)

func get_simple_gradient_color_2() -> Color:
	return _simple_gradient_color_2

func set_simple_gradient_direction(p_value: SimpleGradientDirection) -> void:
	_simple_gradient_direction = p_value
	property_changed.emit(SN_SIMPLE_GRADIENT_DIRECTION)

func get_simple_gradient_direction() -> SimpleGradientDirection:
	return _simple_gradient_direction

func set_tides_color(p_value: Color) -> void:
	_tides_color = p_value
	property_changed.emit(SN_TIDES_COLOR)

func get_tides_color() -> Color:
	return _tides_color

func set_tides_tint(p_value: Color) -> void:
	_tides_tint = p_value
	property_changed.emit(SN_TIDES_TINT)

func get_tides_tint() -> Color:
	return _tides_tint

func set_tides_color_mix(p_value: bool) -> void:
	_tides_color_mix = p_value
	property_changed.emit(SN_TIDES_COLOR_MIX)

func get_tides_color_mix() -> bool:
	return _tides_color_mix

func set_tides_invert_colors(p_value: bool) -> void:
	_tides_invert_colors = p_value
	property_changed.emit(SN_TIDES_INVERT_COLORS)

func get_tides_invert_colors() -> bool:
	return _tides_invert_colors

func set_tides_hue_shift(p_value: float) -> void:
	_tides_hue_shift = p_value
	property_changed.emit(SN_TIDES_HUE_SHIFT)

func get_tides_hue_shift() -> float:
	return _tides_hue_shift

func set_tides_iterations(p_value: int) -> void:
	_tides_iterations = p_value
	property_changed.emit(SN_TIDES_ITERATIONS)

func get_tides_iterations() -> int:
	return _tides_iterations

func set_shader_speed(p_value: float) -> void:
	_shader_speed = p_value
	property_changed.emit(SN_SHADER_SPEED)

func get_shader_speed() -> float:
	return _shader_speed

func set_shader_x_position(p_value: float) -> void:
	_shader_x_position = p_value
	property_changed.emit(SN_SHADER_X_POSITION)

func get_shader_x_position() -> float:
	return _shader_x_position

func set_shader_y_position(p_value: float) -> void:
	_shader_y_position = p_value
	property_changed.emit(SN_SHADER_Y_POSITION)

func get_shader_y_position() -> float:
	return _shader_y_position

func set_shader_rotation(p_value: float) -> void:
	_shader_rotation = p_value
	property_changed.emit(SN_SHADER_ROTATION)

func get_shader_rotation() -> float:
	return _shader_rotation

func set_shader_scale(p_value: float) -> void:
	_shader_scale = p_value
	property_changed.emit(SN_SHADER_SCALE)

func get_shader_scale() -> float:
	return _shader_scale

func set_shader_blur(p_value: float) -> void:
	_shader_blur = p_value
	property_changed.emit(SN_SHADER_BLUR)

func get_shader_blur() -> float:
	return _shader_blur

func set_shader_brightness(p_value: float) -> void:
	_shader_brightness = p_value
	property_changed.emit(SN_SHADER_BRIGHTNESS)

func get_shader_brightness() -> float:
	return _shader_brightness

func set_shader_speed_reaction(p_value: float) -> void:
	_shader_speed_reaction = p_value
	property_changed.emit(SN_SHADER_SPEED_REACTION)

func get_shader_speed_reaction() -> float:
	return _shader_speed_reaction

func set_shader_rotation_reaction(p_value: float) -> void:
	_shader_rotation_reaction = p_value
	property_changed.emit(SN_SHADER_ROTATION_REACTION)

func get_shader_rotation_reaction() -> float:
	return _shader_rotation_reaction

func set_shader_scale_reaction(p_value: float) -> void:
	_shader_scale_reaction = p_value
	property_changed.emit(SN_SHADER_SCALE_REACTION)

func get_shader_scale_reaction() -> float:
	return _shader_scale_reaction

func get_properties() -> Dictionary[StringName, Variant]:
	var _property_dictionary: Dictionary[StringName, Variant] = {
		SN_ELEMENT_NAME: _element_name,
		SN_ELEMENT_TYPE: _element_type,
		SN_ELEMENT_LAYER: _element_layer,
		SN_ELEMENT_VISIBILITY: _element_visibility,
		SN_SHADER_TYPE: _shader_type,
		SN_CURRENT_FLOW_WAVE_COLOR: _current_flow_wave_color,
		SN_CURRENT_FLOW_BACKGROUND_COLOR: _current_flow_background_color,
		SN_CURRENT_FLOW_ITERATIONS: _current_flow_iterations,
		SN_CURRENT_FLOW_UV_SCALE: _current_flow_uv_scale,
		SN_CURRENT_FLOW_FILLED: _current_flow_filled,
		SN_CURRENT_FLOW_WAVE_THICKNESS: _current_flow_wave_thickness,
		SN_DOMAIN_WARPING_COLOR: _domain_warping_color,
		SN_DOMAIN_WARPING_COLOR_MIX: _domain_warping_color_mix,
		SN_DOMAIN_WARPING_INVERT_COLORS: _domain_warping_invert_colors,
		SN_DOMAIN_WARPING_HUE_SHIFT: _domain_warping_hue_shift,
		SN_DOMAIN_WARPING_OCTAVES: _domain_warping_octaves,
		SN_DOMAIN_WARPING_FREQUENCY_FACTOR: _domain_warping_frequency_factor,
		SN_DOMAIN_WARPING_AMPLITUDE: _domain_warping_amplitude,
		SN_DOMAIN_WARPING_FREQUENCY_INCREMENT: _domain_warping_frequency_increment,
		SN_DOMAIN_WARPING_AMPLITUDE_DECREMENT: _domain_warping_amplitude_decrement,
		SN_ECHOES_PULSE_COLOR: _echoes_pulse_color,
		SN_ECHOES_BACKGROUND_COLOR: _echoes_background_color,
		SN_ECHOES_ITERATIONS: _echoes_iterations,
		SN_ECHOES_UV_SCALE: _echoes_uv_scale,
		SN_ECHOES_FRACTIONAL_UV: _echoes_fractional_uv,
		SN_ECHOES_SPLIT: _echoes_split,
		SN_ECHOES_ITERATOR_FACTOR: _echoes_iterator_factor,
		SN_ECHOES_PULSE_DURATION: _echoes_pulse_duration,
		SN_ECHOES_PULSE_OSCILLATION: _echoes_pulse_oscillation,
		SN_ECHOES_PULSE_THICKNESS: _echoes_pulse_thickness,
		SN_ECHOES_PULSE_MODE: _echoes_pulse_mode,
		SN_ISOLINES_LINE_COLOR: _isolines_line_color,
		SN_ISOLINES_BACKGROUND_COLOR: _isolines_background_color,
		SN_ISOLINES_UV_SCALE: _isolines_uv_scale,
		SN_ISOLINES_FILLED: _isolines_filled,
		SN_ISOLINES_LINE_THICKNESS: _isolines_line_thickness,
		SN_ISOLINES_THICKNESS_VARIATION: _isolines_thickness_variation,
		SN_ISOLINES_LINE_AMOUNT: _isolines_line_amount,
		SN_SIMPLE_GRADIENT_COLOR_1: _simple_gradient_color_1,
		SN_SIMPLE_GRADIENT_COLOR_2: _simple_gradient_color_2,
		SN_SIMPLE_GRADIENT_DIRECTION: _simple_gradient_direction,
		SN_TIDES_COLOR: _tides_color,
		SN_TIDES_TINT: _tides_tint,
		SN_TIDES_COLOR_MIX: _tides_color_mix,
		SN_TIDES_INVERT_COLORS: _tides_invert_colors,
		SN_TIDES_HUE_SHIFT: _tides_hue_shift,
		SN_TIDES_ITERATIONS: _tides_iterations,
		SN_SHADER_SPEED: _shader_speed,
		SN_SHADER_X_POSITION: _shader_x_position,
		SN_SHADER_Y_POSITION: _shader_y_position,
		SN_SHADER_ROTATION: _shader_rotation,
		SN_SHADER_SCALE: _shader_scale,
		SN_SHADER_BLUR: _shader_blur,
		SN_SHADER_BRIGHTNESS: _shader_brightness,
		SN_SHAKE_AMPLITUDE: _shake_amplitude,
		SN_SHAKE_AMPLITUDE_COMPENSATION: _shake_amplitude_compensation,
		SN_SHAKE_FREQUENCY: _shake_frequency,
		SN_SHAKE_SEED: _shake_seed,
		SN_AUDIO_SOURCE: _audio_source,
		SN_BEGIN_FREQUENCY: _begin_frequency,
		SN_END_FREQUENCY: _end_frequency,
		SN_MINIMUM_DECIBELS: _minimum_decibels,
		SN_SMOOTHING_TYPE: _smoothing_type,
		SN_SMOOTHING_AMOUNT: _smoothing_amount,
		SN_SHADER_SPEED_REACTION: _shader_speed_reaction,
		SN_SHADER_ROTATION_REACTION: _shader_rotation_reaction,
		SN_SHADER_SCALE_REACTION: _shader_scale_reaction,
		SN_SHAKE_AMPLITUDE_REACTION: _shake_amplitude_reaction,
		SN_SHAKE_FREQUENCY_REACTION: _shake_frequency_reaction
	}
	
	return _property_dictionary

func get_setters() -> Dictionary[StringName, StringName]:
	var _setter_dictionary: Dictionary[StringName, StringName] = {
		SN_ELEMENT_NAME: set_element_name.get_method(),
		SN_ELEMENT_TYPE: set_element_type.get_method(),
		SN_ELEMENT_LAYER: set_element_layer.get_method(),
		SN_ELEMENT_VISIBILITY: set_element_visibility.get_method(),
		SN_SHADER_TYPE: set_shader_type.get_method(),
		SN_CURRENT_FLOW_WAVE_COLOR: set_current_flow_wave_color.get_method(),
		SN_CURRENT_FLOW_BACKGROUND_COLOR: set_current_flow_background_color.get_method(),
		SN_CURRENT_FLOW_ITERATIONS: set_current_flow_iterations.get_method(),
		SN_CURRENT_FLOW_UV_SCALE: set_current_flow_uv_scale.get_method(),
		SN_CURRENT_FLOW_FILLED: set_current_flow_filled.get_method(),
		SN_CURRENT_FLOW_WAVE_THICKNESS: set_current_flow_wave_thickness.get_method(),
		SN_DOMAIN_WARPING_COLOR: set_domain_warping_color.get_method(),
		SN_DOMAIN_WARPING_COLOR_MIX: set_domain_warping_color_mix.get_method(),
		SN_DOMAIN_WARPING_INVERT_COLORS: set_domain_warping_invert_colors.get_method(),
		SN_DOMAIN_WARPING_HUE_SHIFT: set_domain_warping_hue_shift.get_method(),
		SN_DOMAIN_WARPING_OCTAVES: set_domain_warping_octaves.get_method(),
		SN_DOMAIN_WARPING_FREQUENCY_FACTOR: set_domain_warping_frequency_factor.get_method(),
		SN_DOMAIN_WARPING_AMPLITUDE: set_domain_warping_amplitude.get_method(),
		SN_DOMAIN_WARPING_FREQUENCY_INCREMENT: set_domain_warping_frequency_increment.get_method(),
		SN_DOMAIN_WARPING_AMPLITUDE_DECREMENT: set_domain_warping_amplitude_decrement.get_method(),
		SN_ECHOES_PULSE_COLOR: set_echoes_pulse_color.get_method(),
		SN_ECHOES_BACKGROUND_COLOR: set_echoes_background_color.get_method(),
		SN_ECHOES_ITERATIONS: set_echoes_iterations.get_method(),
		SN_ECHOES_UV_SCALE: set_echoes_uv_scale.get_method(),
		SN_ECHOES_FRACTIONAL_UV: set_echoes_fractional_uv.get_method(),
		SN_ECHOES_SPLIT: set_echoes_split.get_method(),
		SN_ECHOES_ITERATOR_FACTOR: set_echoes_iterator_factor.get_method(),
		SN_ECHOES_PULSE_DURATION: set_echoes_pulse_duration.get_method(),
		SN_ECHOES_PULSE_OSCILLATION: set_echoes_pulse_oscillation.get_method(),
		SN_ECHOES_PULSE_THICKNESS: set_echoes_pulse_thickness.get_method(),
		SN_ECHOES_PULSE_MODE: set_echoes_pulse_mode.get_method(),
		SN_ISOLINES_LINE_COLOR: set_isolines_line_color.get_method(),
		SN_ISOLINES_BACKGROUND_COLOR: set_isolines_background_color.get_method(),
		SN_ISOLINES_UV_SCALE: set_isolines_uv_scale.get_method(),
		SN_ISOLINES_FILLED: set_isolines_filled.get_method(),
		SN_ISOLINES_LINE_THICKNESS: set_isolines_line_thickness.get_method(),
		SN_ISOLINES_THICKNESS_VARIATION: set_isolines_thickness_variation.get_method(),
		SN_ISOLINES_LINE_AMOUNT: set_isolines_line_amount.get_method(),
		SN_SIMPLE_GRADIENT_COLOR_1: set_simple_gradient_color_1.get_method(),
		SN_SIMPLE_GRADIENT_COLOR_2: set_simple_gradient_color_2.get_method(),
		SN_SIMPLE_GRADIENT_DIRECTION: set_simple_gradient_direction.get_method(),
		SN_TIDES_COLOR: set_tides_color.get_method(),
		SN_TIDES_TINT: set_tides_tint.get_method(),
		SN_TIDES_COLOR_MIX: set_tides_color_mix.get_method(),
		SN_TIDES_INVERT_COLORS: set_tides_invert_colors.get_method(),
		SN_TIDES_HUE_SHIFT: set_tides_hue_shift.get_method(),
		SN_TIDES_ITERATIONS: set_tides_iterations.get_method(),
		SN_SHADER_SPEED: set_shader_speed.get_method(),
		SN_SHADER_X_POSITION: set_shader_x_position.get_method(),
		SN_SHADER_Y_POSITION: set_shader_y_position.get_method(),
		SN_SHADER_ROTATION: set_shader_rotation.get_method(),
		SN_SHADER_SCALE: set_shader_scale.get_method(),
		SN_SHADER_BLUR: set_shader_blur.get_method(),
		SN_SHADER_BRIGHTNESS: set_shader_brightness.get_method(),
		SN_SHAKE_AMPLITUDE: set_shake_amplitude.get_method(),
		SN_SHAKE_AMPLITUDE_COMPENSATION: set_shake_amplitude_compensation.get_method(),
		SN_SHAKE_FREQUENCY: set_shake_frequency.get_method(),
		SN_SHAKE_SEED: set_shake_seed.get_method(),
		SN_AUDIO_SOURCE: set_audio_source.get_method(),
		SN_BEGIN_FREQUENCY: set_begin_frequency.get_method(),
		SN_END_FREQUENCY: set_end_frequency.get_method(),
		SN_MINIMUM_DECIBELS: set_minimum_decibels.get_method(),
		SN_SMOOTHING_TYPE: set_smoothing_type.get_method(),
		SN_SMOOTHING_AMOUNT: set_smoothing_amount.get_method(),
		SN_SHADER_SPEED_REACTION: set_shader_speed_reaction.get_method(),
		SN_SHADER_ROTATION_REACTION: set_shader_rotation_reaction.get_method(),
		SN_SHADER_SCALE_REACTION: set_shader_scale_reaction.get_method(),
		SN_SHAKE_AMPLITUDE_REACTION: set_shake_amplitude_reaction.get_method(),
		SN_SHAKE_FREQUENCY_REACTION: set_shake_frequency_reaction.get_method()
	}
	
	return _setter_dictionary
