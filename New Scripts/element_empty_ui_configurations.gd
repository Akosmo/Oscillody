# Oscillody
# Copyright (C) 2025-present Akosmo

# element_empty_ui_configurations.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ElementEmptyUIConfigurations
extends ElementUIConfigurations

func get_property_configurations() -> Dictionary[StringName, Dictionary]:
	var ret: Dictionary[StringName, Dictionary] = {
		ElementEmpty.SN_NAME: {
			CONTROL_NODE: ControlNode.LINE_EDIT,
		},
		ElementEmpty.SN_TYPE: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			DEFAULT_VALUE: ElementEmpty.ElementType.EMPTY,
			OPTIONS: ElementEmpty.ELEMENT_TYPES
		},
		ElementEmpty.SN_LAYER: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			MINIMUM: 0.0,
			MAXIMUM: ElementManager.get_element_count() - 1.0,
			STEP: 1.0,
			ROUNDED: true
		},
		ElementEmpty.SN_VISIBILITY: {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: true
		}
	}
	
	return ret
