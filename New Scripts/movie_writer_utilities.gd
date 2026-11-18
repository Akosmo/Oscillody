# Oscillody
# Copyright (C) 2025-present Akosmo

# movie_writer_utilities.gd is part of Oscillody.
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

signal export_finished(p_path: String)

var _empty_frames: int
var _total_frames: int

var _temp_path: String
var _save_path: String

var _pipe_stdio: FileAccess
var _pipe_stderr: FileAccess
var _movie_writer_pid: int
var _ffmpeg_pid: int

var _stdio_line: String
var _stderr_line: String

var _total_progress_value: float

var _export_canceled: bool

func _init() -> void:
	if OS.has_feature("movie"):
		if FileManager.load_settings():
			CustomLogger.log_error("Could not load settings. Using default values.")
	else:
		_init_values()

func _process(_p_delta: float) -> void:
	if OS.has_feature("movie"):
		print("progress_value=" + str((Engine.get_frames_drawn() - _empty_frames) / float(_total_frames)))
		return
	
	if _movie_writer_pid >= 0:
		_stdio_line = _pipe_stdio.get_line()
		if _stdio_line.containsn("progress_value="):
			#_total_progress_value = minf(float(_stdio_line.split("=")[1]), 1.0) * 0.8
			_total_progress_value = minf(float(_stdio_line.get_slice("=", 1)), 1.0) * 0.8
		elif _stdio_line.containsn(CustomLogger.MOVIE_WRITER_STRING):
			CustomLogger.log_normal(_stdio_line)
		
		if not OS.is_process_running(_movie_writer_pid):
			var exit_code: int = OS.get_process_exit_code(_movie_writer_pid)
			if exit_code:
				var err_text: String = _pipe_stderr.get_as_text()
				if not err_text.is_empty():
					CustomLogger.log_warning(err_text)
				CustomLogger.log_error(
					"Movie Writer process closed unexpectedly. Error logged (if any). \
Exit code: " + str(exit_code)
				)
			_movie_writer_pid = -1
			if not _export_canceled and exit_code == 0:
				await _launch_ffmpeg()
			else:
				_init_values()
				export_finished.emit("")
	elif _ffmpeg_pid >= 0:
		_stdio_line = _pipe_stdio.get_line()
		if _stdio_line.containsn("frame="):
			_total_progress_value = \
			# current_frame / (total_frames - (frame_rate * time_offset))
			#minf(float(_stdio_line.split("=")[1]) / (float(_total_frames) - (60.0 * 0.98)), 1.0) * 0.2 + 0.8
			minf(float(_stdio_line.get_slice("=", 1)) / (float(_total_frames) - (60.0 * 0.98)), 1.0) * 0.2 + 0.8
		elif _stdio_line == "progress=end":
			if OS.kill(_ffmpeg_pid):
				CustomLogger.log_error("Could not terminate FFmpeg process.")
		
		_stderr_line = _pipe_stderr.get_line()
		if not _stderr_line.is_empty():
			CustomLogger.log_ffmpeg(_stderr_line)
		
		if not OS.is_process_running(_ffmpeg_pid):
			_ffmpeg_pid = -1
			if not _export_canceled:
				CustomLogger.log_normal(
					"Finished merging temporary files into video at {path}".format({"path": _save_path})
				)
				if SettingsManager.get_delete_temporary_files():
					await _delete_temp_files()
				export_finished.emit(_save_path.get_base_dir())
				_init_values()
			else:
				_init_values()
				export_finished.emit("")

