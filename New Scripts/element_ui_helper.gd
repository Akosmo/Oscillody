# Oscillody
# Copyright (C) 2025-present Akosmo

# element_ui_helper.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

extends Node

signal element_name_changed(p_element_uid: int, p_name: String)
signal element_properties_changed(p_element_uid: int)

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

#const BUTTON: StringName = &"Button"
#const CHECK_BUTTON: StringName = &""
#const COLOR_PICKER_BUTTON: StringName = &""
#const LINE_EDIT: StringName = &""
#const NONE: StringName = &""
#const NUMERICAL: StringName = &""
#const OPTION_BUTTON: StringName = &""
#const TEXT_EDIT: StringName = &""

const MINIMUM: StringName = &"Minimum"
const MAXIUMUM: StringName = &"Maximum"
const STEP: StringName = &"Step"
const ROUNDED: StringName = &"Rounded"

const OPTIONS: StringName = &"Options"

const ELEMENT_TYPES: Array[StringName] = [
	&"Analyzer",
	&"Image",
	&"Post-Processing",
	&"Shader",
	&"Shape",
	&"Text"
]

var _element_controls: Dictionary[int, Dictionary]

func get_element_controls() -> Dictionary[int, Dictionary]:
	return _element_controls.duplicate_deep(Resource.DeepDuplicateMode.DEEP_DUPLICATE_ALL)

# Example:
# {UID: {"Layer": {"NODE": NUMERICAL, "MIN": 0, "MAX": 10}}}

func set_property_configurations(
	p_element_uid: int,
	p_property: StringName,
	p_configurations: Dictionary[StringName, Variant]
) -> Error:
	var property_dict: Dictionary[StringName, Dictionary]
	
	if p_configurations.is_empty():
		return ERR_INVALID_PARAMETER
	
	if _element_controls.has(p_element_uid):
		property_dict = _element_controls.get(p_element_uid)
	
	if not property_dict.set(p_property, p_configurations):
		return FAILED
	if not _element_controls.set(p_element_uid, property_dict):
		return FAILED
	
	return OK

func get_property_configurations(p_element_uid: int, p_property: StringName) -> Dictionary[StringName, Variant]:
	var ret: Dictionary[StringName, Dictionary] = {}
	
	if not _element_controls.has(p_element_uid):
		return ret
		
	ret = _element_controls.get(p_element_uid)
	if not ret.has(p_property):
		ret = {}
		return ret
	
	return ret.get(p_property)
