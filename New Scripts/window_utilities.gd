# Oscillody
# Copyright (C) 2025-present Akosmo

# window_utilities.gd is part of Oscillody.
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

signal window_size_changed

var _window_size: Vector2i
var _subviewport: SubViewport

func _ready() -> void:
	_window_size = DisplayServer.window_get_size()
	DisplayServer.window_set_min_size(DisplayServer.window_get_size())

func _process(_delta: float) -> void:
	if _window_size != DisplayServer.window_get_size():
		_window_size = DisplayServer.window_get_size()
		window_size_changed.emit()

func get_window_size() -> Vector2i:
	return _window_size

func set_subviewport(p_subviewport: SubViewport) -> void:
	_subviewport = p_subviewport

func get_subviewport() -> SubViewport:
	return _subviewport
