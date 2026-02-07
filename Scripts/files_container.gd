# Oscillody
# Copyright (C) 2025-present Akosmo

# This file is part of Oscillody. Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

extends ScrollContainer

# This script handles audio file importing and video exporting.

#region NODES ##################################

@onready var master_file_dialog: FileDialog = %MasterFileDialog
@onready var stem_1_file_dialog: FileDialog = %Stem1FileDialog
@onready var stem_2_file_dialog: FileDialog = %Stem2FileDialog
@onready var stem_3_file_dialog: FileDialog = %Stem3FileDialog
@onready var stem_4_file_dialog: FileDialog = %Stem4FileDialog

@onready var copy_master_button: Button = %CopyMasterButton
@onready var clear_audio_button: Button = %ClearAudioButton

@onready var filenames: Label = %Filenames

@onready var ffmpeg_file_dialog: FileDialog = %FFmpegFileDialog
@onready var ffmpeg_s_value: Label = %FFmpegSValue
@onready var export_file_dialog: FileDialog = %ExportFileDialog

@onready var ffmpeg_status: HBoxContainer = %FFmpegStatus

@onready var export_value: Button = %ExportValue

@onready var ui_anim_player: AnimationPlayer = %UIAnimPlayer

#endregion ##################################

#region FILES CONTAINER VARIABLES ##################################

const EXPORT_SCENE = "res://Scenes/visualizer_screen.tscn"

#endregion ##################################

#region PATHS ##################################

var master_filename: String = "NOT IMPORTED"
var stem_1_filename: String = "NOT IMPORTED"
var stem_2_filename: String = "NOT IMPORTED"
var stem_3_filename: String = "NOT IMPORTED"
var stem_4_filename: String = "NOT IMPORTED"

#endregion ##################################

func _ready() -> void:
	master_file_dialog.set_filters(PackedStringArray(["*.mp3, *.wav, *.ogg ; Supported Formats"]))
	stem_1_file_dialog.set_filters(PackedStringArray(["*.mp3, *.wav, *.ogg ; Supported Formats"]))
	stem_2_file_dialog.set_filters(PackedStringArray(["*.mp3, *.wav, *.ogg ; Supported Formats"]))
	stem_3_file_dialog.set_filters(PackedStringArray(["*.mp3, *.wav, *.ogg ; Supported Formats"]))
	stem_4_file_dialog.set_filters(PackedStringArray(["*.mp3, *.wav, *.ogg ; Supported Formats"]))
	ffmpeg_file_dialog.set_filters(PackedStringArray(["*.exe ; EXE Files"]))
	export_file_dialog.set_filters(PackedStringArray(["*.mp4 ; MP4 Video"]))
	
	MainUtils.successfully_set_to_stream.connect(enable_copying_and_clearing)
	
	display_filenames()
	
	update_ffmpeg_status()

func enable_copying_and_clearing() -> void:
	if GlobalVariables.master_audio_path:
		copy_master_button.disabled = false
		export_value.disabled = false
	if (GlobalVariables.master_audio_path or
	GlobalVariables.stem_1_audio_path or
	GlobalVariables.stem_2_audio_path or
	GlobalVariables.stem_3_audio_path or
	GlobalVariables.stem_4_audio_path):
		clear_audio_button.disabled = false

func display_filenames(reset: bool = false) -> void:
	if reset:
		master_filename = "NOT IMPORTED"
		stem_1_filename = "NOT IMPORTED"
		stem_2_filename = "NOT IMPORTED"
		stem_3_filename = "NOT IMPORTED"
		stem_4_filename = "NOT IMPORTED"
	
	filenames.text = "Master: {mf}\nStem 1: {s1f}\nStem 2: {s2f}\nStem 3: {s3f}\nStem 4: {s4f}".format(
		{"mf": master_filename,
		"s1f": stem_1_filename,
		"s2f": stem_2_filename,
		"s3f": stem_3_filename,
		"s4f": stem_4_filename
		}
	)

