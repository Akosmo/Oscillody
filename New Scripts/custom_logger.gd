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

var _log_file: FileAccess
var _log_path: String

func _init() -> void:
	if FileManager.check_directory(FileManager.get_directory(FileManager.AppDirectory.LOG)):
		push_error("Directory for log was not created.")
	_log_path = FileManager.get_directory(FileManager.AppDirectory.LOG).path_join(FileManager.LOG_FILENAME)
	
	if _prepare_file():
		push_error("File for log was not created.")

func _exit_tree() -> void:
	_log_file.close()

func log_normal(p_text: String) -> void:
	_log_internal(p_text)

func log_warning(p_text: String) -> void:
	_log_internal(p_text, LogType.WARNING)

func log_error(p_text: String) -> void:
	_log_internal(p_text, LogType.ERROR)

func log_critical_error(p_text: String) -> void:
	_log_internal(p_text, LogType.CRITICAL_ERROR)

func _log_internal(p_text: String, p_log_type: LogType = LogType.NORMAL) -> void:
	if FileManager.check_directory(FileManager.get_directory(FileManager.AppDirectory.LOG)):
		return
	
	if _prepare_file():
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
	
	if not _log_file.store_line(
		"{time} - {full_message}".format({"time": log_time, "full_message": full_message})
	):
		push_error("Could not write log.")
	
	_log_file.flush()
	
	DebugUtilities.set_log_text(
		"{time} - {full_message}".format({"time": log_time, "full_message": full_message})
	)

func _prepare_file() -> Error:
	if not FileAccess.file_exists(_log_path):
		_log_file = FileAccess.open(_log_path, FileAccess.WRITE)
		if _log_file == null:
			push_error(error_string(FileAccess.get_open_error()))
			return ERR_FILE_CANT_OPEN
		_log_file.close()
	if (_log_file != null and not _log_file.is_open()) or _log_file == null:
		_log_file = FileAccess.open(_log_path, FileAccess.READ_WRITE)
		if _log_file == null:
			push_error(error_string(FileAccess.get_open_error()))
			return ERR_FILE_CANT_OPEN
	_log_file.seek_end()
	
	return OK