func initialize_export(p_path: String) -> void:
	CustomLogger.log_normal("Exporting video to " + p_path)
	
	if p_path.is_empty():
		CustomLogger.log_error("Empty export path.")
		return
	
	if FileManager.check_directory(p_path.get_base_dir()):
		return
	
	if SettingsManager.get_ffmpeg_path().is_empty():
		CustomLogger.log_error("Cannot export video without a valid FFmpeg path. Check the Settings tab.")
		return
	
	if not FileAccess.file_exists(SettingsManager.get_ffmpeg_path()):
		CustomLogger.log_error("FFmpeg path is no longer valid. Reselect it in the Settings tab.")
		return
	
	if AudioManager.get_stream_names().is_empty():
		CustomLogger.log_error("Cannot export video without any imported audio.")
		return
	
	if FileManager.check_directory(FileManager.get_directory(FileManager.AppDirectory.TEMP)):
		return
	
	if FileManager.save_settings():
		return
	
	if FileManager.save_audio_files():
		return
	
	if FileManager.save_preset(FileManager.EXPORT_PRESET_NAME, true):
		return
	
	var path_to_use: String = p_path
	if path_to_use.get_extension() != "mp4":
		if path_to_use.get_extension() == "":
			path_to_use = p_path + ".mp4"
		else:
			path_to_use = p_path.get_basename() + ".mp4"
	
	_save_path = path_to_use
	
	path_to_use = FileManager.get_directory(FileManager.AppDirectory.TEMP).path_join(p_path.get_file())
	
	_temp_path = path_to_use
	
	var process_arguments: PackedStringArray = [
		"--scene", "uid://bo8typ4f1m1v4", # `visualizer.tscn`
		"--write-movie", path_to_use,
		"--disable-vsync",
		"--fixed-fps", "60",
		"--resolution", "1152x648",
		"--",
		"--ffmpeg-path=" + SettingsManager.get_ffmpeg_path()
	]
	CustomLogger.log_normal("Creating a new instance with the arguments: " + str(process_arguments))
	PopupManager.request_popup(PopupManager.PopupType.PROGRESS)
	
	var pipe_dict: Dictionary = OS.execute_with_pipe(OS.get_executable_path(), process_arguments, false)
	if pipe_dict.is_empty():
		CustomLogger.log_error("Failed to create Oscillody instance for video export.")
		_init_values()
		export_finished.emit("")
		return
	
	_pipe_stdio = pipe_dict.get("stdio")
	_pipe_stderr = pipe_dict.get("stderr")
	_movie_writer_pid = pipe_dict.get("pid")
	
	_total_frames = roundi(AudioManager.get_master_duration()) * 60
	CustomLogger.log_normal("Total frames (master duration times frame rate): " + str(_total_frames))

func initialize_nodes() -> Error:
	if not OS.has_feature("movie"):
		return Error.FAILED
	
	if FileManager.load_audio_files():
		CustomLogger.log_error("Could not load audio files to export video. Aborting.")
		return Error.FAILED
	if FileManager.load_preset(FileManager.EXPORT_PRESET_NAME):
		CustomLogger.log_error("Could not load export preset. Aborting.")
		return Error.FAILED
	# Letting some things (such as any present waveforms) load. This will be trimmed for the video later.
	await get_tree().create_timer(1.0).timeout
	AudioManager.request_play_pause()
	
	_empty_frames = Engine.get_frames_drawn()
	_total_frames = roundi(AudioManager.get_master_duration()) * 60
	CustomLogger.log_normal("Empty frame count: " + str(_empty_frames))
	
	return Error.OK

func get_active_process_id() -> int:
	return maxi(_movie_writer_pid, _ffmpeg_pid)

func get_progress_value() -> float:
	return _total_progress_value

func cancel_export() -> void:
	var active_pid: int = get_active_process_id()
	if OS.kill(active_pid):
		CustomLogger.log_error("Could not cancel export. PID: " + str(active_pid))
		return
	
	_export_canceled = true
	
	export_finished.emit("")

