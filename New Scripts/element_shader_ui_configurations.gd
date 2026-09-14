# Oscillody
# Copyright (C) 2025-present Akosmo

# element_shader_ui_configurations.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ElementShaderUIConfigurations
extends ElementUIConfigurations

var _current_flow_visibility: bool = false
var _domain_warping_visibility: bool = false
var _echoes_visibility: bool = false
var _isolines_visibility: bool = false
var _simple_gradient_visibility: bool = false
var _tides_visibility: bool = false

var _reaction_visibility: bool = false

func enable_shader_visibility(p_shader: ElementShader.ShaderType) -> void:
	_current_flow_visibility = false
	_domain_warping_visibility = false
	_echoes_visibility = false
	_isolines_visibility = false
	_simple_gradient_visibility = false
	_tides_visibility = false
	
	match p_shader:
		ElementShader.ShaderType.CURRENT_FLOW:
			_current_flow_visibility = true
		ElementShader.ShaderType.DOMAIN_WARPING:
			_domain_warping_visibility = true
		ElementShader.ShaderType.ECHOES:
			_echoes_visibility = true
		ElementShader.ShaderType.ISOLINES:
			_isolines_visibility = true
		ElementShader.ShaderType.SIMPLE_GRADIENT:
			_simple_gradient_visibility = true
		ElementShader.ShaderType.TIDES:
			_tides_visibility = true
	
	ElementManager.notify_property_node_visibility_changed()

func set_reaction_visibility(p_value: bool) -> void:
	_reaction_visibility = p_value
	ElementManager.notify_property_node_visibility_changed()

