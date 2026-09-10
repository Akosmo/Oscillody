# Oscillody
# Copyright (C) 2025-present Akosmo

# element_reactive.gd is part of Oscillody.
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
class_name ElementReactive
extends Element

enum ReactiveSmoothingType {
	BOTH,
	DECAY,
	INTERPOLATION,
	NONE
}

const SMOOTHING_TYPES: Array[StringName] = [
	&"Both",
	&"Decay",
	&"Interpolation",
	&"None"
]

const SN_AUDIO_SOURCE: StringName = &"_audio_source"
const SN_BEGIN_FREQUENCY: StringName = &"_begin_frequency"
const SN_END_FREQUENCY: StringName = &"_end_frequency"
const SN_MINIMUM_DECIBELS: StringName = &"_minimum_decibels"
const SN_SMOOTHING_TYPE: StringName = &"_smoothing_type"
const SN_SMOOTHING_AMOUNT: StringName = &"_smoothing_amount"

var _audio_source: StringName = &""
var _begin_frequency: int = 20
var _end_frequency: int = 80
var _minimum_decibels: int = -25
var _smoothing_type: ReactiveSmoothingType = ReactiveSmoothingType.DECAY
var _smoothing_amount: float = 0.5

func set_audio_source(p_value: StringName) -> void:
	_audio_source = p_value
	property_changed.emit(SN_AUDIO_SOURCE)

func get_audio_source() -> StringName:
	return _audio_source

func set_begin_frequency(p_value: int) -> void:
	_begin_frequency = p_value
	property_changed.emit(SN_BEGIN_FREQUENCY)

func get_begin_frequency() -> int:
	return _begin_frequency

func set_end_frequency(p_value: int) -> void:
	_end_frequency = p_value
	property_changed.emit(SN_END_FREQUENCY)

func get_end_frequency() -> int:
	return _end_frequency

func set_minimum_decibels(p_value: int) -> void:
	_minimum_decibels = p_value
	property_changed.emit(SN_MINIMUM_DECIBELS)

func get_minimum_decibels() -> int:
	return _minimum_decibels

func set_smoothing_type(p_value: ReactiveSmoothingType) -> void:
	_smoothing_type = p_value
	property_changed.emit(SN_SMOOTHING_TYPE)

func get_smoothing_type() -> ReactiveSmoothingType:
	return _smoothing_type

func set_smoothing_amount(p_value: float) -> void:
	_smoothing_amount = p_value
	property_changed.emit(SN_SMOOTHING_AMOUNT)

func get_smoothing_amount() -> float:
	return _smoothing_amount

@abstract func get_property_dictionary() -> Dictionary[StringName, Variant]

@abstract func get_method_dictionary() -> Dictionary[StringName, StringName]