func _init_values() -> void:
	# CustomLogger is not available when coming from `_init()`.
	print("Initializing/resetting Movie Writer values.")
	
	_empty_frames = 0
	_total_frames = 0
	
	_temp_path = ""
	_save_path = ""
	
	if _pipe_stdio != null:
		if _pipe_stdio.is_open():
			_pipe_stdio.close()
		_pipe_stdio = null
	
	if _pipe_stderr != null:
		if _pipe_stderr.is_open():
			_pipe_stderr.close()
		_pipe_stderr = null
	
	_movie_writer_pid = -1
	_ffmpeg_pid = -1
	
	_stdio_line = ""
	_stderr_line = ""
	
	_total_progress_value = 0.0
	
	_export_canceled = false

func _launch_ffmpeg() -> void:
	var ffmpeg_arguments: PackedStringArray = [
		"-hide_banner",
		"-progress", "pipe:1",
		"-y",
		"-ss", "00:00:00.98",
		"-i", _temp_path,
		"-ss", "00:00:00.98",
		"-channel_layout:a", "stereo",
		"-i", _temp_path.get_basename() + ".wav",
		"-c:v", "libx264",
		"-c:a", "aac",
		"-b:a", "256k",
		"-ar", "44100",
		"-movflags", "+faststart",
		_save_path
	]
	CustomLogger.log_normal("Creating a new process with the arguments: " + str(ffmpeg_arguments))
	
	var pid: int
	var total_attempts: int = 5
	await get_tree().create_timer(5.0).timeout
	for attempt: int in range(total_attempts):
		CustomLogger.log_normal(
			"Attempt {attempt} at executing FFmpeg for file merge.".format({"attempt": attempt + 1})
		)
		var pipe_dict: Dictionary = OS.execute_with_pipe(
			SettingsManager.get_ffmpeg_path(),
			ffmpeg_arguments,
			false
		)
		if pipe_dict.is_empty():
			CustomLogger.log_error("Failed to create FFmpeg instance.")
			_init_values()
			export_finished.emit("")
			return
		
		_pipe_stdio = pipe_dict.get("stdio")
		_pipe_stderr = pipe_dict.get("stderr")
		pid = pipe_dict.get("pid")
		await get_tree().create_timer(0.5).timeout
		if attempt < total_attempts and (pid < 0 or not OS.is_process_running(pid)):
			if _pipe_stderr != null and _pipe_stderr.is_open():
				CustomLogger.log_warning(
					"Unsuccessful launch of FFmpeg. Error (if any): " + _pipe_stderr.get_as_text()
				)
			CustomLogger.log_warning(
				"Temporary PID (if any): " + str(pid) + " - Process running: " + str(OS.is_process_running(pid))
			)
			continue
		else:
			break
	
	if pid < 0 or (not OS.is_process_running(pid) and not FileAccess.file_exists(_save_path)):
		CustomLogger.log_warning(
			"Temporary PID (if any): " + str(pid) + \
			" - Process running: " + str(OS.is_process_running(pid)) + \
			" - Final file exists: " + str(FileAccess.file_exists(_save_path))
		)
		CustomLogger.log_error("Could not merge temporary files.")
		_init_values()
		export_finished.emit("")
		return
	
	_ffmpeg_pid = pid

func _delete_temp_files() -> void:
	CustomLogger.log_normal("Deleting temporary files.")
	await get_tree().create_timer(2.0).timeout
	for file: String in DirAccess.get_files_at(FileManager.get_directory(FileManager.AppDirectory.TEMP)):
		if DirAccess.remove_absolute(FileManager.get_directory(FileManager.AppDirectory.TEMP).path_join(file)):
			CustomLogger.log_warning("Could not delete temporary files. Attempting to trash them.")
			if OS.move_to_trash(FileManager.get_directory(FileManager.AppDirectory.TEMP).path_join(file)):
				CustomLogger.log_warning("Could not trash temporary files.")

