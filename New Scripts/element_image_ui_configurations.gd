# Oscillody
# Copyright (C) 2025-present Akosmo

# element_image_ui_configurations.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ElementImageUIConfigurations
extends ElementUIConfigurations

func get_property_configurations() -> Dictionary[StringName, Dictionary]:
	var ret: Dictionary[StringName, Dictionary] = {
		ElementImage.SN_NAME: {
			CONTROL_NODE: ControlNode.LINE_EDIT,
		},
		ElementImage.SN_TYPE: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			DEFAULT_VALUE: ElementImage.ElementType.EMPTY,
			OPTIONS: ElementImage.ELEMENT_TYPES
		},
		ElementImage.SN_LAYER: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			MINIMUM: 0.0,
			MAXIMUM: ElementManager.get_element_count() - 1.0,
			STEP: 1.0,
			ROUNDED: true
		},
		ElementImage.SN_VISIBILITY: {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: true
		},
		ElementImage.SN_IMAGE_PATH: {
			CONTROL_NODE: ControlNode.BUTTON,
			DEFAULT_VALUE: ""
		},
		ElementImage.SN_IMAGE_X_POSITION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.5,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.01,
			ROUNDED: false
		},
		ElementImage.SN_IMAGE_Y_POSITION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.5,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.01,
			ROUNDED: false
		},
		ElementImage.SN_IMAGE_ROTATION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: -180.0,
			MAXIMUM: 180.0,
			STEP: 5.0,
			ROUNDED: true
		},
		ElementImage.SN_IMAGE_SCALE: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 1.0,
			MINIMUM: 0.1,
			MAXIMUM: 2.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementImage.SN_OPACITY: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 1.0,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementImage.SN_BLUR: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementImage.SN_SHAKE_AMPLITUDE: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementImage.SN_SHAKE_FREQUENCY: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementImage.SN_SHAKE_SEED: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			MINIMUM: 0.0,
			MAXIMUM: 100.0,
			STEP: 1.0,
			ROUNDED: true
		}
	}
	
	return ret
