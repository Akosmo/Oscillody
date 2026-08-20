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

# TODO: Delete this class?

class_name ElementEmpty
extends Element

var element_manager: ElementManager
var element_uid: int
var element_name: String
var element_type: ElementManager.ElementType
var element_layer: int
var element_visibility: bool

func setup_element() -> void:
	var property_dict: Dictionary[StringName, Variant] = element_manager.get_element_properties(element_uid)
	for key: StringName in property_dict.keys():
		match key:
			element_manager.NAME:
				element_name = property_dict.get(key)
				set_name(element_name + "_" + str(element_uid))
			element_manager.TYPE:
				element_type = property_dict.get(key)
			element_manager.LAYER:
				element_layer = property_dict.get(key)
				set_layer(element_layer)
			element_manager.VISIBILITY:
				element_visibility = property_dict.get(key)
				set_visible(element_visibility)
