# Oscillody
# Copyright (C) 2025-present Akosmo

# custom_logger.gd is part of Oscillody.
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

enum LogType {
	# No alert or tags.
	# To avoid overusing it, keep it only for important internal-only changes, that also also not
	# displayed in the debug panel.
	NORMAL,
	# No alert, but tagged as a warning.
	WARNING,
	# Uses alert and is tagged as an error. Avoid use in loops.
	ERROR,
	# Uses alert and is tagged as an error. Suggests app restart. Avoid use in loops.
	# This should be reserved for errors that not only are not corrected internally, but also
	# stops Oscillody from functioning normally.
	CRITICAL_ERROR
}

const MOVIE_WRITER_STRING: String = "MOVIE WRITER: "

var _main_log_file: FileAccess
var _main_log_path: String

var _ffmpeg_log_file: FileAccess
var _ffmpeg_log_path: String

func _ready() -> void:
	if OS.has_feature("movie"):
		return
	
	if FileManager.check_directory(FileManager.get_directory(FileManager.AppDirectory.LOGS)):
		push_error("Directory for log was not created.")
	
	_main_log_path = FileManager.get_directory(FileManager.AppDirectory.LOGS)\
	.path_join(FileManager.MAIN_LOG_FILENAME)
	_ffmpeg_log_path = FileManager.get_directory(FileManager.AppDirectory.LOGS)\
	.path_join(FileManager.FFMPEG_LOG_FILENAME)
	
	if _prepare_main_log_file():
		push_error("File for main log was not created.")
	if _prepare_ffmpeg_log_file():
		push_error("File for FFmpeg log was not created.")

func _exit_tree() -> void:
	if OS.has_feature("movie"):
		return
	
	_main_log_file.close()

func log_normal(p_text: String) -> void:
	_log_internal(p_text)

func log_warning(p_text: String) -> void:
	_log_internal(p_text, LogType.WARNING)

func log_error(p_text: String) -> void:
	_log_internal(p_text, LogType.ERROR)

func log_critical_error(p_text: String) -> void:
	_log_internal(p_text, LogType.CRITICAL_ERROR)

func log_ffmpeg(p_text: String) -> void:
	_log_internal_ffmpeg(p_text)

func _log_internal(p_text: String, p_log_type: LogType = LogType.NORMAL) -> void:
	if OS.has_feature("movie"):
		_log_internal_movie(p_text)
		return
	
	if FileManager.check_directory(FileManager.get_directory(FileManager.AppDirectory.LOGS)):
		return
	
	if _prepare_main_log_file():
		return
	
	var log_time: String = Time.get_datetime_string_from_system(false, true)
	var full_message: String
	
	match p_log_type:
		LogType.NORMAL:
			full_message = p_text
			print("{time} - {full_message}".format({"time": log_time, "full_message": full_message}))
		LogType.WARNING:
			full_message = "WARNING: " + p_text
			push_warning("{time} - {full_message}".format({"time": log_time, "full_message": full_message}))
		LogType.ERROR:
			var disclaimer: String = " - If you think this is a bug, please report it."
			full_message = "ERROR: " + p_text + disclaimer
			push_error("{time} - {full_message}".format({"time": log_time, "full_message": full_message}))
			OS.alert(p_text + disclaimer, "Error!")
		LogType.CRITICAL_ERROR:
			var disclaimer: String = " - It is recommended to restart \
the application. If you think this is a bug, please report it."
			full_message = "CRITICAL ERROR: " + p_text + disclaimer
			push_error("{time} - {full_message}".format({"time": log_time, "full_message": full_message}))
			OS.alert(p_text + disclaimer, "Critical Error!")
	
	if not _main_log_file.store_line(
		"{time} - {full_message}".format({"time": log_time, "full_message": full_message})
	):
		push_error("Could not write log.")
	
	_main_log_file.flush()
	
	DebugUtilities.set_log_text(
		"{time} - {full_message}".format({"time": log_time, "full_message": full_message})
	)

func _log_internal_movie(p_text: String) -> void:
	# Can't be fancy, otherwise the Movie Writer instance freezes.
	# Time not needed, since this output is going to be logged from the main instance.
	print(MOVIE_WRITER_STRING + p_text)

# Simple, using raw FFmpeg output.
func _log_internal_ffmpeg(p_text: String) -> void:
	if OS.has_feature("movie"):
		return
	
	if FileManager.check_directory(FileManager.get_directory(FileManager.AppDirectory.LOGS)):
		return
	
	if _prepare_ffmpeg_log_file():
		return
	
	print(p_text)
	
	if not _ffmpeg_log_file.store_line(p_text):
		push_error("Could not write log.")
	
	_ffmpeg_log_file.flush()

func _prepare_main_log_file() -> Error:
	if not FileAccess.file_exists(_main_log_path):
		_main_log_file = FileAccess.open(_main_log_path, FileAccess.ModeFlags.WRITE)
		if _main_log_file == null:
			push_error(error_string(FileAccess.get_open_error()))
			return Error.ERR_FILE_CANT_OPEN
		_main_log_file.close()
	if (_main_log_file != null and not _main_log_file.is_open()) or _main_log_file == null:
		_main_log_file = FileAccess.open(_main_log_path, FileAccess.ModeFlags.READ_WRITE)
		if _main_log_file == null:
			push_error(error_string(FileAccess.get_open_error()))
			return Error.ERR_FILE_CANT_OPEN
	_main_log_file.seek_end()
	
	return Error.OK

func _prepare_ffmpeg_log_file() -> Error:
	if not FileAccess.file_exists(_ffmpeg_log_path):
		_ffmpeg_log_file = FileAccess.open(_ffmpeg_log_path, FileAccess.ModeFlags.WRITE)
		if _ffmpeg_log_file == null:
			push_error(error_string(FileAccess.get_open_error()))
			return Error.ERR_FILE_CANT_OPEN
		_ffmpeg_log_file.close()
	if (_ffmpeg_log_file != null and not _ffmpeg_log_file.is_open()) or _ffmpeg_log_file == null:
		_ffmpeg_log_file = FileAccess.open(_ffmpeg_log_path, FileAccess.ModeFlags.READ_WRITE)
		if _ffmpeg_log_file == null:
			push_error(error_string(FileAccess.get_open_error()))
			return Error.ERR_FILE_CANT_OPEN
	_ffmpeg_log_file.seek_end()
	
	return Error.OK
