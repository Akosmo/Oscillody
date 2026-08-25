# Oscillody
# Copyright (C) 2025-present Akosmo

# element_empty.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ElementEmpty
extends Element

var element_uid: int

var _property_dictionary: Dictionary[StringName, Variant]

var _element_name: String
var _element_type: ElementManager.ElementType
var _element_layer: int
var _element_visibility: bool

func _ready() -> void:
	_property_dictionary = ElementManager.get_element_properties(element_uid)
	
	_setup_properties()
	
	for property_key: StringName in _property_dictionary.keys():
		_change_property(property_key, true)
	
	if ElementManager.element_property_changed.connect(_on_element_property_changed):
		return printerr("Could not connect signal.")

func _setup_properties() -> void:
	for property_key: StringName in _property_dictionary:
		match property_key:
			ElementManager.NAME:
				var configs: Dictionary[StringName, Variant]
				configs.set(ElementUIHelper.CONTROL_NODE, ElementUIHelper.ControlNode.LINE_EDIT)
				configs.set(ElementUIHelper.DEFAULT_VALUE, "Element_" + str(element_uid))
				if ElementUIHelper.set_property_configurations(element_uid, property_key, configs):
					printerr("Could not set property configurations.")
			ElementManager.TYPE:
				var configs: Dictionary[StringName, Variant]
				configs.set(ElementUIHelper.CONTROL_NODE, ElementUIHelper.ControlNode.OPTION_BUTTON)
				# TEST: Check if this works...
				configs.set(ElementUIHelper.DEFAULT_VALUE, ElementManager.ElementType.EMPTY)
				if ElementUIHelper.set_property_configurations(element_uid, property_key, configs):
					printerr("Could not set property configurations.")
			ElementManager.LAYER:
				var configs: Dictionary[StringName, Variant]
				configs.set(ElementUIHelper.CONTROL_NODE, ElementUIHelper.ControlNode.NUMERICAL)
				if ElementUIHelper.set_property_configurations(element_uid, property_key, configs):
					printerr("Could not set property configurations.")
			ElementManager.VISIBILITY:
				var configs: Dictionary[StringName, Variant]
				configs.set(ElementUIHelper.CONTROL_NODE, ElementUIHelper.ControlNode.CHECK_BUTTON)
				configs.set(ElementUIHelper.DEFAULT_VALUE, true)
				if ElementUIHelper.set_property_configurations(element_uid, property_key, configs):
					printerr("Could not set property configurations.")
			_:
				printerr("Property not matched.")

func _change_property(p_property: StringName, p_new_element: bool = false) -> void:
	match p_property:
		ElementManager.NAME:
			_element_name = _property_dictionary.get(p_property)
			set_name(_element_name + "_" + str(element_uid))
		ElementManager.TYPE:
			if p_new_element:
				_element_type = _property_dictionary.get(p_property)
			else:
				queue_free()
		ElementManager.LAYER:
			_element_layer = _property_dictionary.get(p_property)
			set_layer(_element_layer)
		ElementManager.VISIBILITY:
			_element_visibility = _property_dictionary.get(p_property)
			set_visible(_element_visibility)
			set_process(_element_visibility)

func _on_element_property_changed(p_element_uid: int, p_property: StringName) -> void:
	if p_element_uid == element_uid:
		_change_property(p_property)
