# Oscillody
# Copyright (C) 2025-present Akosmo

# property_configurations_numerical.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name PropertyConfigurationsNumerical
extends PropertyConfigurations

const MINIMUM: StringName = &"Minimum"
const MAXIMUM: StringName = &"Maximum"
const STEP: StringName = &"Step"
const ROUNDED: StringName = &"Rounded"

var _minimum: float:
	set = set_minimum,
	get = get_minimum
var _maximum: float:
	set = set_maximum,
	get = get_maximum
var _step: float:
	set = set_step,
	get = get_step
var _rounded: bool:
	set = set_rounded,
	get = get_rounded

func set_minimum(p_value: float) -> void:
	_minimum = p_value

func get_minimum() -> float:
	return _minimum

func set_maximum(p_value: float) -> void:
	_maximum = p_value

func get_maximum() -> float:
	return _maximum

func set_step(p_value: float) -> void:
	_step = p_value

func get_step() -> float:
	return _step

func set_rounded(p_value: bool) -> void:
	_rounded = p_value

func get_rounded() -> bool:
	return _rounded
