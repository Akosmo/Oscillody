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

const _MASTER_PROPERTY_KEY: StringName = &"Master"
const _PRESET_PROPERTY_KEY: StringName = &"Preset"

#var _files_property_container_script: Script = preload("res://New Scripts/files_property_container.gd")

@onready var _save_preset_button: Button = %SavePresetButton
@onready var _open_preset_folder_button: Button = %OpenPresetFolderButton
@onready var _import_audio_button: Button = %ImportAudioButton
@onready var _export_video_button: Button = %ExportVideoButton

@onready var _import_audio_file_dialog: FileDialog = %ImportAudioFileDialog

@onready var _preset_container: BasicPropertyContainer = %PresetContainer
@onready var _master_container: BasicPropertyContainer = %MasterContainer

func _ready() -> void:
	if _connect_signals():
		printerr("Could not connect signals.")
	
	#_master_container.set_script(_files_property_container_script)
	_master_container.set_control_node(BasicPropertyContainer.ControlNode.OPTION_BUTTON)
	_master_container.set_property_key(_MASTER_PROPERTY_KEY)
	_master_container.set_property_value(&"")
	_master_container.set_reset_value(&"")

func _connect_signals() -> Error:
	#if AudioManager.new_audio_imported.connect(_on_new_audio_imported):
		#return ERR_INVALID_PARAMETER
	
	if _save_preset_button.pressed.connect(_on_save_pressed):
		return ERR_INVALID_PARAMETER
	if _open_preset_folder_button.pressed.connect(_on_open_folder_pressed):
		return ERR_INVALID_PARAMETER
	if _import_audio_button.pressed.connect(_on_import_audio_pressed):
		return ERR_INVALID_PARAMETER
	if _import_audio_file_dialog.files_selected.connect(_on_audio_files_selected):
		return ERR_INVALID_PARAMETER
	if _master_container.property_value_changed.connect(_on_property_value_changed):
		return ERR_INVALID_PARAMETER
	if _master_container.property_reset_pressed.connect(_on_property_reset_pressed):
		return ERR_INVALID_PARAMETER
	if _export_video_button.pressed.connect(_on_export_video_pressed):
		return ERR_INVALID_PARAMETER
	
	return OK

func _update_stream_list() -> void:
	_master_container.option_button.clear()
	
	# TODO: Maybe set on audio to stream conversion, and only read master name in this function.
	# One reason to not do it, is that maybe the user doesn't want to change master all the time.
	var stream_dict: Dictionary[StringName, AudioStream] = AudioManager.get_streams()
	if not stream_dict.is_empty():
		for stream: StringName in stream_dict.keys():
			_master_container.option_button.add_item(String(stream))
		
		_master_container.option_button.select(_master_container.option_button.get_item_count() - 1)
		
		var master_name: StringName = stream_dict.keys()[stream_dict.size() - 1]
		_master_container.set_property_value(master_name)
		AudioManager.set_master_name(master_name)
	else:
		_master_container.set_property_value(&"")
		AudioManager.set_master_name(&"")
	
	AudioManager.notify_updated_streams(true)

func _on_save_pressed() -> void:
	pass

func _on_open_folder_pressed() -> void:
	pass

func _on_import_audio_pressed() -> void:
	_import_audio_file_dialog.popup()

# TEST: Selecting files with the same name.
func _on_audio_files_selected(p_paths: PackedStringArray) -> void:
	if AudioManager.import_audio_files(p_paths):
		return
	_update_stream_list()

func _on_property_value_changed(p_property_key: StringName, p_property_value: Variant) -> void:
	if p_property_key == _MASTER_PROPERTY_KEY:
		AudioManager.set_master_name(p_property_value as StringName)
		AudioManager.notify_updated_streams(false)

func _on_property_reset_pressed(p_property_key: StringName) -> void:
	if p_property_key == _MASTER_PROPERTY_KEY:
		AudioManager.clear_streams()
		_update_stream_list()
		AudioManager.notify_cleared_streams()

func _on_export_video_pressed() -> void:
	pass
