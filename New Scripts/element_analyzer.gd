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
extends ElementWithAudio

enum AnalyzerType {
	WAVEFORM,
	SPECTRUM
}

const ANALYZER_TYPES: Array[StringName] = [
	&"Waveform",
	&"Spectrum"
]

const SN_ANALYZER_TYPE: StringName = &"Analyzer_Type"

const SN_ANALYZER_BEGIN_X_POSITION: StringName = &"(Analyzer)_Begin_X_Position"
const SN_ANALYZER_BEGIN_Y_POSITION: StringName = &"(Analyzer)_Begin_Y_Position"
const SN_ANALYZER_END_X_POSITION: StringName = &"(Analyzer)_End_X_Position"
const SN_ANALYZER_END_Y_POSITION: StringName = &"(Analyzer)_End_Y_Position"
const SN_ANALYZER_HEIGHT: StringName = &"(Analyzer)_Height"

const SN_WAVEFORM_SAMPLE_HISTORY_LENGTH: StringName = &"(Waveform)_Sample_History_Length"
const SN_WAVEFORM_THICKNESS: StringName = &"(Waveform)_Thickness"
const SN_WAVEFORM_COLOR: StringName = &"(Waveform)_Color"
const SN_WAVEFORM_ANTIALIASING: StringName = &"(Waveform)_Antialiasing"

var _analyzer_type: AnalyzerType = AnalyzerType.WAVEFORM

var _analyzer_begin_x_position: float = 0.0
var _analyzer_begin_y_position: float = 0.5
var _analyzer_end_x_position: float = 1.0
var _analyzer_end_y_position: float = 0.5
var _analyzer_height: float = 0.5

var _waveform_sample_history_length: int = 4
var _waveform_thickness: float = 2.0
var _waveform_color: Color = Color.WHITE
var _waveform_antialiasing: bool = true

func set_analyzer_type(p_value: AnalyzerType) -> void:
	_analyzer_type = p_value
	property_changed.emit(SN_ANALYZER_TYPE)

func get_analyzer_type() -> AnalyzerType:
	return _analyzer_type

func set_analyzer_begin_x_position(p_value: float) -> void:
	_analyzer_begin_x_position = p_value
	property_changed.emit(SN_ANALYZER_BEGIN_X_POSITION)

func get_analyzer_begin_x_position() -> float:
	return _analyzer_begin_x_position

func set_analyzer_begin_y_position(p_value: float) -> void:
	_analyzer_begin_y_position = p_value
	property_changed.emit(SN_ANALYZER_BEGIN_Y_POSITION)

func get_analyzer_begin_y_position() -> float:
	return _analyzer_begin_y_position

func set_analyzer_end_x_position(p_value: float) -> void:
	_analyzer_end_x_position = p_value
	property_changed.emit(SN_ANALYZER_END_X_POSITION)

func get_analyzer_end_x_position() -> float:
	return _analyzer_end_x_position

func set_analyzer_end_y_position(p_value: float) -> void:
	_analyzer_end_y_position = p_value
	property_changed.emit(SN_ANALYZER_END_Y_POSITION)

func get_analyzer_end_y_position() -> float:
	return _analyzer_end_y_position

func set_analyzer_height(p_value: float) -> void:
	_analyzer_height = p_value
	property_changed.emit(SN_ANALYZER_HEIGHT)

func get_analyzer_height() -> float:
	return _analyzer_height

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

func get_properties() -> Dictionary[StringName, Variant]:
	var _property_dictionary: Dictionary[StringName, Variant] = {
		SN_ELEMENT_NAME: _element_name,
		SN_ELEMENT_TYPE: _element_type,
		SN_ELEMENT_LAYER: _element_layer,
		SN_ELEMENT_VISIBILITY: _element_visibility,
		SN_AUDIO_SOURCE: _audio_source,
		SN_ANALYZER_TYPE: _analyzer_type,
		SN_ANALYZER_BEGIN_X_POSITION: _analyzer_begin_x_position,
		SN_ANALYZER_BEGIN_Y_POSITION: _analyzer_begin_y_position,
		SN_ANALYZER_END_X_POSITION: _analyzer_end_x_position,
		SN_ANALYZER_END_Y_POSITION: _analyzer_end_y_position,
		SN_ANALYZER_HEIGHT: _analyzer_height,
		SN_WAVEFORM_SAMPLE_HISTORY_LENGTH: _waveform_sample_history_length,
		SN_WAVEFORM_THICKNESS: _waveform_thickness,
		SN_WAVEFORM_COLOR: _waveform_color,
		SN_WAVEFORM_ANTIALIASING: _waveform_antialiasing
	}
	
	return _property_dictionary

func get_setters() -> Dictionary[StringName, StringName]:
	var _setter_dictionary: Dictionary[StringName, StringName] = {
		SN_ELEMENT_NAME: set_element_name.get_method(),
		SN_ELEMENT_TYPE: set_element_type.get_method(),
		SN_ELEMENT_LAYER: set_element_layer.get_method(),
		SN_ELEMENT_VISIBILITY: set_element_visibility.get_method(),
		SN_AUDIO_SOURCE: set_audio_source.get_method(),
		SN_ANALYZER_TYPE: set_analyzer_type.get_method(),
		SN_ANALYZER_BEGIN_X_POSITION: set_analyzer_begin_x_position.get_method(),
		SN_ANALYZER_BEGIN_Y_POSITION: set_analyzer_begin_y_position.get_method(),
		SN_ANALYZER_END_X_POSITION: set_analyzer_end_x_position.get_method(),
		SN_ANALYZER_END_Y_POSITION: set_analyzer_end_y_position.get_method(),
		SN_ANALYZER_HEIGHT: set_analyzer_height.get_method(),
		SN_WAVEFORM_SAMPLE_HISTORY_LENGTH: set_waveform_sample_history_length.get_method(),
		SN_WAVEFORM_THICKNESS: set_waveform_thickness.get_method(),
		SN_WAVEFORM_COLOR: set_waveform_color.get_method(),
		SN_WAVEFORM_ANTIALIASING: set_waveform_antialiasing.get_method()
	}
	
	return _setter_dictionary
