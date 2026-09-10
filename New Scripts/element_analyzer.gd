# Oscillody
# Copyright (C) 2025-present Akosmo

# element_analyzer.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ElementAnalyzer
extends Element

enum AnalyzerType {
	WAVEFORM,
	SPECTRUM
}

const ANALYZER_TYPES: Array[StringName] = [
	&"Waveform",
	&"Spectrum"
]

const SN_ANALYZER_TYPE: StringName = &"_analyzer_type"
const SN_AUDIO_SOURCE: StringName = &"_audio_source"

const SN_BEGIN_X_POSITION: StringName = &"_begin_x_position"
const SN_BEGIN_Y_POSITION: StringName = &"_begin_y_position"
const SN_END_X_POSITION: StringName = &"_end_x_position"
const SN_END_Y_POSITION: StringName = &"_end_y_position"
const SN_HEIGHT: StringName = &"_height"

const SN_WAVEFORM_SAMPLE_HISTORY_LENGTH: StringName = &"(waveform)_sample_history_length"
const SN_WAVEFORM_THICKNESS: StringName = &"(waveform)_thickness"
const SN_WAVEFORM_COLOR: StringName = &"(waveform)_color"
const SN_WAVEFORM_ANTIALIASING: StringName = &"(waveform)_antialiasing"

var _analyzer_type: AnalyzerType = AnalyzerType.WAVEFORM
var _audio_source: StringName = &""

var _begin_x_position: float = 0.0
var _begin_y_position: float = 0.5
var _end_x_position: float = 1.0
var _end_y_position: float = 0.5
var _height: float = 0.5

var _waveform_sample_history_length: int = 4
var _waveform_thickness: float = 2.0
var _waveform_color: Color = Color.WHITE
var _waveform_antialiasing: bool = true

func set_analyzer_type(p_value: AnalyzerType) -> void:
	_analyzer_type = p_value
	property_changed.emit(SN_ANALYZER_TYPE)

func get_analyzer_type() -> AnalyzerType:
	return _analyzer_type

func set_audio_source(p_value: StringName) -> void:
	_audio_source = p_value
	property_changed.emit(SN_AUDIO_SOURCE)

func get_audio_source() -> StringName:
	return _audio_source

func set_begin_x_position(p_value: float) -> void:
	_begin_x_position = p_value
	property_changed.emit(SN_BEGIN_X_POSITION)

func get_begin_x_position() -> float:
	return _begin_x_position

func set_begin_y_position(p_value: float) -> void:
	_begin_y_position = p_value
	property_changed.emit(SN_BEGIN_Y_POSITION)

func get_begin_y_position() -> float:
	return _begin_y_position

func set_end_x_position(p_value: float) -> void:
	_end_x_position = p_value
	property_changed.emit(SN_END_X_POSITION)

func get_end_x_position() -> float:
	return _end_x_position

func set_end_y_position(p_value: float) -> void:
	_end_y_position = p_value
	property_changed.emit(SN_END_Y_POSITION)

func get_end_y_position() -> float:
	return _end_y_position

func set_height(p_value: float) -> void:
	_height = p_value
	property_changed.emit(SN_HEIGHT)

func get_height() -> float:
	return _height

func set_waveform_sample_history_length(p_value: int) -> void:
	_waveform_sample_history_length = p_value
	property_changed.emit(SN_WAVEFORM_SAMPLE_HISTORY_LENGTH)

func get_waveform_sample_history_length() -> int:
	return _waveform_sample_history_length

func set_waveform_thickness(p_value: float) -> void:
	_waveform_thickness = p_value
	property_changed.emit(SN_WAVEFORM_THICKNESS)

func get_waveform_thickness() -> float:
	return _waveform_thickness

func set_waveform_color(p_value: Color) -> void:
	_waveform_color = p_value
	property_changed.emit(SN_WAVEFORM_COLOR)

func get_waveform_color() -> Color:
	return _waveform_color

func set_waveform_antialiasing(p_value: bool) -> void:
	_waveform_antialiasing = p_value
	property_changed.emit(SN_WAVEFORM_ANTIALIASING)

func get_waveform_antialiasing() -> bool:
	return _waveform_antialiasing

func get_property_dictionary() -> Dictionary[StringName, Variant]:
	var _property_dictionary: Dictionary[StringName, Variant] = {
		SN_NAME: _element_name,
		SN_TYPE: _type,
		SN_LAYER: _layer,
		SN_VISIBILITY: _visibility,
		SN_ANALYZER_TYPE: _analyzer_type,
		SN_AUDIO_SOURCE: _audio_source,
		SN_BEGIN_X_POSITION: _begin_x_position,
		SN_BEGIN_Y_POSITION: _begin_y_position,
		SN_END_X_POSITION: _end_x_position,
		SN_END_Y_POSITION: _end_y_position,
		SN_HEIGHT: _height,
		SN_WAVEFORM_SAMPLE_HISTORY_LENGTH: _waveform_sample_history_length,
		SN_WAVEFORM_THICKNESS: _waveform_thickness,
		SN_WAVEFORM_COLOR: _waveform_color,
		SN_WAVEFORM_ANTIALIASING: _waveform_antialiasing
	}
	
	return _property_dictionary

func get_method_dictionary() -> Dictionary[StringName, StringName]:
	var _method_dictionary: Dictionary[StringName, StringName] = {
		SN_NAME: set_element_name.get_method(),
		SN_TYPE: set_type.get_method(),
		SN_LAYER: set_layer.get_method(),
		SN_VISIBILITY: set_visibility.get_method(),
		SN_ANALYZER_TYPE: set_analyzer_type.get_method(),
		SN_AUDIO_SOURCE: set_audio_source.get_method(),
		SN_BEGIN_X_POSITION: set_begin_x_position.get_method(),
		SN_BEGIN_Y_POSITION: set_begin_y_position.get_method(),
		SN_END_X_POSITION: set_end_x_position.get_method(),
		SN_END_Y_POSITION: set_end_y_position.get_method(),
		SN_HEIGHT: set_height.get_method(),
		SN_WAVEFORM_SAMPLE_HISTORY_LENGTH: set_waveform_sample_history_length.get_method(),
		SN_WAVEFORM_THICKNESS: set_waveform_thickness.get_method(),
		SN_WAVEFORM_COLOR: set_waveform_color.get_method(),
		SN_WAVEFORM_ANTIALIASING: set_waveform_antialiasing.get_method()
	}
	
	return _method_dictionary
