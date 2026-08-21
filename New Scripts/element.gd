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

#@abstract func setup_element() -> void

@abstract func _change_property(p_property: StringName, p_new_element: bool = false) -> void

@abstract func _on_element_property_changed(p_element_uid: int, p_property: StringName) -> void
