# Oscillody
# Copyright (C) 2025-present Akosmo

# debug_utilities.gd is part of Oscillody.
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

signal freeze_visualizer_changed(p_frozen: bool)

var _audio_players: Dictionary[StringName, AudioStreamPlayer]

var _element_next_unique_id: int
var _element_container_count: int
var _element_properties_container_count: int
var _element_canvas_count: int
var _analyzer_waveform_samples_per_second: int
#var _real_time_audio_data: RealTimeAudioData
#var _shader_time_maximum_speed: float
#var _noise_value: Vector2

var _log_text: String

func _ready() -> void:
	_audio_players = {}
	
	_element_next_unique_id = 0
	_element_container_count = 0
	_element_properties_container_count = 0
	_element_canvas_count = 0
	var real_time_audio_data: RealTimeAudioData = RealTimeAudioData.new()
	_analyzer_waveform_samples_per_second = real_time_audio_data.get_samples_per_second()

func set_audio_players(p_value: Dictionary[StringName, AudioStreamPlayer]) -> void:
	_audio_players = p_value

func get_audio_players() -> Dictionary[StringName, AudioStreamPlayer]:
	return _audio_players

func set_element_next_unique_id(p_value: int) -> void:
	_element_next_unique_id = p_value

func get_element_next_unique_id() -> int:
	return _element_next_unique_id

func set_element_container_count(p_value: int) -> void:
	_element_container_count = p_value

func get_element_container_count() -> int:
	return _element_container_count

func set_element_properties_container_count(p_value: int) -> void:
	_element_properties_container_count = p_value

func get_element_properties_container_count() -> int:
	return _element_properties_container_count

func set_element_canvas_count(p_value: int) -> void:
	_element_canvas_count = p_value

func get_element_canvas_count() -> int:
	return _element_canvas_count

func get_analyzer_waveform_samples_per_second() -> int:
	return _analyzer_waveform_samples_per_second

func set_log_text(p_value: String) -> void:
	_log_text += p_value + "\n"

func get_log_text() -> String:
	return _log_text
