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
## Manager class that handles settings.
##
## This class handles settings such as audio devices and export resolution.

## Emitted when a property container for a setting property is ready to be properly set up.
signal setup_requested
## Emitted when requesting all [ElementShakable] instances
## to call [method NoiseUtilities.reset_noise_scroll].
signal sync_element_shake_requested
signal sync_shader_time_requested
signal debug_visibility_changed

const SN_INPUT_DEVICE: StringName = &"(Settings)_Input_Device"
const SN_OUTPUT_DEVICE: StringName = &"(Settings)_Output_Device"
const SN_EXPORT_RESOLUTION: StringName = &"(Settings)_Export_Resolution"
const SN_FFMPEG_PATH: StringName = &"(Settings)_FFmpeg_Path"
const SN_DELETE_TEMPORARY_FILES: StringName = &"(Settings)_Delete_Temporary_Files"
const SN_SYNC_ELEMENT_SHAKE: StringName = &"(Settings)_Sync_Element_Shake"
const SN_SYNC_SHADER_TIME: StringName = &"(Settings)_Sync_Shader_Time"
const SN_DEBUG_PANEL: StringName = &"(Settings)_Debug_Panel"
const SN_UPDATE_LAST_CHECKED_AT: StringName = &"(Settings)_Update_Last_Checked_At"

const EXPORT_RESOLUTIONS: PackedStringArray = [
	"720p",
	"1080p",
	"1440p"
]

var _input_device: String
var _output_device: String
var _export_resolution: String
var _ffmpeg_path: String
var _delete_temporary_files: bool
var _debug_panel: bool
var _update_last_checked_at: int

func _init() -> void:
	_input_device = AudioServer.get_input_device()
	_output_device = AudioServer.get_output_device()
	_export_resolution = EXPORT_RESOLUTIONS[1]
	_ffmpeg_path = ""
	_delete_temporary_files = true
	_debug_panel = false
	_update_last_checked_at = 0

func _ready() -> void:
	# Settings are loaded in `movie_writer_utilities` if writing movie,
	# since resolution needs to be set in an `_init()` function.
	# `load_settings()` can only be called after this class finished its `_init()` call.
	if not OS.has_feature("movie"):
		if FileManager.load_settings():
			CustomLogger.log_error("Could not load settings. Using default values.")

## Sets the input device to the given [param p_device].
func set_input_device(p_device: String) -> Error:
	if p_device not in AudioServer.get_input_device_list():
		return Error.FAILED
	
	AudioServer.set_input_device(p_device)
	
	return Error.OK

## Returns the current input device.
func get_input_device() -> String:
	return _input_device

## Sets the output device to the given [param p_device].
func set_output_device(p_device: String) -> Error:
	if p_device not in AudioServer.get_output_device_list():
		return Error.FAILED
	
	AudioServer.set_output_device(p_device)
	
	return Error.OK

## Returns the current output device.
func get_output_device() -> String:
	return _output_device

## Sets the export resolution to the given [param p_resolution].
func set_export_resolution(p_resolution: String) -> Error:
	if p_resolution not in EXPORT_RESOLUTIONS:
		return Error.FAILED
	
	_export_resolution = p_resolution
	
	if OS.has_feature("movie"):
		var resolution_vector: Vector2i = Vector2i(1920, 1080)
		match p_resolution:
			"720p":
				resolution_vector = Vector2i(1280, 720)
			"1080p":
				pass
			"1440p":
				resolution_vector = Vector2i(2560, 1440)
		
		ProjectSettings.set_setting("display/window/size/viewport_width", resolution_vector.x)
		ProjectSettings.set_setting("display/window/size/viewport_height", resolution_vector.y)
		DisplayServer.window_set_flag(DisplayServer.WindowFlags.WINDOW_FLAG_RESIZE_DISABLED, true)
	
	return Error.OK

## Returns the currently set export resolution.
func get_export_resolution() -> String:
	return _export_resolution

func set_ffmpeg_path(p_path: String) -> Error:
	if not p_path.is_empty():
		if p_path.get_file() != "ffmpeg.exe":
			return Error.ERR_FILE_BAD_PATH
		if not FileAccess.file_exists(p_path):
			return Error.ERR_FILE_NOT_FOUND
	
	_ffmpeg_path = p_path
	
	return Error.OK

func get_ffmpeg_path() -> String:
	return _ffmpeg_path

func set_delete_temporary_files(p_value: bool) -> void:
	_delete_temporary_files = p_value

func get_delete_temporary_files() -> bool:
	return _delete_temporary_files

func request_sync_element_shake() -> void:
	sync_element_shake_requested.emit()

func request_sync_shader_time() -> void:
	sync_shader_time_requested.emit()

func set_debug_panel(p_enable: bool) -> void:
	_debug_panel = p_enable
	debug_visibility_changed.emit()

func get_debug_panel() -> bool:
	return _debug_panel

func set_update_last_checked_at(p_time: int) -> void:
	_update_last_checked_at = p_time

func get_update_last_checked_at() -> int:
	return _update_last_checked_at

## Emits [signal setup_requested].
func notify_setup_request() -> void:
	setup_requested.emit()

func get_properties() -> Dictionary[StringName, Variant]:
	var _property_dictionary: Dictionary[StringName, Variant] = {
		SN_INPUT_DEVICE: _input_device,
		SN_OUTPUT_DEVICE: _output_device,
		SN_EXPORT_RESOLUTION: _export_resolution,
		SN_FFMPEG_PATH: _ffmpeg_path,
		SN_DELETE_TEMPORARY_FILES: _delete_temporary_files,
		SN_UPDATE_LAST_CHECKED_AT: _update_last_checked_at
	}
	
	return _property_dictionary

func get_setters() -> Dictionary[StringName, StringName]:
	var _setter_dictionary: Dictionary[StringName, StringName] = {
		SN_INPUT_DEVICE: set_input_device.get_method(),
		SN_OUTPUT_DEVICE: set_output_device.get_method(),
		SN_EXPORT_RESOLUTION: set_export_resolution.get_method(),
		SN_FFMPEG_PATH: set_ffmpeg_path.get_method(),
		SN_DELETE_TEMPORARY_FILES: set_delete_temporary_files.get_method(),
		SN_UPDATE_LAST_CHECKED_AT: set_update_last_checked_at.get_method()
	}
	
	return _setter_dictionary

func get_getters() -> Dictionary[StringName, StringName]:
	var _getter_dictionary: Dictionary[StringName, StringName] = {
		SN_INPUT_DEVICE: get_input_device.get_method(),
		SN_OUTPUT_DEVICE: get_output_device.get_method(),
		SN_EXPORT_RESOLUTION: get_export_resolution.get_method(),
		SN_FFMPEG_PATH: get_ffmpeg_path.get_method(),
		SN_DELETE_TEMPORARY_FILES: get_delete_temporary_files.get_method(),
		SN_UPDATE_LAST_CHECKED_AT: get_update_last_checked_at.get_method()
	}
	
	return _getter_dictionary