func update_ffmpeg_status() -> void:
	if MainUtils.ffmpeg_valid:
		ffmpeg_s_value.text = "DEFINED"
		ffmpeg_status.add_theme_constant_override("separation", 56)
	else:
		ffmpeg_status.add_theme_constant_override("separation", 18)
		ffmpeg_s_value.text = "NOT DEFINED"

# Despite the odd way of doing this, and where it's placed, this is the easiest way to check if a file is valid.
func check_if_valid(path: String) -> bool:
	if path != "":
		if path.get_extension() == "mp3":
			var stream: AudioStreamMP3 = AudioStreamMP3.load_from_file(path)
			if stream == null:
				MainUtils.logger("Imported audio could not be set as stream.", true, true)
				return false
			else:
				return true
		elif path.get_extension() == "wav":
				var stream: AudioStreamWAV = AudioStreamWAV.load_from_file(path)
				if stream == null:
					MainUtils.logger(
						"Imported audio could not be set as stream. \
If it's WAVE, make sure it has no more than 2 channels, and prefer 16bit depth",
						true,
						true
						)
					return false
				else:
					return true
		elif path.get_extension() == "ogg":
				var stream: AudioStreamOggVorbis = AudioStreamOggVorbis.load_from_file(path)
				if stream == null:
					MainUtils.logger(
						"Imported audio could not be set as stream. If it's Ogg, make sure it's a Vorbis \
audio in the Ogg file container.", true, true)
					return false
				else:
					return true
		else:
			MainUtils.logger("Audio path does not contain valid audio extension.", true, true)
			return false
	else:
		MainUtils.logger("Audio path is empty.", true, true)
		return false

#region FILES BUILT-IN SIGNAL FUNCTIONS ##################################

func _on_import_master_button_pressed() -> void:
	master_file_dialog.popup()

func _on_master_file_dialog_file_selected(path: String) -> void:
	if check_if_valid(path):
		GlobalVariables.master_audio_path = path
		master_filename = path.get_file().get_basename()
		display_filenames()
	else:
		return

func _on_import_stem_1_button_pressed() -> void:
	stem_1_file_dialog.popup()

func _on_stem_1_file_dialog_file_selected(path: String) -> void:
	if check_if_valid(path):
		GlobalVariables.stem_1_audio_path = path
		stem_1_filename = path.get_file().get_basename()
		display_filenames()
	else:
		return

func _on_import_stem_2_button_pressed() -> void:
	stem_2_file_dialog.popup()

func _on_stem_2_file_dialog_file_selected(path: String) -> void:
	if check_if_valid(path):
		GlobalVariables.stem_2_audio_path = path
		stem_2_filename = path.get_file().get_basename()
		display_filenames()
	else:
		return

func _on_import_stem_3_button_pressed() -> void:
	stem_3_file_dialog.popup()

func _on_stem_3_file_dialog_file_selected(path: String) -> void:
	if check_if_valid(path):
		GlobalVariables.stem_3_audio_path = path
		stem_3_filename = path.get_file().get_basename()
		display_filenames()
	else:
		return

func _on_import_stem_4_button_pressed() -> void:
	stem_4_file_dialog.popup()

func _on_stem_4_file_dialog_file_selected(path: String) -> void:
	if check_if_valid(path):
		GlobalVariables.stem_4_audio_path = path
		stem_4_filename = path.get_file().get_basename()
		display_filenames()
	else:
		return

func _on_copy_master_button_pressed() -> void:
	MainUtils.copy_master.emit()
	stem_1_filename = master_filename
	stem_2_filename = master_filename
	stem_3_filename = master_filename
	stem_4_filename = master_filename
	display_filenames()

func _on_clear_audio_button_pressed() -> void:
	MainUtils.audio_files_cleared.emit()
	copy_master_button.disabled = true
	clear_audio_button.disabled = true
	export_value.disabled = true
	display_filenames(true)

func _on_ffmpeg_path_button_pressed() -> void:
	ffmpeg_file_dialog.popup()

