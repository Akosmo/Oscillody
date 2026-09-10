# Oscillody
# Copyright (C) 2025-present Akosmo

# element_shakable.gd is part of Oscillody.
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
class_name ElementShakable
extends ElementReactive

const SN_SHAKE_AMPLITUDE: StringName = &"_shake_amplitude"
const SN_SHAKE_AMPLITUDE_COMPENSATION: StringName = &"(shake)_amplitude_compensation"
const SN_SHAKE_FREQUENCY: StringName = &"_shake_frequency"
const SN_SHAKE_SEED: StringName = &"_shake_seed"
const SN_SHAKE_AMPLITUDE_REACTION: StringName = &"(shake)_amplitude_reaction"
const SN_SHAKE_FREQUENCY_REACTION: StringName = &"(shake)_frequency_reaction"

var _shake_amplitude: float = 0.0
var _shake_amplitude_compensation: bool = true
var _shake_frequency: float = 0.0
var _shake_seed: int = 0
var _shake_amplitude_reaction: float = 0.0
var _shake_frequency_reaction: float = 0.0

func set_shake_amplitude(p_value: float) -> void:
	_shake_amplitude = p_value
	property_changed.emit(SN_SHAKE_AMPLITUDE)

func get_shake_amplitude() -> float:
	return _shake_amplitude

func set_shake_amplitude_compensation(p_value: bool) -> void:
	_shake_amplitude_compensation = p_value
	property_changed.emit(SN_SHAKE_AMPLITUDE_COMPENSATION)

func get_shake_amplitude_compensation() -> bool:
	return _shake_amplitude_compensation

func set_shake_frequency(p_value: float) -> void:
	_shake_frequency = p_value
	property_changed.emit(SN_SHAKE_FREQUENCY)

func get_shake_frequency() -> float:
	return _shake_frequency

func set_shake_seed(p_value: int) -> void:
	_shake_seed = p_value
	property_changed.emit(SN_SHAKE_SEED)

func get_shake_seed() -> int:
	return _shake_seed

func set_shake_amplitude_reaction(p_value: float) -> void:
	_shake_amplitude_reaction = p_value
	property_changed.emit(SN_SHAKE_AMPLITUDE_REACTION)

func get_shake_amplitude_reaction() -> float:
	return _shake_amplitude_reaction

func set_shake_frequency_reaction(p_value: float) -> void:
	_shake_frequency_reaction = p_value
	property_changed.emit(SN_SHAKE_FREQUENCY_REACTION)

func get_shake_frequency_reaction() -> float:
	return _shake_frequency_reaction

@abstract func get_property_dictionary() -> Dictionary[StringName, Variant]

@abstract func get_method_dictionary() -> Dictionary[StringName, StringName]
