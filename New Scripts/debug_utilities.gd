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
	# We log system info here because it has information for several things (audio, video, etc), and
	# because this is the last autoload to be called. It's also easier to have all of this logged in a
	# single place.
	_log_system_info()
	
	_audio_players = {}
	
	_element_next_unique_id = 0
	_element_container_count = 0
	_element_properties_container_count = 0
	_element_canvas_count = 0
	var real_time_audio_data: RealTimeAudioData = RealTimeAudioData.new()
	_analyzer_waveform_samples_per_second = real_time_audio_data.get_samples_per_second()

func freeze_visualizer(p_frozen: bool) -> void:
	freeze_visualizer_changed.emit(p_frozen)

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

func _log_system_info() -> void:
	var info: PackedStringArray = ["System Info"]
	info.append("OS: " + OS.get_name() + " " + OS.get_version_alias())
	info.append("Monitor count: " + str(DisplayServer.get_screen_count()))
	info.append("Main monitor resolution: " + str(DisplayServer.screen_get_size()))
	info.append("Main monitor refresh rate: " + str(DisplayServer.screen_get_refresh_rate()))
	info.append("Current rendering driver: " + RenderingServer.get_current_rendering_driver_name())
	info.append("Current rendering method: " + RenderingServer.get_current_rendering_method())
	info.append(
		"Graphics: {device_name} (Driver: {driver_name}, Version: {version})".format(
			{
				"device_name": RenderingServer.get_video_adapter_name(),
				"driver_name": OS.get_video_adapter_driver_info()[0],
				"version": OS.get_video_adapter_driver_info()[1]
			}
		)
	)
	info.append("CPU: " + OS.get_processor_name() + " (" + str(OS.get_processor_count()) + " threads)")
	var memory_info: int = OS.get_memory_info().get("physical")
	if memory_info > 0:
		info.append("Memory: " + String.humanize_size(memory_info))
	info.append(
		"Audio: {driver} ({out_sample_rate} Hz output, {in_sample_rate} Hz input, {channels} channels, \
{latency} ms latency)".format(
			{
				"driver": AudioServer.get_driver_name(),
				"out_sample_rate": AudioServer.get_mix_rate(),
				"in_sample_rate": AudioServer.get_input_mix_rate(),
				"channels": AudioServer.get_bus_channels(0) * 2,
				"latency": roundi(AudioServer.get_output_latency() * 1000.0)
			}
		)
	)
	CustomLogger.log_normal(String("\n").join(info))
