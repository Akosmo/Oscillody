# Oscillody
# Copyright (C) 2025-present Akosmo

# element_canvas.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

# TODO: Update as needed.

@abstract
class_name ElementCanvas
extends CanvasLayer
## Abstract class used by [CanvasLayer] nodes holding data from [Element]s.
##
## This class is used to actually display Elements in the visualizer.
## Data mostly comes from a given [Element]. The [CanvasLayer] node may instantiate child nodes
## for specific functionality, such as drawing waveforms with [Node2D], using [method CanvasItem._draw].

@abstract func _ready() -> void

@abstract func get_element() -> Element

@abstract func _on_element_property_changed(p_property: StringName) -> void
