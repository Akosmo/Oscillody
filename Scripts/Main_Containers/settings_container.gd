# Oscillody
# Copyright (C) 2025-present Akosmo

# settings_container.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

extends PanelContainer

@onready var _input_device_container: BasicPropertyContainer = %InputDeviceContainer
@onready var _output_device_container: BasicPropertyContainer = %OutputDeviceContainer
@onready var _export_resolution_container: BasicPropertyContainer = %ExportResolutionContainer
@onready var _ffmpeg_path_container: BasicPropertyContainer = %FFmpegPathContainer
@onready var _delete_temporary_files_container: BasicPropertyContainer = %DeleteTemporaryFilesContainer
@onready var _sync_element_shake_container: BasicPropertyContainer = %SyncElementShakeContainer
@onready var _sync_shader_time_container: BasicPropertyContainer = %SyncShaderTimeContainer
@onready var _debug_panel_container: BasicPropertyContainer = %DebugPanelContainer

func _ready() -> void:
	_input_device_container.set_control_node(BasicPropertyContainer.ControlNode.OPTION_BUTTON)
	_input_device_container.set_property_key(SettingsManager.SN_INPUT_DEVICE)
	for input_device: String in AudioServer.get_input_device_list():
		_input_device_container.option_button.add_item(input_device)
	_input_device_container.set_property_value_with_node(SettingsManager.get_input_device())
	_input_device_container.property_value_changed.connect(_on_property_value_changed)
	
	_output_device_container.set_control_node(BasicPropertyContainer.ControlNode.OPTION_BUTTON)
	_output_device_container.set_property_key(SettingsManager.SN_OUTPUT_DEVICE)
	for output_device: String in AudioServer.get_output_device_list():
		_output_device_container.option_button.add_item(output_device)
	_output_device_container.set_property_value_with_node(SettingsManager.get_output_device())
	_output_device_container.property_value_changed.connect(_on_property_value_changed)
	
	_export_resolution_container.set_control_node(BasicPropertyContainer.ControlNode.OPTION_BUTTON)
	_export_resolution_container.set_property_key(SettingsManager.SN_EXPORT_RESOLUTION)
	for resolution: StringName in SettingsManager.EXPORT_RESOLUTIONS:
		_export_resolution_container.option_button.add_item(resolution)
	_export_resolution_container.set_property_value_with_node(SettingsManager.get_export_resolution())
	_export_resolution_container.property_value_changed.connect(_on_property_value_changed)
	
	_ffmpeg_path_container.set_control_node(BasicPropertyContainer.ControlNode.BUTTON)
	_ffmpeg_path_container.set_property_key(SettingsManager.SN_FFMPEG_PATH)
	_ffmpeg_path_container.use_file_dialog()
	_ffmpeg_path_container.button.set_text("Select Path")
	_ffmpeg_path_container.button.set_disabled(not SettingsManager.get_ffmpeg_path().is_empty())
	_ffmpeg_path_container.file_dialog.set_filters(PackedStringArray(["*.exe ; Supported Format"]))
	_ffmpeg_path_container.set_property_value_with_node(SettingsManager.get_ffmpeg_path())
	_ffmpeg_path_container.set_reset_value("")
	_ffmpeg_path_container.property_value_changed.connect(_on_property_value_changed)
	
	_delete_temporary_files_container.set_control_node(BasicPropertyContainer.ControlNode.CHECK_BUTTON)
	_delete_temporary_files_container.set_property_key(SettingsManager.SN_DELETE_TEMPORARY_FILES)
	_delete_temporary_files_container.set_property_value_with_node(SettingsManager.get_delete_temporary_files())
	_delete_temporary_files_container.set_reset_value(true)
	_delete_temporary_files_container.property_value_changed.connect(_on_property_value_changed)
	
	_sync_element_shake_container.set_control_node(BasicPropertyContainer.ControlNode.BUTTON)
	_sync_element_shake_container.set_property_key(SettingsManager.SN_SYNC_ELEMENT_SHAKE)
	_sync_element_shake_container.use_file_dialog(false)
	_sync_element_shake_container.button.set_text("Sync")
	_sync_element_shake_container.property_value_changed.connect(_on_property_value_changed)
	
	_sync_shader_time_container.set_control_node(BasicPropertyContainer.ControlNode.BUTTON)
	_sync_shader_time_container.set_property_key(SettingsManager.SN_SYNC_SHADER_TIME)
	_sync_shader_time_container.use_file_dialog(false)
	_sync_shader_time_container.button.set_text("Sync")
	_sync_shader_time_container.property_value_changed.connect(_on_property_value_changed)
	
	_debug_panel_container.set_control_node(BasicPropertyContainer.ControlNode.CHECK_BUTTON)
	_debug_panel_container.set_property_key(SettingsManager.SN_DEBUG_PANEL)
	_debug_panel_container.set_property_value_with_node(SettingsManager.get_debug_panel())
	_debug_panel_container.property_value_changed.connect(_on_property_value_changed)

func _on_property_value_changed(p_property_key: StringName, p_property_value: Variant) -> void:
	CustomLogger.log_normal(
		"Changing \"{setting}\" to {value}".format({"setting": p_property_key, "value": p_property_value})
	)
	
	match p_property_key:
		SettingsManager.SN_INPUT_DEVICE:
			if SettingsManager.set_input_device(str(p_property_value)):
				CustomLogger.log_error("Could not set input device.")
		SettingsManager.SN_OUTPUT_DEVICE:
			if SettingsManager.set_output_device(str(p_property_value)):
				CustomLogger.log_error("Could not set output device.")
		SettingsManager.SN_EXPORT_RESOLUTION:
			var new_value: String = ""
			for resolution: String in SettingsManager.EXPORT_RESOLUTIONS:
				if resolution.containsn(str(p_property_value)):
					new_value = resolution
			if SettingsManager.set_export_resolution(new_value):
				CustomLogger.log_error("Could not set export resolution.")
		SettingsManager.SN_FFMPEG_PATH:
			if SettingsManager.set_ffmpeg_path(str(p_property_value)):
				CustomLogger.log_error(
					"Could not set FFmpeg path. File should be named \"ffmpeg.exe\"."
				)
				_ffmpeg_path_container.set_property_value_with_node(_ffmpeg_path_container.get_reset_value())
			else:
				_ffmpeg_path_container.button.set_disabled(true)
		SettingsManager.SN_DELETE_TEMPORARY_FILES:
			SettingsManager.set_delete_temporary_files(p_property_value as bool)
		SettingsManager.SN_SYNC_ELEMENT_SHAKE:
			SettingsManager.request_sync_element_shake()
		SettingsManager.SN_SYNC_SHADER_TIME:
			SettingsManager.request_sync_shader_time()
		SettingsManager.SN_DEBUG_PANEL:
			SettingsManager.set_debug_panel(p_property_value)
