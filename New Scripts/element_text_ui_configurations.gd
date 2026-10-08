# Oscillody
# Copyright (C) 2025-present Akosmo

# element_text_ui_configurations.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ElementTextUIConfigurations
extends ElementUIConfigurations

var _reaction_visibility: bool = false

func set_reaction_visibility(p_value: bool) -> void:
	_reaction_visibility = p_value
	ElementManager.notify_property_node_visibility_changed()

func get_configurations() -> Dictionary[StringName, Dictionary]:
	var ret: Dictionary[StringName, Dictionary] = {
		ElementText.SN_ELEMENT_NAME: {
			CONTROL_NODE: ControlNode.LINE_EDIT,
		},
		ElementText.SN_ELEMENT_TYPE: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			DEFAULT_VALUE: ElementText.ElementType.EMPTY,
			OPTIONS: ElementText.ELEMENT_TYPES
		},
		ElementText.SN_ELEMENT_LAYER: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			MINIMUM: 0.0,
			MAXIMUM: ElementManager.get_element_count() - 1.0,
			STEP: 1.0,
			ROUNDED: true
		},
		ElementText.SN_ELEMENT_VISIBILITY: {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: true
		},
		ElementText.SN_TEXT: {
			CONTROL_NODE: ControlNode.TEXT_EDIT
		},
		ElementText.SN_TEXT_FONT: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			DEFAULT_VALUE: "Calibri",
			OPTIONS: OS.get_system_fonts()
		},
		ElementText.SN_TEXT_BOLD: {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: false
		},
		ElementText.SN_TEXT_ITALIC: {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: false
		},
		ElementText.SN_TEXT_SIZE: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 32.0,
			MINIMUM: 8.0,
			MAXIMUM: 256.0,
			STEP: 4.0,
			ROUNDED: true
		},
		ElementText.SN_TEXT_X_POSITION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.5,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.01,
			ROUNDED: false
		},
		ElementText.SN_TEXT_Y_POSITION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.5,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.01,
			ROUNDED: false
		},
		ElementText.SN_TEXT_ROTATION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: -180.0,
			MAXIMUM: 180.0,
			STEP: 5.0,
			ROUNDED: true
		},
		ElementText.SN_TEXT_COLOR: {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.WHITE
		},
		ElementText.SN_TEXT_SHADOW_X_POSITION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: -64.0,
			MAXIMUM: 64.0,
			STEP: 2.0,
			ROUNDED: true
		},
		ElementText.SN_TEXT_SHADOW_Y_POSITION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: -64.0,
			MAXIMUM: 64.0,
			STEP: 2.0,
			ROUNDED: true
		},
		ElementText.SN_TEXT_SHADOW_SIZE: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: 0.0,
			MAXIMUM: 128.0,
			STEP: 2.0,
			ROUNDED: true
		},
		ElementText.SN_TEXT_SHADOW_COLOR: {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color(0.0, 0.0, 0.0, 0.0)
		},
		ElementText.SN_TEXT_OUTLINE_SIZE: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: 0.0,
			MAXIMUM: 128.0,
			STEP: 2.0,
			ROUNDED: true
		},
		ElementText.SN_TEXT_OUTLINE_COLOR: {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.GRAY
		},
		ElementText.SN_TEXT_LINE_SPACING: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 3.0,
			MINIMUM: -20.0,
			MAXIMUM: 20.0,
			STEP: 1.0,
			ROUNDED: true
		},
		ElementText.SN_TEXT_HORIZONTAL_ALIGNMENT: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			DEFAULT_VALUE: HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER,
			OPTIONS: ElementText.HORIZONTAL_ALIGNMENTS
		},
		ElementText.SN_SHAKE_AMPLITUDE: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementText.SN_SHAKE_AMPLITUDE_COMPENSATION: {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: true
		},
		ElementText.SN_SHAKE_FREQUENCY: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementText.SN_SHAKE_SEED: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: 0.0,
			MAXIMUM: 100.0,
			STEP: 1.0,
			ROUNDED: true
		},
		ElementText.SN_AUDIO_SOURCE: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			OPTIONS: AudioManager.get_streams().keys()
		},
		ElementText.SN_BEGIN_FREQUENCY: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 20.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: 20.0,
			MAXIMUM: 60.0,
			STEP: 5.0,
			ROUNDED: true
		},
		ElementText.SN_END_FREQUENCY: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 80.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: 60.0,
			MAXIMUM: 150.0,
			STEP: 5.0,
			ROUNDED: true
		},
		ElementText.SN_MINIMUM_DECIBELS: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: -25.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: -100.0,
			MAXIMUM: -10.0,
			STEP: 5.0,
			ROUNDED: true
		},
		ElementText.SN_SMOOTHING_TYPE: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			DEFAULT_VALUE: ElementText.ReactiveSmoothingType.DECAY,
			VISIBLE: _reaction_visibility,
			OPTIONS: ElementText.SMOOTHING_TYPES
		},
		ElementText.SN_SMOOTHING_AMOUNT: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.5,
			VISIBLE: _reaction_visibility,
			MINIMUM: 0.1,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementText.SN_TEXT_ROTATION_REACTION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: -1.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementText.SN_TEXT_SCALE_REACTION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementText.SN_SHAKE_AMPLITUDE_REACTION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementText.SN_SHAKE_FREQUENCY_REACTION: {
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
