# Oscillody
# Copyright (C) 2025-present Akosmo

# files_container.gd is part of Oscillody.
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

#var _files_property_container_script: Script = preload("res://New Scripts/files_property_container.gd")

@onready var _preset_container: BasicPropertyContainer = %PresetContainer
@onready var _save_preset_button: Button = %SavePresetButton
@onready var _open_preset_folder_button: Button = %OpenPresetFolderButton

@onready var _import_audio_button: Button = %ImportAudioButton
@onready var _import_audio_file_dialog: FileDialog = %ImportAudioFileDialog

@onready var _export_video_button: Button = %ExportVideoButton
@onready var _export_video_file_dialog: FileDialog = %ExportVideoFileDialog

@onready var _master_container: BasicPropertyContainer = %MasterContainer

func _ready() -> void:
	if _connect_signals():
		CustomLogger.log_critical_error("Could not connect signals in FilesContainer.")
	
	_preset_container.set_control_node(BasicPropertyContainer.ControlNode.OPTION_BUTTON)
	_preset_container.set_property_key(FileManager.SN_PRESET)
	var preset_list: PackedStringArray = FileManager.get_preset_list()
	if not preset_list.is_empty():
		for preset: String in preset_list:
			_preset_container.option_button.add_item(preset)
		#if preset_list.has("Default"):
			#_preset_container.set_property_value_with_node("Default")
			#FileManager.load_preset("Default")
		#else:
			#_preset_container.set_property_value_with_node(preset_list[0])
			#FileManager.load_preset(preset_list[0])
	_preset_container.set_property_value_with_node("")
	_preset_container.set_reset_value("")
	_preset_container.option_button.set_allow_reselect(true)
	
	#_master_container.set_script(_files_property_container_script)
	_master_container.set_control_node(BasicPropertyContainer.ControlNode.OPTION_BUTTON)
	_master_container.set_property_key(FileManager.SN_MASTER)
	_master_container.set_property_value(&"")
	_master_container.set_reset_value(&"")
	
	#_export_video_button.set_disabled(OS.has_feature("debug") or AudioManager.get_streams().is_empty())
	_export_video_button.set_disabled(
		SettingsManager.get_ffmpeg_path().is_empty() or AudioManager.get_stream_names().is_empty()
	)

func _connect_signals() -> Error:
	#if AudioManager.new_audio_imported.connect(_on_new_audio_imported):
		#return ERR_INVALID_PARAMETER
	
	if _preset_container.property_value_changed.connect(_on_property_value_changed):
		return Error.ERR_INVALID_PARAMETER
	if _save_preset_button.pressed.connect(_on_save_pressed):
		return Error.ERR_INVALID_PARAMETER
	if _open_preset_folder_button.pressed.connect(_on_open_folder_pressed):
		return Error.ERR_INVALID_PARAMETER
	if _import_audio_button.pressed.connect(_on_import_audio_pressed):
		return Error.ERR_INVALID_PARAMETER
	if _import_audio_file_dialog.files_selected.connect(_on_audio_files_selected):
		return Error.ERR_INVALID_PARAMETER
	if _master_container.property_value_changed.connect(_on_property_value_changed):
		return Error.ERR_INVALID_PARAMETER
	if _master_container.property_reset_pressed.connect(_on_property_reset_pressed):
		return Error.ERR_INVALID_PARAMETER
	if _export_video_button.pressed.connect(_on_export_video_pressed):
		return Error.ERR_INVALID_PARAMETER
	if _export_video_file_dialog.file_selected.connect(_on_saving_video_file):
		return Error.ERR_INVALID_PARAMETER
	
	if AudioManager.stream_list_updated.connect(_on_stream_list_updated):
		return Error.ERR_INVALID_PARAMETER
	if FileManager.preset_saved.connect(_on_preset_saved):
		return Error.ERR_INVALID_PARAMETER
	if FileManager.canceled_preset_change.connect(_on_canceled_preset_changed):
		return Error.ERR_INVALID_PARAMETER
	
	return Error.OK