func get_property_configurations() -> Dictionary[StringName, Dictionary]:
	var ret: Dictionary[StringName, Dictionary] = {
		ElementShader.SN_NAME: {
			CONTROL_NODE: ControlNode.LINE_EDIT,
		},
		ElementShader.SN_TYPE: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			DEFAULT_VALUE: ElementShader.ElementType.EMPTY,
			OPTIONS: ElementShader.ELEMENT_TYPES
		},
		ElementShader.SN_LAYER: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			MINIMUM: 0.0,
			MAXIMUM: ElementManager.get_element_count() - 1.0,
			STEP: 1.0,
			ROUNDED: true
		},
		ElementShader.SN_VISIBILITY: {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: true
		},
		ElementShader.SN_SHADER_TYPE: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			OPTIONS: ElementShader.SHADER_TYPES
		},
		ElementShader.SN_CURRENT_FLOW_WAVE_COLOR: {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.WHITE,
			VISIBLE: _current_flow_visibility
		},
		ElementShader.SN_CURRENT_FLOW_BACKGROUND_COLOR: {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.BLACK,
			VISIBLE: _current_flow_visibility
		},
		ElementShader.SN_CURRENT_FLOW_ITERATIONS: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 10.0,
			VISIBLE: _current_flow_visibility,
			MINIMUM: 3.0,
			MAXIMUM: 16.0,
			STEP: 1.0,
			ROUNDED: true
		},
		ElementShader.SN_CURRENT_FLOW_UV_SCALE: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.5,
			VISIBLE: _current_flow_visibility,
			MINIMUM: 0.05,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementShader.SN_CURRENT_FLOW_FILLED: {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: false,
			VISIBLE: _current_flow_visibility
		},
		ElementShader.SN_CURRENT_FLOW_WAVE_THICKNESS: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.25,
			VISIBLE: _current_flow_visibility,
			MINIMUM: 0.1,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementShader.SN_DOMAIN_WARPING_COLOR: {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.WHITE,
			VISIBLE: _domain_warping_visibility
		},
		ElementShader.SN_DOMAIN_WARPING_COLOR_MIX: {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: false,
			VISIBLE: _domain_warping_visibility
		},
		ElementShader.SN_DOMAIN_WARPING_INVERT_COLORS: {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: false,
			VISIBLE: _domain_warping_visibility
		},
		ElementShader.SN_DOMAIN_WARPING_HUE_SHIFT: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _domain_warping_visibility,
			MINIMUM: -1.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementShader.SN_DOMAIN_WARPING_OCTAVES: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 6.0,
			VISIBLE: _domain_warping_visibility,
			MINIMUM: 1.0,
			MAXIMUM: 10.0,
			STEP: 1.0,
			ROUNDED: true
		},
		ElementShader.SN_DOMAIN_WARPING_FREQUENCY_FACTOR: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 2.0,
			VISIBLE: _domain_warping_visibility,
			MINIMUM: 0.5,
			MAXIMUM: 6.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementShader.SN_DOMAIN_WARPING_AMPLITUDE: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.5,
			VISIBLE: _domain_warping_visibility,
			MINIMUM: 0.1,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementShader.SN_DOMAIN_WARPING_FREQUENCY_INCREMENT: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 2.0,
			VISIBLE: _domain_warping_visibility,
			MINIMUM: 1.0,
			MAXIMUM: 4.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementShader.SN_DOMAIN_WARPING_AMPLITUDE_DECREMENT: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.5,
			VISIBLE: _domain_warping_visibility,
			MINIMUM: 0.1,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementShader.SN_ECHOES_PULSE_COLOR: {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.WHITE,
			VISIBLE: _echoes_visibility
		},
		ElementShader.SN_ECHOES_BACKGROUND_COLOR: {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.BLACK,
			VISIBLE: _echoes_visibility
		},
		ElementShader.SN_ECHOES_ITERATIONS: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 8.0,
			VISIBLE: _echoes_visibility,
			MINIMUM: 2.0,
			MAXIMUM: 10.0,
			STEP: 1.0,
			ROUNDED: true
		},
		ElementShader.SN_ECHOES_UV_SCALE: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.1,
			VISIBLE: _echoes_visibility,
			MINIMUM: 0.05,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementShader.SN_ECHOES_FRACTIONAL_UV: {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: false,
			VISIBLE: _echoes_visibility
		},
		ElementShader.SN_ECHOES_SPLIT: {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: false,
			VISIBLE: _echoes_visibility
		},
		ElementShader.SN_ECHOES_ITERATOR_FACTOR: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 1.0,
			VISIBLE: _echoes_visibility,
			MINIMUM: 0.5,
			MAXIMUM: 8.0,
			STEP: 0.5,
			ROUNDED: false
		},
		ElementShader.SN_ECHOES_PULSE_DURATION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.1,
			VISIBLE: _echoes_visibility,
			MINIMUM: 0.05,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementShader.SN_ECHOES_PULSE_OSCILLATION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.1,
			VISIBLE: _echoes_visibility,
			MINIMUM: 0.05,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementShader.SN_ECHOES_PULSE_THICKNESS: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 1.0,
			VISIBLE: _echoes_visibility,
			MINIMUM: 0.1,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementShader.SN_ECHOES_PULSE_MODE: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			DEFAULT_VALUE: ElementShader.EchoesPulseMode.MULTIPLICATION,
			VISIBLE: _echoes_visibility,
			OPTIONS: ElementShader.ECHOES_PULSE_MODES
		},
		ElementShader.SN_ISOLINES_LINE_COLOR: {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.WHITE,
			VISIBLE: _isolines_visibility
		},
		ElementShader.SN_ISOLINES_BACKGROUND_COLOR: {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.BLACK,
			VISIBLE: _isolines_visibility
		},
		ElementShader.SN_ISOLINES_UV_SCALE: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.25,
			VISIBLE: _isolines_visibility,
			MINIMUM: 0.05,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementShader.SN_ISOLINES_FILLED: {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: false,
			VISIBLE: _isolines_visibility
		},
		ElementShader.SN_ISOLINES_LINE_THICKNESS: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.5,
			VISIBLE: _isolines_visibility,
			MINIMUM: 0.05,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementShader.SN_ISOLINES_THICKNESS_VARIATION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _isolines_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementShader.SN_ISOLINES_LINE_AMOUNT: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.25,
			VISIBLE: _isolines_visibility,
			MINIMUM: 0.05,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementShader.SN_SIMPLE_GRADIENT_COLOR_1: {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.WHITE,
			VISIBLE: _simple_gradient_visibility
		},
		ElementShader.SN_SIMPLE_GRADIENT_COLOR_2: {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.BLACK,
			VISIBLE: _simple_gradient_visibility
		},
		ElementShader.SN_SIMPLE_GRADIENT_DIRECTION: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			VISIBLE: _simple_gradient_visibility,
			OPTIONS: ElementShader.SIMPLE_GRADIENT_DIRECTIONS
		},
		ElementShader.SN_TIDES_COLOR: {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.WHITE,
			VISIBLE: _tides_visibility
		},
		ElementShader.SN_TIDES_TINT: {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.BLACK,
			VISIBLE: _tides_visibility
		},
		ElementShader.SN_TIDES_COLOR_MIX: {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: false,
			VISIBLE: _tides_visibility
		},
		ElementShader.SN_TIDES_INVERT_COLORS: {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: false,
			VISIBLE: _tides_visibility
		},
		ElementShader.SN_TIDES_HUE_SHIFT: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _tides_visibility,
			MINIMUM: -1.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementShader.SN_TIDES_ITERATIONS: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 6.0,
			VISIBLE: _tides_visibility,
			MINIMUM: 1.0,
			MAXIMUM: 8.0,
			STEP: 1.0,
			ROUNDED: true
		},
		ElementShader.SN_SHADER_SPEED: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.1,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementShader.SN_SHADER_X_POSITION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.5,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.01,
			ROUNDED: false
		},
		ElementShader.SN_SHADER_Y_POSITION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.5,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.01,
			ROUNDED: false
		},
		ElementShader.SN_SHADER_ROTATION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: -180.0,
			MAXIMUM: 180.0,
			STEP: 5.0,
			ROUNDED: true
		},
		ElementShader.SN_SHADER_SCALE: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 1.0,
			MINIMUM: 0.1,
			MAXIMUM: 2.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementShader.SN_SHADER_BLUR: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementShader.SN_SHADER_BRIGHTNESS: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: -1.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementShader.SN_SHAKE_AMPLITUDE: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementShader.SN_SHAKE_AMPLITUDE_COMPENSATION: {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: true
		},
		ElementShader.SN_SHAKE_FREQUENCY: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementShader.SN_SHAKE_SEED: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: 0.0,
			MAXIMUM: 100.0,
			STEP: 1.0,
			ROUNDED: true
		},
		ElementShader.SN_AUDIO_SOURCE: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			OPTIONS: AudioManager.get_streams().keys()
		},
		ElementShader.SN_BEGIN_FREQUENCY: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 20.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: 20.0,
			MAXIMUM: 60.0,
			STEP: 5.0,
			ROUNDED: true
		},
		ElementShader.SN_END_FREQUENCY: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 80.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: 60.0,
			MAXIMUM: 150.0,
			STEP: 5.0,
			ROUNDED: true
		},
		ElementShader.SN_MINIMUM_DECIBELS: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: -25.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: -100.0,
			MAXIMUM: -10.0,
			STEP: 5.0,
			ROUNDED: true
		},
		ElementShader.SN_SMOOTHING_TYPE: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			DEFAULT_VALUE: ElementShader.ReactiveSmoothingType.DECAY,
			VISIBLE: _reaction_visibility,
			OPTIONS: ElementShader.SMOOTHING_TYPES
		},
		ElementShader.SN_SMOOTHING_AMOUNT: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.5,
			VISIBLE: _reaction_visibility,
			MINIMUM: 0.1,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementShader.SN_SHADER_SPEED_REACTION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementShader.SN_SHADER_ROTATION_REACTION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: -1.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementShader.SN_SHADER_SCALE_REACTION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementShader.SN_SHAKE_AMPLITUDE_REACTION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementShader.SN_SHAKE_FREQUENCY_REACTION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		}
	}
	
	return ret

