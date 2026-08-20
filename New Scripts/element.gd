# Oscillody
# Copyright (C) 2025-present Akosmo

# element.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

@abstract
class_name Element
extends CanvasLayer

#var element_manager: ElementManager
#var element_uid: int
#var element_name: String
#var element_type: ElementManager.ElementType

@abstract func setup_element() -> void

	#var property_dict: Dictionary[StringName, Variant] = element_manager.get_element_properties(element_uid)
	#for key: StringName in property_dict.keys():
		#match key:
			#element_manager.NAME:
				#element_name = property_dict.get(key)
			#element_manager.TYPE:
				#element_type = property_dict.get(key)
