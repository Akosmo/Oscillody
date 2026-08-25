# Oscillody
# Copyright (C) 2025-present Akosmo

# settings_manager.gd is part of Oscillody.
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

signal setup_requested
signal slider_preference_changed

enum ContainerProperty {
	INPUT_DEVICE,
	OUTPUT_DEVICE,
	EXPORT_RESOLUTION,
	THEME,
	SLIDER_SWITCH
}

const RESOLUTION_720P: StringName = &"720p"
const RESOLUTION_1080P: StringName = &"1080p"
const RESOLUTION_1440P: StringName = &"1440p"

var _input_device: String
var _output_device: String
var _export_resolution: String
var _theme: String
var _slider_preference: bool

func _init() -> void:
	_input_device = AudioServer.get_input_device()
	_output_device = AudioServer.get_output_device()
	_export_resolution = RESOLUTION_1080P
	_theme = "" # TODO: Add.
	_slider_preference = false

func set_input_device(p_device: String) -> Error:
	if p_device not in AudioServer.get_input_device_list():
		return FAILED
	
	AudioServer.set_input_device(p_device)
	
	return OK

func get_input_device() -> String:
	return _input_device

func set_output_device(p_device: String) -> Error:
	if p_device not in AudioServer.get_output_device_list():
		return FAILED
	
	AudioServer.set_output_device(p_device)
	
	return OK

func get_output_device() -> String:
	return _output_device

func set_export_resolution(p_resolution: String) -> Error:
	if p_resolution.is_empty() or not p_resolution.ends_with("p"):
		return FAILED
	if p_resolution.remove_char(p_resolution.length() - 1).is_valid_int():
		return FAILED
	
	_export_resolution = p_resolution
	
	return OK

func get_export_resolution() -> String:
	return _export_resolution

func set_app_theme(p_theme: String) -> Error:
	if p_theme.is_empty():
		return FAILED
	# TODO: Check if it's in a list.
	
	return OK

func enable_sliders(p_enable: bool) -> void:
	_slider_preference = p_enable
	slider_preference_changed.emit()

func notify_setup_request() -> void:
	setup_requested.emit()

func are_sliders_enabled() -> bool:
	return _slider_preference