func get_property_configurations_2(p_property: StringName) -> Dictionary[StringName, Variant]:
	match p_property:
		ElementShader.SN_NAME:
			return { CONTROL_NODE: ControlNode.LINE_EDIT }
		ElementShader.SN_TYPE:
			return {
				CONTROL_NODE: ControlNode.OPTION_BUTTON,
				DEFAULT_VALUE: ElementShader.ElementType.EMPTY,
				OPTIONS: ElementShader.ELEMENT_TYPES
			}
		ElementShader.SN_LAYER:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				MINIMUM: 0.0,
				MAXIMUM: ElementManager.get_element_count() - 1.0,
				STEP: 1.0,
				ROUNDED: true
			}
		ElementShader.SN_VISIBILITY:
			return {
				CONTROL_NODE: ControlNode.CHECK_BUTTON,
				DEFAULT_VALUE: true
			}
		ElementShader.SN_SHADER_TYPE:
			return {
				CONTROL_NODE: ControlNode.OPTION_BUTTON,
				OPTIONS: ElementShader.SHADER_TYPES
			}
		ElementShader.SN_CURRENT_FLOW_WAVE_COLOR:
			return {
				CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
				DEFAULT_VALUE: Color.WHITE,
				VISIBLE: _current_flow_visibility
			}
		ElementShader.SN_CURRENT_FLOW_BACKGROUND_COLOR:
			return {
				CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
				DEFAULT_VALUE: Color.BLACK,
				VISIBLE: _current_flow_visibility
			}
		ElementShader.SN_CURRENT_FLOW_ITERATIONS:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 10.0,
				VISIBLE: _current_flow_visibility,
				MINIMUM: 3.0,
				MAXIMUM: 16.0,
				STEP: 1.0,
				ROUNDED: true
			}
		ElementShader.SN_CURRENT_FLOW_UV_SCALE:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.5,
				VISIBLE: _current_flow_visibility,
				MINIMUM: 0.05,
				MAXIMUM: 1.0,
				STEP: 0.05,
				ROUNDED: false
			}
		ElementShader.SN_CURRENT_FLOW_FILLED:
			return {
				CONTROL_NODE: ControlNode.CHECK_BUTTON,
				DEFAULT_VALUE: false,
				VISIBLE: _current_flow_visibility
			}
		ElementShader.SN_CURRENT_FLOW_WAVE_THICKNESS:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.25,
				VISIBLE: _current_flow_visibility,
				MINIMUM: 0.1,
				MAXIMUM: 1.0,
				STEP: 0.05,
				ROUNDED: false
			}
		ElementShader.SN_DOMAIN_WARPING_COLOR:
			return {
				CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
				DEFAULT_VALUE: Color.WHITE,
				VISIBLE: _domain_warping_visibility
			}
		ElementShader.SN_DOMAIN_WARPING_COLOR_MIX:
			return {
				CONTROL_NODE: ControlNode.CHECK_BUTTON,
				DEFAULT_VALUE: false,
				VISIBLE: _domain_warping_visibility
			}
		ElementShader.SN_DOMAIN_WARPING_INVERT_COLORS:
			return {
				CONTROL_NODE: ControlNode.CHECK_BUTTON,
				DEFAULT_VALUE: false,
				VISIBLE: _domain_warping_visibility
			}
		ElementShader.SN_DOMAIN_WARPING_HUE_SHIFT:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.0,
				VISIBLE: _domain_warping_visibility,
				MINIMUM: -1.0,
				MAXIMUM: 1.0,
				STEP: 0.05,
				ROUNDED: false
			}
		ElementShader.SN_DOMAIN_WARPING_OCTAVES:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 6.0,
				VISIBLE: _domain_warping_visibility,
				MINIMUM: 1.0,
				MAXIMUM: 10.0,
				STEP: 1.0,
				ROUNDED: true
			}
		ElementShader.SN_DOMAIN_WARPING_FREQUENCY_FACTOR:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 2.0,
				VISIBLE: _domain_warping_visibility,
				MINIMUM: 0.5,
				MAXIMUM: 6.0,
				STEP: 0.1,
				ROUNDED: false
			}
		ElementShader.SN_DOMAIN_WARPING_AMPLITUDE:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.5,
				VISIBLE: _domain_warping_visibility,
				MINIMUM: 0.1,
				MAXIMUM: 1.0,
				STEP: 0.05,
				ROUNDED: false
			}
		ElementShader.SN_DOMAIN_WARPING_FREQUENCY_INCREMENT:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 2.0,
				VISIBLE: _domain_warping_visibility,
				MINIMUM: 1.0,
				MAXIMUM: 4.0,
				STEP: 0.1,
				ROUNDED: false
			}
		ElementShader.SN_DOMAIN_WARPING_AMPLITUDE_DECREMENT:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.5,
				VISIBLE: _domain_warping_visibility,
				MINIMUM: 0.1,
				MAXIMUM: 1.0,
				STEP: 0.05,
				ROUNDED: false
			}
		ElementShader.SN_ECHOES_PULSE_COLOR:
			return {
				CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
				DEFAULT_VALUE: Color.WHITE,
				VISIBLE: _echoes_visibility
			}
		ElementShader.SN_ECHOES_BACKGROUND_COLOR:
			return {
				CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
				DEFAULT_VALUE: Color.BLACK,
				VISIBLE: _echoes_visibility
			}
		ElementShader.SN_ECHOES_ITERATIONS:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 8.0,
				VISIBLE: _echoes_visibility,
				MINIMUM: 2.0,
				MAXIMUM: 10.0,
				STEP: 1.0,
				ROUNDED: true
			}
		ElementShader.SN_ECHOES_UV_SCALE:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.1,
				VISIBLE: _echoes_visibility,
				MINIMUM: 0.05,
				MAXIMUM: 1.0,
				STEP: 0.05,
				ROUNDED: false
			}
		ElementShader.SN_ECHOES_FRACTIONAL_UV:
			return {
				CONTROL_NODE: ControlNode.CHECK_BUTTON,
				DEFAULT_VALUE: false,
				VISIBLE: _echoes_visibility
			}
		ElementShader.SN_ECHOES_SPLIT:
			return {
				CONTROL_NODE: ControlNode.CHECK_BUTTON,
				DEFAULT_VALUE: false,
				VISIBLE: _echoes_visibility
			}
		ElementShader.SN_ECHOES_ITERATOR_FACTOR:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 1.0,
				VISIBLE: _echoes_visibility,
				MINIMUM: 0.5,
				MAXIMUM: 8.0,
				STEP: 0.5,
				ROUNDED: false
			}
		ElementShader.SN_ECHOES_PULSE_DURATION:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.1,
				VISIBLE: _echoes_visibility,
				MINIMUM: 0.05,
				MAXIMUM: 1.0,
				STEP: 0.05,
				ROUNDED: false
			}
		ElementShader.SN_ECHOES_PULSE_OSCILLATION:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.1,
				VISIBLE: _echoes_visibility,
				MINIMUM: 0.05,
				MAXIMUM: 1.0,
				STEP: 0.05,
				ROUNDED: false
			}
		ElementShader.SN_ECHOES_PULSE_THICKNESS:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 1.0,
				VISIBLE: _echoes_visibility,
				MINIMUM: 0.1,
				MAXIMUM: 1.0,
				STEP: 0.05,
				ROUNDED: false
			}
		ElementShader.SN_ECHOES_PULSE_MODE:
			return {
				CONTROL_NODE: ControlNode.OPTION_BUTTON,
				DEFAULT_VALUE: ElementShader.EchoesPulseMode.MULTIPLICATION,
				VISIBLE: _echoes_visibility,
				OPTIONS: ElementShader.ECHOES_PULSE_MODES
			}
		ElementShader.SN_ISOLINES_LINE_COLOR:
			return {
				CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
				DEFAULT_VALUE: Color.WHITE,
				VISIBLE: _isolines_visibility
			}
		ElementShader.SN_ISOLINES_BACKGROUND_COLOR:
			return {
				CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
				DEFAULT_VALUE: Color.BLACK,
				VISIBLE: _isolines_visibility
			}
		ElementShader.SN_ISOLINES_UV_SCALE:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.25,
				VISIBLE: _isolines_visibility,
				MINIMUM: 0.05,
				MAXIMUM: 1.0,
				STEP: 0.05,
				ROUNDED: false
			}
		ElementShader.SN_ISOLINES_FILLED:
			return {
				CONTROL_NODE: ControlNode.CHECK_BUTTON,
				DEFAULT_VALUE: false,
				VISIBLE: _isolines_visibility
			}
		ElementShader.SN_ISOLINES_LINE_THICKNESS:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.5,
				VISIBLE: _isolines_visibility,
				MINIMUM: 0.05,
				MAXIMUM: 1.0,
				STEP: 0.05,
				ROUNDED: false
			}
		ElementShader.SN_ISOLINES_THICKNESS_VARIATION:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.0,
				VISIBLE: _isolines_visibility,
				MINIMUM: 0.0,
				MAXIMUM: 1.0,
				STEP: 0.05,
				ROUNDED: false
			}
		ElementShader.SN_ISOLINES_LINE_AMOUNT:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.25,
				VISIBLE: _isolines_visibility,
				MINIMUM: 0.05,
				MAXIMUM: 1.0,
				STEP: 0.05,
				ROUNDED: false
			}
		ElementShader.SN_SIMPLE_GRADIENT_COLOR_1:
			return {
				CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
				DEFAULT_VALUE: Color.WHITE,
				VISIBLE: _simple_gradient_visibility
			}
		ElementShader.SN_SIMPLE_GRADIENT_COLOR_2:
			return {
				CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
				DEFAULT_VALUE: Color.BLACK,
				VISIBLE: _simple_gradient_visibility
			}
		ElementShader.SN_SIMPLE_GRADIENT_DIRECTION:
			return {
				CONTROL_NODE: ControlNode.OPTION_BUTTON,
				VISIBLE: _simple_gradient_visibility,
				OPTIONS: ElementShader.SIMPLE_GRADIENT_DIRECTIONS
			}
		ElementShader.SN_TIDES_COLOR:
			return {
				CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
				DEFAULT_VALUE: Color.WHITE,
				VISIBLE: _tides_visibility
			}
		ElementShader.SN_TIDES_TINT:
			return {
				CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
				DEFAULT_VALUE: Color.BLACK,
				VISIBLE: _tides_visibility
			}
		ElementShader.SN_TIDES_COLOR_MIX:
			return {
				CONTROL_NODE: ControlNode.CHECK_BUTTON,
				DEFAULT_VALUE: false,
				VISIBLE: _tides_visibility
			}
		ElementShader.SN_TIDES_INVERT_COLORS:
			return {
				CONTROL_NODE: ControlNode.CHECK_BUTTON,
				DEFAULT_VALUE: false,
				VISIBLE: _tides_visibility
			}
		ElementShader.SN_TIDES_HUE_SHIFT:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.0,
				VISIBLE: _tides_visibility,
				MINIMUM: -1.0,
				MAXIMUM: 1.0,
				STEP: 0.05,
				ROUNDED: false
			}
		ElementShader.SN_TIDES_ITERATIONS:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 6.0,
				VISIBLE: _tides_visibility,
				MINIMUM: 1.0,
				MAXIMUM: 8.0,
				STEP: 1.0,
				ROUNDED: true
			}
		ElementShader.SN_SHADER_SPEED:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.1,
				MINIMUM: 0.0,
				MAXIMUM: 1.0,
				STEP: 0.05,
				ROUNDED: false
			}
		ElementShader.SN_SHADER_X_POSITION:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.5,
				MINIMUM: 0.0,
				MAXIMUM: 1.0,
				STEP: 0.01,
				ROUNDED: false
			}
		ElementShader.SN_SHADER_Y_POSITION:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.5,
				MINIMUM: 0.0,
				MAXIMUM: 1.0,
				STEP: 0.01,
				ROUNDED: false
			}
		ElementShader.SN_SHADER_ROTATION:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.0,
				MINIMUM: -180.0,
				MAXIMUM: 180.0,
				STEP: 5.0,
				ROUNDED: true
			}
		ElementShader.SN_SHADER_SCALE:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 1.0,
				MINIMUM: 0.1,
				MAXIMUM: 2.0,
				STEP: 0.1,
				ROUNDED: false
			}
		ElementShader.SN_SHADER_BLUR:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.0,
				MINIMUM: 0.0,
				MAXIMUM: 1.0,
				STEP: 0.05,
				ROUNDED: false
			}
		ElementShader.SN_SHADER_BRIGHTNESS:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.0,
				MINIMUM: -1.0,
				MAXIMUM: 1.0,
				STEP: 0.1,
				ROUNDED: false
			}
		ElementShader.SN_SHAKE_AMPLITUDE:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.0,
				MINIMUM: 0.0,
				MAXIMUM: 1.0,
				STEP: 0.05,
				ROUNDED: false
			}
		ElementShader.SN_SHAKE_AMPLITUDE_COMPENSATION:
			return {
				CONTROL_NODE: ControlNode.CHECK_BUTTON,
				DEFAULT_VALUE: true
			}
		ElementShader.SN_SHAKE_FREQUENCY:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.0,
				MINIMUM: 0.0,
				MAXIMUM: 1.0,
				STEP: 0.05,
				ROUNDED: false
			}
		ElementShader.SN_SHAKE_SEED:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.0,
				MINIMUM: 0.0,
				MAXIMUM: 100.0,
				STEP: 1.0,
				ROUNDED: true
			}
		ElementShader.SN_AUDIO_SOURCE:
			return {
				CONTROL_NODE: ControlNode.OPTION_BUTTON,
				OPTIONS: AudioManager.get_streams().keys()
			}
		ElementShader.SN_BEGIN_FREQUENCY:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 20.0,
				VISIBLE: _reaction_visibility,
				MINIMUM: 20.0,
				MAXIMUM: 60.0,
				STEP: 5.0,
				ROUNDED: true
			}
		ElementShader.SN_END_FREQUENCY:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 80.0,
				VISIBLE: _reaction_visibility,
				MINIMUM: 60.0,
				MAXIMUM: 150.0,
				STEP: 5.0,
				ROUNDED: true
			}
		ElementShader.SN_MINIMUM_DECIBELS:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: -25.0,
				VISIBLE: _reaction_visibility,
				MINIMUM: -100.0,
				MAXIMUM: -10.0,
				STEP: 5.0,
				ROUNDED: true
			}
		ElementShader.SN_SMOOTHING_TYPE:
			return {
				CONTROL_NODE: ControlNode.OPTION_BUTTON,
				DEFAULT_VALUE: ElementShader.ReactiveSmoothingType.DECAY,
				VISIBLE: _reaction_visibility,
				OPTIONS: ElementShader.SMOOTHING_TYPES
			}
		ElementShader.SN_SMOOTHING_AMOUNT:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.5,
				VISIBLE: _reaction_visibility,
				MINIMUM: 0.1,
				MAXIMUM: 1.0,
				STEP: 0.1,
				ROUNDED: false
			}
		ElementShader.SN_SHADER_SPEED_REACTION:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.0,
				VISIBLE: _reaction_visibility,
				MINIMUM: 0.0,
				MAXIMUM: 1.0,
				STEP: 0.05,
				ROUNDED: false
			}
		ElementShader.SN_SHADER_ROTATION_REACTION:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.0,
				VISIBLE: _reaction_visibility,
				MINIMUM: -1.0,
				MAXIMUM: 1.0,
				STEP: 0.1,
				ROUNDED: false
			}
		ElementShader.SN_SHADER_SCALE_REACTION:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.0,
				VISIBLE: _reaction_visibility,
				MINIMUM: 0.0,
				MAXIMUM: 1.0,
				STEP: 0.05,
				ROUNDED: false
			}
		ElementShader.SN_SHAKE_AMPLITUDE_REACTION:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.0,
				VISIBLE: _reaction_visibility,
				MINIMUM: 0.0,
				MAXIMUM: 1.0,
				STEP: 0.05,
				ROUNDED: false
			}
		ElementShader.SN_SHAKE_FREQUENCY_REACTION:
			return {
				CONTROL_NODE: ControlNode.NUMERICAL,
				DEFAULT_VALUE: 0.0,
				VISIBLE: _reaction_visibility,
				MINIMUM: 0.0,
				MAXIMUM: 1.0,
				STEP: 0.05,
				ROUNDED: false
			}
	
	return {}

