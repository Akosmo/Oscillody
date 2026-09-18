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

func get_properties() -> Dictionary[StringName, Variant]:
	var _property_dictionary: Dictionary[StringName, Variant] = {
		SN_ELEMENT_NAME: _element_name,
		SN_ELEMENT_TYPE: _element_type,
		SN_ELEMENT_LAYER: _element_layer,
		SN_ELEMENT_VISIBILITY: _element_visibility
	}
	
	return _property_dictionary

func get_setters() -> Dictionary[StringName, StringName]:
	var _setter_dictionary: Dictionary[StringName, StringName] = {
		SN_ELEMENT_NAME: set_element_name.get_method(),
		SN_ELEMENT_TYPE: set_element_type.get_method(),
		SN_ELEMENT_LAYER: set_element_layer.get_method(),
		SN_ELEMENT_VISIBILITY: set_element_visibility.get_method()
	}
	
	return _setter_dictionary
