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

var audio_manager: AudioManager = AudioManager.new()

var files_property_container_script: Script = preload("res://New Scripts/files_property_container.gd")

@onready var save_preset_button: Button = %SavePresetButton
@onready var refresh_preset_button: Button = %RefreshPresetButton
@onready var delete_preset_button: Button = %DeletePresetButton
@onready var open_preset_folder_button: Button = %OpenPresetFolderButton
@onready var import_audio_button: Button = %ImportAudioButton
@onready var export_video_button: Button = %ExportVideoButton

@onready var import_audio_file_dialog: FileDialog = %ImportAudioFileDialog

@onready var preset_container: PanelContainer = %PresetContainer
@onready var master_container: PanelContainer = %MasterContainer

func _ready() -> void:
	var err_signals: Error = _connect_all_signals()
	if err_signals:
		printerr("Could not connect signals.")
	
	master_container.set_script(files_property_container_script)
	@warning_ignore("unsafe_property_access")
	master_container.audio_manager = audio_manager

func _connect_all_signals() -> Error:
	var err: Error = save_preset_button.connect("pressed", _on_save_pressed)
	if err:
		return FAILED
	err = refresh_preset_button.connect("pressed", _on_refresh_pressed)
	if err:
		return FAILED
	err = delete_preset_button.connect("pressed", _on_delete_pressed)
	if err:
		return FAILED
	err = open_preset_folder_button.connect("pressed", _on_open_folder_pressed)
	if err:
		return FAILED
	err = import_audio_button.connect("pressed", _on_import_audio_pressed)
	if err:
		return FAILED
	err = export_video_button.connect("pressed", _on_export_video_pressed)
	if err:
		return FAILED
	
	err = import_audio_file_dialog.connect("files_selected", _on_audio_files_selected)
	if err:
		return FAILED
	
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
	import_audio_file_dialog.popup()

func _on_audio_files_selected(p_paths: PackedStringArray) -> void:
	audio_manager.audio_files_changed.emit(p_paths)
	
	@warning_ignore("unsafe_method_access")
	master_container.update_audio_list()

func _on_export_video_pressed() -> void:
	pass