func get_property_configurations_3(p_property: StringName) -> Dictionary[StringName, Variant]:
	if p_property == ElementShader.SN_NAME:
		return { CONTROL_NODE: ControlNode.LINE_EDIT }
	elif p_property == ElementShader.SN_TYPE:
		return {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			DEFAULT_VALUE: ElementShader.ElementType.EMPTY,
			OPTIONS: ElementShader.ELEMENT_TYPES
		}
	elif p_property == ElementShader.SN_LAYER:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			MINIMUM: 0.0,
			MAXIMUM: ElementManager.get_element_count() - 1.0,
			STEP: 1.0,
			ROUNDED: true
		}
	elif p_property == ElementShader.SN_VISIBILITY:
		return {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: true
		}
	elif p_property == ElementShader.SN_SHADER_TYPE:
		return {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			OPTIONS: ElementShader.SHADER_TYPES
		}
	elif p_property == ElementShader.SN_CURRENT_FLOW_WAVE_COLOR:
		return {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.WHITE,
			VISIBLE: _current_flow_visibility
		}
	elif p_property == ElementShader.SN_CURRENT_FLOW_BACKGROUND_COLOR:
		return {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.BLACK,
			VISIBLE: _current_flow_visibility
		}
	elif p_property == ElementShader.SN_CURRENT_FLOW_ITERATIONS:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 10.0,
			VISIBLE: _current_flow_visibility,
			MINIMUM: 3.0,
			MAXIMUM: 16.0,
			STEP: 1.0,
			ROUNDED: true
		}
	elif p_property == ElementShader.SN_CURRENT_FLOW_UV_SCALE:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.5,
			VISIBLE: _current_flow_visibility,
			MINIMUM: 0.05,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_CURRENT_FLOW_FILLED:
		return {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: false,
			VISIBLE: _current_flow_visibility
		}
	elif p_property == ElementShader.SN_CURRENT_FLOW_WAVE_THICKNESS:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.25,
			VISIBLE: _current_flow_visibility,
			MINIMUM: 0.1,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_DOMAIN_WARPING_COLOR:
		return {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.WHITE,
			VISIBLE: _domain_warping_visibility
		}
	elif p_property == ElementShader.SN_DOMAIN_WARPING_COLOR_MIX:
		return {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: false,
			VISIBLE: _domain_warping_visibility
		}
	elif p_property == ElementShader.SN_DOMAIN_WARPING_INVERT_COLORS:
		return {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: false,
			VISIBLE: _domain_warping_visibility
		}
	elif p_property == ElementShader.SN_DOMAIN_WARPING_HUE_SHIFT:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _domain_warping_visibility,
			MINIMUM: -1.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_DOMAIN_WARPING_OCTAVES:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 6.0,
			VISIBLE: _domain_warping_visibility,
			MINIMUM: 1.0,
			MAXIMUM: 10.0,
			STEP: 1.0,
			ROUNDED: true
		}
	elif p_property == ElementShader.SN_DOMAIN_WARPING_FREQUENCY_FACTOR:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 2.0,
			VISIBLE: _domain_warping_visibility,
			MINIMUM: 0.5,
			MAXIMUM: 6.0,
			STEP: 0.1,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_DOMAIN_WARPING_AMPLITUDE:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.5,
			VISIBLE: _domain_warping_visibility,
			MINIMUM: 0.1,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_DOMAIN_WARPING_FREQUENCY_INCREMENT:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 2.0,
			VISIBLE: _domain_warping_visibility,
			MINIMUM: 1.0,
			MAXIMUM: 4.0,
			STEP: 0.1,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_DOMAIN_WARPING_AMPLITUDE_DECREMENT:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.5,
			VISIBLE: _domain_warping_visibility,
			MINIMUM: 0.1,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_ECHOES_PULSE_COLOR:
		return {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.WHITE,
			VISIBLE: _echoes_visibility
		}
	elif p_property == ElementShader.SN_ECHOES_BACKGROUND_COLOR:
		return {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.BLACK,
			VISIBLE: _echoes_visibility
		}
	elif p_property == ElementShader.SN_ECHOES_ITERATIONS:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 8.0,
			VISIBLE: _echoes_visibility,
			MINIMUM: 2.0,
			MAXIMUM: 10.0,
			STEP: 1.0,
			ROUNDED: true
		}
	elif p_property == ElementShader.SN_ECHOES_UV_SCALE:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.1,
			VISIBLE: _echoes_visibility,
			MINIMUM: 0.05,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_ECHOES_FRACTIONAL_UV:
		return {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: false,
			VISIBLE: _echoes_visibility
		}
	elif p_property == ElementShader.SN_ECHOES_SPLIT:
		return {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: false,
			VISIBLE: _echoes_visibility
		}
	elif p_property == ElementShader.SN_ECHOES_ITERATOR_FACTOR:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 1.0,
			VISIBLE: _echoes_visibility,
			MINIMUM: 0.5,
			MAXIMUM: 8.0,
			STEP: 0.5,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_ECHOES_PULSE_DURATION:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.1,
			VISIBLE: _echoes_visibility,
			MINIMUM: 0.05,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_ECHOES_PULSE_OSCILLATION:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.1,
			VISIBLE: _echoes_visibility,
			MINIMUM: 0.05,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_ECHOES_PULSE_THICKNESS:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 1.0,
			VISIBLE: _echoes_visibility,
			MINIMUM: 0.1,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_ECHOES_PULSE_MODE:
		return {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			DEFAULT_VALUE: ElementShader.EchoesPulseMode.MULTIPLICATION,
			VISIBLE: _echoes_visibility,
			OPTIONS: ElementShader.ECHOES_PULSE_MODES
		}
	elif p_property == ElementShader.SN_ISOLINES_LINE_COLOR:
		return {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.WHITE,
			VISIBLE: _isolines_visibility
		}
	elif p_property == ElementShader.SN_ISOLINES_BACKGROUND_COLOR:
		return {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.BLACK,
			VISIBLE: _isolines_visibility
		}
	elif p_property == ElementShader.SN_ISOLINES_UV_SCALE:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.25,
			VISIBLE: _isolines_visibility,
			MINIMUM: 0.05,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_ISOLINES_FILLED:
		return {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: false,
			VISIBLE: _isolines_visibility
		}
	elif p_property == ElementShader.SN_ISOLINES_LINE_THICKNESS:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.5,
			VISIBLE: _isolines_visibility,
			MINIMUM: 0.05,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_ISOLINES_THICKNESS_VARIATION:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _isolines_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_ISOLINES_LINE_AMOUNT:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.25,
			VISIBLE: _isolines_visibility,
			MINIMUM: 0.05,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_SIMPLE_GRADIENT_COLOR_1:
		return {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.WHITE,
			VISIBLE: _simple_gradient_visibility
		}
	elif p_property == ElementShader.SN_SIMPLE_GRADIENT_COLOR_2:
		return {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.BLACK,
			VISIBLE: _simple_gradient_visibility
		}
	elif p_property == ElementShader.SN_SIMPLE_GRADIENT_DIRECTION:
		return {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			VISIBLE: _simple_gradient_visibility,
			OPTIONS: ElementShader.SIMPLE_GRADIENT_DIRECTIONS
		}
	elif p_property == ElementShader.SN_TIDES_COLOR:
		return {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.WHITE,
			VISIBLE: _tides_visibility
		}
	elif p_property == ElementShader.SN_TIDES_TINT:
		return {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.BLACK,
			VISIBLE: _tides_visibility
		}
	elif p_property == ElementShader.SN_TIDES_COLOR_MIX:
		return {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: false,
			VISIBLE: _tides_visibility
		}
	elif p_property == ElementShader.SN_TIDES_INVERT_COLORS:
		return {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: false,
			VISIBLE: _tides_visibility
		}
	elif p_property == ElementShader.SN_TIDES_HUE_SHIFT:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _tides_visibility,
			MINIMUM: -1.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_TIDES_ITERATIONS:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 6.0,
			VISIBLE: _tides_visibility,
			MINIMUM: 1.0,
			MAXIMUM: 8.0,
			STEP: 1.0,
			ROUNDED: true
		}
	elif p_property == ElementShader.SN_SHADER_SPEED:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.1,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_SHADER_X_POSITION:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.5,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.01,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_SHADER_Y_POSITION:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.5,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.01,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_SHADER_ROTATION:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: -180.0,
			MAXIMUM: 180.0,
			STEP: 5.0,
			ROUNDED: true
		}
	elif p_property == ElementShader.SN_SHADER_SCALE:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 1.0,
			MINIMUM: 0.1,
			MAXIMUM: 2.0,
			STEP: 0.1,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_SHADER_BLUR:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_SHADER_BRIGHTNESS:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: -1.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_SHAKE_AMPLITUDE:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_SHAKE_AMPLITUDE_COMPENSATION:
		return {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: true
		}
	elif p_property == ElementShader.SN_SHAKE_FREQUENCY:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_SHAKE_SEED:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: 0.0,
			MAXIMUM: 100.0,
			STEP: 1.0,
			ROUNDED: true
		}
	elif p_property == ElementShader.SN_AUDIO_SOURCE:
		return {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			OPTIONS: AudioManager.get_streams().keys()
		}
	elif p_property == ElementShader.SN_BEGIN_FREQUENCY:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 20.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: 20.0,
			MAXIMUM: 60.0,
			STEP: 5.0,
			ROUNDED: true
		}
	elif p_property == ElementShader.SN_END_FREQUENCY:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 80.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: 60.0,
			MAXIMUM: 150.0,
			STEP: 5.0,
			ROUNDED: true
		}
	elif p_property == ElementShader.SN_MINIMUM_DECIBELS:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: -25.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: -100.0,
			MAXIMUM: -10.0,
			STEP: 5.0,
			ROUNDED: true
		}
	elif p_property == ElementShader.SN_SMOOTHING_TYPE:
		return {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			DEFAULT_VALUE: ElementShader.ReactiveSmoothingType.DECAY,
			VISIBLE: _reaction_visibility,
			OPTIONS: ElementShader.SMOOTHING_TYPES
		}
	elif p_property == ElementShader.SN_SMOOTHING_AMOUNT:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.5,
			VISIBLE: _reaction_visibility,
			MINIMUM: 0.1,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_SHADER_SPEED_REACTION:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_SHADER_ROTATION_REACTION:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: -1.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_SHADER_SCALE_REACTION:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_SHAKE_AMPLITUDE_REACTION:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		}
	elif p_property == ElementShader.SN_SHAKE_FREQUENCY_REACTION:
		return {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		}
	else:
		return {}
