# Oscillody
# Copyright (C) 2025-present Akosmo

# property_configurations.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

# NOTE: This class might not be needed.

class_name PropertyConfigurations
extends Resource

enum ControlNode {
	BUTTON,
	CHECK_BUTTON,
	COLOR_PICKER_BUTTON,
	LINE_EDIT,
	NUMERICAL,
	OPTION_BUTTON,
	TEXT_EDIT
}

const CONTROL_NODE: StringName = &"Control Node"
const DEFAULT_VALUE: StringName = &"Default Value"

var _control_node: ControlNode:
	set = set_control_node,
	get = get_control_node
var _default_value: Variant:
	set = set_default_value,
	get = get_default_value

func set_control_node(p_value: ControlNode) -> void:
	_control_node = p_value

func get_control_node() -> ControlNode:
	return _control_node

func set_default_value(p_value: Variant) -> void:
	_default_value = p_value

func get_default_value() -> Variant:
	return _default_value