func _update_stream_list() -> void:
	_master_container.option_button.clear()
	
	var stream_names: Array[StringName] = AudioManager.get_stream_names().values()
	if not stream_names.is_empty():
		for stream_name: StringName in stream_names:
			_master_container.option_button.add_item(String(stream_name))
		
		var master_name: StringName = stream_names[-1]
		#_master_container.option_button.select(-1)
		#
		#var master_name: StringName = stream_dict.keys()[-1]
		#_master_container.set_property_value(master_name)
		_master_container.set_property_value_with_node(master_name)
		AudioManager.set_master_name(master_name)
	else:
		_master_container.set_property_value(&"")
		AudioManager.set_master_name(&"")
	
	AudioManager.notify_updated_streams(true)

func _on_save_pressed() -> void:
	PopupManager.request_popup(PopupManager.PopupType.PRESET)

func _on_open_folder_pressed() -> void:
	var directory: String = FileManager.get_directory(FileManager.AppDirectory.PRESETS)
	if OS.shell_open(directory):
		CustomLogger.log_error("Could not open folder: " + directory)

func _on_import_audio_pressed() -> void:
	_import_audio_file_dialog.popup()

func _on_audio_files_selected(p_paths: PackedStringArray) -> void:
	for path: String in p_paths:
		if (
			AudioManager.get_stream_names().keys().has(StringName(path)) or
			AudioManager.get_stream_names().values().has(StringName(path.get_file().get_basename()))
		):
			CustomLogger.log_error("{path} is already imported.".format({"path": path}))
			continue
		elif AudioManager.import_audio_files(path):
			continue
	
	_update_stream_list()

func _on_property_value_changed(p_property_key: StringName, p_property_value: Variant) -> void:
	match p_property_key:
		FileManager.SN_PRESET:
			if FileManager.get_unsaved_changes():
				FileManager.set_desired_preset(p_property_value)
				PopupManager.request_popup(PopupManager.PopupType.UNSAVED_CHANGES)
				return
			if FileManager.load_preset(p_property_value):
				CustomLogger.log_error("Could not change preset.")
		FileManager.SN_MASTER:
			if String(p_property_value).is_empty():
				CustomLogger.log_warning("Empty property value for master. Streams will be cleared.")
				return
			AudioManager.set_master_name(p_property_value as StringName)
			AudioManager.notify_updated_streams(false)

func _on_property_reset_pressed(p_property_key: StringName) -> void:
	match p_property_key:
		FileManager.SN_PRESET:
			if FileManager.get_unsaved_changes():
				FileManager.set_desired_preset("")
				PopupManager.request_popup(PopupManager.PopupType.UNSAVED_CHANGES)
				return
			if FileManager.load_preset(""):
				CustomLogger.log_error("Could not reset preset.")
		FileManager.SN_MASTER:
			CustomLogger.log_normal("Clearing streams.")
			AudioManager.clear_streams()
			_update_stream_list()
			AudioManager.notify_cleared_streams()

func _on_export_video_pressed() -> void:
	CustomLogger.log_normal("Selecting export path for video.")
	
	if SettingsManager.get_ffmpeg_path().is_empty():
		CustomLogger.log_error("Cannot export video without a valid FFmpeg path. Check the Settings tab.")
		return
	
	_export_video_file_dialog.popup()

func _on_saving_video_file(p_path: String) -> void:
	MovieWriterUtilities.initialize_export(p_path)

func _on_stream_list_updated() -> void:
	#if not OS.has_feature("debug"):
	_export_video_button.set_disabled(AudioManager.get_stream_names().is_empty())

func _on_preset_saved(p_preset_name: String) -> void:
	_preset_container.option_button.clear()
	var preset_list: PackedStringArray = FileManager.get_preset_list()
	for preset: String in preset_list:
		_preset_container.option_button.add_item(preset)
	_preset_container.set_property_value_with_node(p_preset_name)

func _on_canceled_preset_changed() -> void:
	_preset_container.set_property_value_with_node(FileManager.get_selected_preset())
