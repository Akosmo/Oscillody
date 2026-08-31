# Oscillody
# Copyright (C) 2025-present Akosmo

# element_analyzer_ui_configurations.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ElementAnalyzerUIConfigurations
extends ElementUIConfigurations

func get_property_configurations() -> Dictionary[StringName, Dictionary]:
	var ret: Dictionary[StringName, Dictionary] = {
		ElementAnalyzer.SN_NAME: {
			CONTROL_NODE: ControlNode.LINE_EDIT,
		},
		ElementAnalyzer.SN_TYPE: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			DEFAULT_VALUE: ElementAnalyzer.ElementType.EMPTY,
			OPTIONS: ElementAnalyzer.ELEMENT_TYPES
		},
		ElementAnalyzer.SN_LAYER: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			MINIMUM: 0.0,
			MAXIMUM: ElementManager.get_element_count() - 1.0,
			STEP: 1.0,
			ROUNDED: true
		},
		ElementAnalyzer.SN_VISIBILITY: {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: true
		},
		ElementAnalyzer.SN_ANALYZER_TYPE: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			OPTIONS: ElementAnalyzer.ANALYZER_TYPES
		},
		ElementAnalyzer.SN_AUDIO_SOURCE: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			OPTIONS: AudioManager.get_streams().keys()
		},
		ElementAnalyzer.SN_BEGIN_X_POSITION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.01,
			ROUNDED: false
		},
		ElementAnalyzer.SN_BEGIN_Y_POSITION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.5,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.01,
			ROUNDED: false
		},
		ElementAnalyzer.SN_END_X_POSITION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 1.0,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.01,
			ROUNDED: false
		},
		ElementAnalyzer.SN_END_Y_POSITION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.5,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.01,
			ROUNDED: false
		},
		ElementAnalyzer.SN_HEIGHT: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.5,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.01,
			ROUNDED: false
		},
		ElementAnalyzer.SN_WAVEFORM_SAMPLE_HISTORY_LENGTH: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 4.0,
			MINIMUM: 1.0,
			MAXIMUM: 32.0,
			STEP: 1.0,
			ROUNDED: true
		},
		ElementAnalyzer.SN_WAVEFORM_THICKNESS: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 1.0,
			MINIMUM: 0.0,
			MAXIMUM: 10.0,
			STEP: 1.0,
			ROUNDED: true
		},
		ElementAnalyzer.SN_WAVEFORM_COLOR: {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.WHITE
		},
		ElementAnalyzer.SN_WAVEFORM_ANTIALIASING: {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: true
		}
	}
	
	return ret
