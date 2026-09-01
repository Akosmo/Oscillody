# Oscillody
# Copyright (C) 2025-present Akosmo

# element_canvas_empty.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ElementCanvasEmpty
extends ElementCanvas

var element: ElementEmpty

func _ready() -> void:
	if element.property_changed.connect(_on_element_property_changed):
		printerr("Could not connect signal.")

func get_element() -> Element:
	return element

func _on_element_property_changed(p_property: StringName) -> void:
	match p_property:
		ElementEmpty.SN_NAME:
			set_name(element.get_element_name() + "_" + str(element.get_unique_id()))
		ElementEmpty.SN_TYPE:
			queue_free()
		ElementEmpty.SN_LAYER:
			set_layer(element.get_layer())
		ElementEmpty.SN_VISIBILITY:
			set_visible(element.get_visibility())
			set_process(element.get_visibility())
