# Oscillody
# Copyright (C) 2025-present Akosmo

# element_analyzer.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ElementAnalyzer
extends Element

var element_manager: ElementManager
var element_uid: int
var property_dictionary: Dictionary[StringName, Variant]

var element_name: String
var element_type: ElementManager.ElementType
var element_layer: int
var element_visibility: bool

func setup_element() -> void:
	property_dictionary = element_manager.get_element_properties(element_uid)
	for property_key: StringName in property_dictionary.keys():
		_change_property(property_key, true)
	
	if element_manager.element_property_changed.connect(_on_element_property_changed):
		return printerr("Could not connect signal.")

func _change_property(p_property: StringName, p_new_element: bool = false) -> void:
	match p_property:
		element_manager.NAME:
			element_name = property_dictionary.get(p_property)
			set_name(element_name + "_" + str(element_uid))
		element_manager.TYPE:
			if p_new_element:
				element_type = property_dictionary.get(p_property)
			else:
				queue_free()
		element_manager.LAYER:
			element_layer = property_dictionary.get(p_property)
			set_layer(element_layer)
		element_manager.VISIBILITY:
			element_visibility = property_dictionary.get(p_property)
			set_visible(element_visibility)

func _on_element_property_changed(p_element_uid: int, p_property: StringName) -> void:
	if p_element_uid == element_uid:
		_change_property(p_property)