func _on_ffmpeg_file_dialog_file_selected(path: String) -> void:
	if not path.get_file().contains("ffmpeg.exe"):
		if MainUtils.ffmpeg_valid:
			MainUtils.logger(
				"There's already a valid FFmpeg executable selected.",
				true
				)
			return
		else:
			MainUtils.logger(
				"Selected FFmpeg executable is not valid. Make sure you've selected the right file.",
				true
				)
			return
	MainUtils.ffmpeg_path = path
	update_ffmpeg_status()

func _on_export_mp4_button_pressed() -> void:
	export_file_dialog.popup()

func _on_export_file_dialog_file_selected(path: String) -> void:
	if OS.has_feature("editor"):
		MainUtils.logger("Exporting is disabled while in the editor.", true)
		return
	
	if MainUtils.ffmpeg_path == "":
		MainUtils.logger("The FFmpeg executable must be selected in order to export your video.", true)
		return
	
	if not FileAccess.file_exists(MainUtils.ffmpeg_path):
		MainUtils.logger("FFmpeg path is not longer valid. Reselect it.", true)
		MainUtils.ffmpeg_path = ""
		update_ffmpeg_status()
		return
	
	if GlobalVariables.master_audio_path == "":
		MainUtils.logger("Attempted to render without a master track.", true, true)
		return
	
	var check_folder: DirAccess = DirAccess.open(MainUtils.temp_path)
	if check_folder == null:
			MainUtils.logger("Could not open " \
			+ MainUtils.temp_path + ". Error: " + error_string(DirAccess.get_open_error()), true, true)
			return
	
	var png_filename: String = path.get_file()
	MainUtils.video_filename = png_filename
	MainUtils.video_output_full_path = path.get_base_dir() + "/" + MainUtils.video_filename
	if ".mp4" in png_filename:
		png_filename = png_filename.replace(".mp4", "")
	if ".png" in png_filename:
		png_filename = png_filename.replace(".png", "")
	
	if MainUtils.free_up_space:
		var contents_in_temp: PackedStringArray = DirAccess.get_directories_at(MainUtils.temp_path)
		for folder: String in contents_in_temp:
			# DirAccess.remove_absolute() doesn't work here for some reason...
			var err: Error = OS.move_to_trash(MainUtils.temp_path + folder + "/")
			await get_tree().create_timer(0.5).timeout
			if err:
				MainUtils.logger("Could not clear the Temp folder, clear it \
manually. Error: " + error_string(err), true, true)
				break
			else:
				continue
		MainUtils.logger("Temp folder should be clear, unless error occurred.")
	else:
		MainUtils.logger("Existing PNG sequences not deleted since user chose not to delete them.")
	
	var frame_save_dir: String = MainUtils.temp_path + png_filename
	if not DirAccess.dir_exists_absolute(frame_save_dir):
		var err: Error = DirAccess.make_dir_absolute(frame_save_dir)
		if err:
			MainUtils.logger("Could not make folder for PNGs. Error: " + error_string(err), true, true)
			return
	else:
		var err_1: Error = DirAccess.remove_absolute(frame_save_dir)
		if err_1:
			MainUtils.logger("Could not remove existing (" + frame_save_dir + "). Error: " + error_string(err_1), true, true)
			return
		var err_2: Error = DirAccess.make_dir_absolute(frame_save_dir)
		if err_2:
			MainUtils.logger("Could not make new (" + frame_save_dir + "). Error: " + error_string(err_2), true, true)
			return
	
	MainUtils.save_settings()
	GlobalVariables.save_preset(GlobalVariables.RENDER_PRESET_FILENAME, GlobalVariables.render_info_path)
	GlobalVariables.save_audio()
	
	MainUtils.process_id = OS.create_process(
		OS.get_executable_path(),
		[EXPORT_SCENE,
		"--path", frame_save_dir,
		"--write-movie", png_filename + ".png",
		"--resolution", "1280x720",
		"--disable-vsync", "true",
		"--fixed-fps", "60",
		"--",
		"--load_preset=" + GlobalVariables.RENDER_PRESET_FILENAME
		])
	
#endregion ##################################