#func _init() -> void:
#	# Settings must be called here, instead of `settings_manager`, since that class needs to finish its
#	# initialization before settings can be loaded. This class is initialized after `file_manager`
#	# and `settings_manager`.
#	if OS.has_feature("movie"):
#		if FileManager.load_settings():
#			CustomLogger.log_error("Could not load settings. Using default values.")
#	else:
#		_reset_values()
#
#func _process(_delta: float) -> void:
#	if not OS.has_feature("movie"):
#		if _temp_process_id >= 0 and _pipe_stdio != null and _pipe_stdio.is_open():
#			if OS.is_process_running(_temp_process_id):
#				_stdio_line = _pipe_stdio.get_line()
#				if _stdio_line.containsn("progress_value="):
#					_total_progress_value = float(_stdio_line.split("=")[1]) * 0.8
#			#_stderr_line = error_string(_pipe_stderr.get_error())
#			#if not _stderr_line.is_empty():
#			#	_stderr_collected_errors += _stderr_line
#		
#		if _temp_process_id >= 0 and not OS.is_process_running(_temp_process_id):
#			CustomLogger.log_normal(
#				"Exit code for export process: " + str(OS.get_process_exit_code(_temp_process_id))
#			)
#			#_stderr_collected_errors += _pipe_stderr.get_as_text() # TODO: Check results.
#			#CustomLogger.log_warning(
#			#	"Standard error output from MovieWriter (if any): " + _stderr_collected_errors
#			#)
#			if _export_canceled or OS.get_process_exit_code(_temp_process_id) != 0:
#				_temp_process_id = -1
#				_export_canceled = false
#				return
#			_temp_process_id = -1
#			await _start_merge_process()
#		
#		if _save_process_id >= 0 and _pipe_stdio != null and _pipe_stdio.is_open():
#			if OS.is_process_running(_save_process_id):
#				_stdio_line = _pipe_stdio.get_line()
#				print(_stdio_line)
#				if _stdio_line.containsn("frame="):
#					_empty_input_count = 0
#					_save_progress_value = float(_stdio_line.split("=")[1]) / (float(_total_frames) - 60.0)
#					_total_progress_value = _save_progress_value * 0.2 + 0.8
#				elif _stdio_line == "progress=end":
#					_empty_input_count = 0
#					_pipe_stdio.close()
#				else:
#					_empty_input_count += 1
#					if _empty_input_count > 60:
#						_pipe_stdio.close()
#				#if _stdio_line.containsn("progress_value="):
#				#	_set_progress_value(float(_stdio_line.split("=")[1]) * 0.8)
#			#_stderr_line = error_string(_pipe_stderr.get_error())
#			#if not _stderr_line.is_empty():
#			#	_stderr_collected_errors += _stderr_line
#		
#		if _save_process_id >= 0 and not OS.is_process_running(_save_process_id):
#			CustomLogger.log_normal(
#				"Exit code for FFmpeg process: " + str(OS.get_process_exit_code(_save_process_id))
#			)
#			#_stderr_collected_errors += _pipe_stderr.get_as_text() # TODO: Check results.
#			#CustomLogger.log_warning(
#			#	"Standard error output from FFmpeg (if any): " + _stderr_collected_errors
#			#)
#			if _export_canceled or OS.get_process_exit_code(_save_process_id) != 0:
#				_save_process_id = -1
#				_export_canceled = false
#				return
#			_save_process_id = -1
#			await _start_deletion_process()
#	else:
#		# Extra 60 frames to account for the 1 second of inactivity at the beginning.
#		_temp_progress_value = Engine.get_frames_drawn() / (AudioManager.get_master_duration() * 60.0 + 60.0)
#		print("progress_value=" + str(_temp_progress_value))
#
#func initialize_export(p_path: String) -> void:
#	CustomLogger.log_normal("Exporting video to " + p_path)
#	
#	if p_path.is_empty():
#		CustomLogger.log_error("Empty export path.")
#		return
#	
#	if not DirAccess.dir_exists_absolute(p_path.get_base_dir()):
#		CustomLogger.log_error("Export path does not exist.")
#		return
#	
#	if SettingsManager.get_ffmpeg_path().is_empty():
#		CustomLogger.log_error("Cannot export video without a valid FFmpeg path. Check the Settings tab.")
#		return
#	
#	if AudioManager.get_stream_names().is_empty():
#		CustomLogger.log_error("Cannot export video without any imported audio.")
#		return
#	
#	if FileManager.save_settings():
#		return
#	
#	if FileManager.save_audio_files():
#		return
#	
#	if FileManager.save_preset(FileManager.EXPORT_PRESET_NAME, true):
#		return
#	
#	if FileManager.check_directory(FileManager.get_directory(FileManager.AppDirectory.TEMP)):
#		CustomLogger.log_error("Could not create a temporary folder for export.")
#		return
#	
#	var path_to_use: String = p_path
#	if path_to_use.get_extension() != "mp4":
#		if path_to_use.get_extension() == "":
#			path_to_use = p_path + ".mp4"
#		else:
#			path_to_use = p_path.get_basename() + ".mp4"
#	
#	_save_path = path_to_use
#	
#	path_to_use = FileManager.get_directory(FileManager.AppDirectory.TEMP).path_join(p_path.get_file())
#	
#	_temp_path = path_to_use
#	
#	var process_arguments: PackedStringArray = [
#		"--scene", "uid://bo8typ4f1m1v4", # `visualizer.tscn`
#		"--write-movie", path_to_use,
#		"--disable-vsync",
#		"--fixed-fps", "60", # TODO: Consider making this editable.
#		"--resolution", "1152x648",
#		"--",
#		"--ffmpeg-path=" + SettingsManager.get_ffmpeg_path()
#	]
#	CustomLogger.log_normal("Creating a new instance with the arguments: " + str(process_arguments))
#	PopupManager.request_popup(PopupManager.PopupType.PROGRESS)
#	
#	var pipe_dict: Dictionary = OS.execute_with_pipe(OS.get_executable_path(), process_arguments, false)
#	if not pipe_dict.is_empty():
#		_pipe_stdio = pipe_dict.get("stdio")
#		_pipe_stderr = pipe_dict.get("stderr")
#		_temp_process_id = pipe_dict.get("pid")
#	else:
#		CustomLogger.log_error("Failed to start video export.")
#		_temp_path = ""
#		_save_path = ""
#		return
#	
#	_total_frames = AudioManager.get_master_duration() * 60
#
#func initialize_nodes() -> Error:
#	if OS.has_feature("movie"):
#		CustomLogger.log_normal("Oscillody launched in Movie Writer mode.")
#		if FileManager.load_audio_files():
#			CustomLogger.log_error("Could not load audio files to export video. Aborting.")
#			return FAILED
#		if FileManager.load_preset(FileManager.EXPORT_PRESET_NAME):
#			CustomLogger.log_error("Could not load export preset. Aborting.")
#			return FAILED
#		# Letting some things (such as any present waveforms) load. This will be trimmed for the video later.
#		await get_tree().create_timer(1.0).timeout
#		AudioManager.request_play_pause()
#	
#	return OK
#
#func get_active_process_id() -> int:
#	return maxi(_temp_process_id, _save_process_id)
#
#func get_progress_value() -> float:
#	return _total_progress_value
#
#func cancel_export() -> void:
#	# TODO: Close pipes, play jingle (maybe in popup scene), reset values
#	CustomLogger.log_normal("Canceling export from popup.")
#	_total_frames = 0
#	_temp_path = ""
#	_save_path = ""
#	_stdio_line = ""
#	_stderr_line = ""
#	_stderr_collected_errors = ""
#	_empty_input_count = 0
#	_save_progress_value = 0.0
#	_total_progress_value = 0.0
#	_export_canceled = true
#	
#	var err: Error = OS.kill(get_active_process_id())
#	if err:
#		CustomLogger.log_error(
#			"Could not cancel export. Close the window manually. Error: {error}".format(
#				{"error": error_string(err)}
#			)
#		)
#		return
#	
#	#await get_tree().create_timer(2.0).timeout
#	if _pipe_stdio.is_open():
#		_pipe_stdio.close()
#	if _pipe_stderr.is_open():
#		_pipe_stderr.close()
#
#func _reset_values() -> void:
#	_total_frames = 0
#	_temp_path = ""
#	_save_path = ""
#	_temp_process_id = -1
#	_save_process_id = -1
#	_stdio_line = ""
#	_stderr_line = ""
#	_stderr_collected_errors = ""
#	#_empty_input_count = 0
#	_temp_progress_value = 0.0
#	_save_progress_value = 0.0
#	_total_progress_value = 0.0
#	_export_canceled = false
#
#func _start_merge_process() -> void:
#	CustomLogger.log_normal(
#		"Export of separate video and audio files finished. Executing FFmpeg again to merge both."
#	)
#	#_temp_process_id = -1
#	var ffmpeg_arguments: PackedStringArray = [
#		"-hide_banner",
#		"-progress", "pipe:1",
#		"-stats_period", "0.2",
#		"-y",
#		"-ss", "00:00:00.98",
#		"-i", _temp_path,
#		"-ss", "00:00:00.98",
#		"-channel_layout:a", "stereo",
#		"-i", _temp_path.get_basename() + ".wav",
#		"-c:v", "libx264",
#		"-c:a", "aac",
#		"-b:a", "256k",
#		"-ar", "44100",
#		#"-map", "0:v:0",
#		#"-map", "1:a:0",
#		"-movflags", "+faststart",
#		_save_path
#	]
#	CustomLogger.log_normal("Creating a new process with the arguments: " + str(ffmpeg_arguments))
#	
#	var save_pid: int
#	var total_attempts: int = 5
#	for attempt: int in range(total_attempts):
#		CustomLogger.log_normal(
#			"Attempt {attempt} at executing FFmpeg for file merge.".format({"attempt": attempt + 1})
#		)
#		var pipe_dict: Dictionary = OS.execute_with_pipe(
#			SettingsManager.get_ffmpeg_path(),
#			ffmpeg_arguments,
#			false
#		)
#		if not pipe_dict.is_empty():
#			_pipe_stdio = pipe_dict.get("stdio")
#			_pipe_stderr = pipe_dict.get("stderr")
#			save_pid = pipe_dict.get("pid")
#		await get_tree().create_timer(0.5).timeout
#		if attempt < total_attempts and (save_pid < 0 or not OS.is_process_running(save_pid)):
#			continue
#		else:
#			break
#	
#	if save_pid < 0:
#		CustomLogger.log_error("Could not merge temporary files.")
#	else:
#		_save_process_id = save_pid
#
#func _start_deletion_process() -> void:
#	# TODO: Close pipes, play jingle (maybe in popup scene), hide popup, reset values
#	#_save_process_id = -1
#	CustomLogger.log_normal(
#		"Finished merging temp files into the final video at {path}".format({"path": _save_path})
#	)
#	_total_frames = 0
#	_temp_path = ""
#	_save_path = ""
#	_stdio_line = ""
#	_stderr_line = ""
#	_stderr_collected_errors = ""
#	_empty_input_count = 0
#	_save_progress_value = 0.0
#	_total_progress_value = 0.0
#	
#	await get_tree().create_timer(2.0).timeout
#	for file: String in DirAccess.get_files_at(FileManager.get_directory(FileManager.AppDirectory.TEMP)):
#		if DirAccess.remove_absolute(FileManager.get_directory(FileManager.AppDirectory.TEMP).path_join(file)):
#			CustomLogger.log_warning("Could not delete temporary files. Attempting to trash them.")
#			if OS.move_to_trash(FileManager.get_directory(FileManager.AppDirectory.TEMP).path_join(file)):
#				CustomLogger.log_warning("Could not trash temporary files.")
#	
#	if _pipe_stdio.is_open():
#		_pipe_stdio.close()
#	if _pipe_stderr.is_open():
#		_pipe_stderr.close()
