# Oscillody
# Copyright (C) 2025-present Akosmo

# noise_utilities.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ShaderUtilities
extends RefCounted

const INCREMENT: float = 0.02

var _shader_time: float
#var _offset: float

func _init() -> void:
	_shader_time = 2.0 # Defaulting to the absolute maximum of `SN_SHADER_TIME_OFFSET`.

func get_increment_constant() -> float:
	return INCREMENT

func reset_time(p_offset: float) -> void:
	_shader_time = 2.0 + p_offset

func get_shader_time() -> float:
	#_shader_time += INCREMENT
	return _shader_time

func increment_shader_time(p_increment: float) -> void:
	_shader_time += p_increment

#func set_shader_time_offset(p_offset: float) -> void:
#	_offset = p_offset
#	_shader_time += _
