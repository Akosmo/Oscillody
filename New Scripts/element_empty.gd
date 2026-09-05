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

func get_property_dictionary() -> Dictionary[StringName, Variant]:
	var _property_dictionary: Dictionary[StringName, Variant] = {
		SN_NAME: _element_name,
		SN_TYPE: _type,
		SN_LAYER: _layer,
		SN_VISIBILITY: _visibility
	}
	
	return _property_dictionary

func get_method_dictionary() -> Dictionary[StringName, StringName]:
	var _method_dictionary: Dictionary[StringName, StringName] = {
		SN_NAME: set_element_name.get_method(),
		SN_TYPE: set_type.get_method(),
		SN_LAYER: set_layer.get_method(),
		SN_VISIBILITY: set_visibility.get_method()
	}
	
	return _method_dictionary
