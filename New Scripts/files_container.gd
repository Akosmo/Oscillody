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

var _files_property_container_script: Script = preload("res://New Scripts/files_property_container.gd")

@onready var _save_preset_button: Button = %SavePresetButton
@onready var _refresh_preset_button: Button = %RefreshPresetButton
@onready var _delete_preset_button: Button = %DeletePresetButton
@onready var _open_preset_folder_button: Button = %OpenPresetFolderButton
@onready var _import_audio_button: Button = %ImportAudioButton
@onready var _export_video_button: Button = %ExportVideoButton

@onready var _import_audio_file_dialog: FileDialog = %ImportAudioFileDialog

@onready var _preset_container: PanelContainer = %PresetContainer
@onready var _master_container: PanelContainer = %MasterContainer

func _ready() -> void:
	if _connect_all_signals():
		printerr("Could not connect signals.")
		return
	
	_master_container.set_script(_files_property_container_script)

func _connect_all_signals() -> Error:
	if _save_preset_button.pressed.connect(_on_save_pressed):
		return ERR_INVALID_PARAMETER
	if _refresh_preset_button.pressed.connect(_on_refresh_pressed):
		return ERR_INVALID_PARAMETER
	if _delete_preset_button.pressed.connect(_on_delete_pressed):
		return ERR_INVALID_PARAMETER
	if _open_preset_folder_button.pressed.connect(_on_open_folder_pressed):
		return ERR_INVALID_PARAMETER
	if _import_audio_button.pressed.connect(_on_import_audio_pressed):
		return ERR_INVALID_PARAMETER
	if _export_video_button.pressed.connect(_on_export_video_pressed):
		return ERR_INVALID_PARAMETER
	
	if _import_audio_file_dialog.files_selected.connect(_on_audio_files_selected):
		return ERR_INVALID_PARAMETER
	
	return OK

func _on_save_pressed() -> void:
	pass

func _on_refresh_pressed() -> void:
	pass

func _on_delete_pressed() -> void:
	pass

func _on_open_folder_pressed() -> void:
	pass

func _on_import_audio_pressed() -> void:
	_import_audio_file_dialog.popup()

# TEST: Selecting files with the same name.
func _on_audio_files_selected(p_paths: PackedStringArray) -> void:
	if AudioManager.test_and_import_audio_files(p_paths):
		return

func _on_export_video_pressed() -> void:
	pass
