# Oscillody
# Copyright (C) 2025-present Akosmo

# update_checker.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

extends HTTPRequest

const _UPDATE_RATE: int = 600 # Dealing with rate limit. This is 10 minutes in unix time.

var _update_last_checked_at: int
var _current_time: int

func _ready() -> void:
	if OS.has_feature("movie"):
		return
	
	request_completed.connect(_on_request_completed)
	
	_update_last_checked_at = SettingsManager.get_update_last_checked_at()
	_current_time = int(Time.get_unix_time_from_system())
	
	if _current_time >= _update_last_checked_at + _UPDATE_RATE:
		CustomLogger.log_normal(
			"Checking for updates.
Current time: {current}
Last checked: {last}".format(
				{
					"current": _current_time,
					"last": _update_last_checked_at
				}
			)
		)
	else:
		CustomLogger.log_normal(
			"Can't check for updates yet.
Current time: {current}
Last checked: {last}
Next possible time to check upon launch: {next}".format(
				{
					"current": _current_time,
					"last": _update_last_checked_at,
					"next": _update_last_checked_at + _UPDATE_RATE
				}
			)
		)
		return
	
	if request("https://api.github.com/repos/akosmo/oscillody/releases/latest", ["User-Agent: Oscillody"]):
		CustomLogger.log_error(
			"Could not check for the latest version. \
Check your Internet connection if you want Oscillody to check for updates upon launch."
		)

func _on_request_completed(
	p_result: int,
	p_response_code: int,
	_p_headers: PackedStringArray,
	p_body: PackedByteArray
) -> void:
	CustomLogger.log_normal(
		"HTTP request completed at {current}. Cannot check again for 10 minutes.".format(
			{"current": _current_time}
		)
	)
	SettingsManager.set_update_last_checked_at(_current_time)
	
	if p_result != HTTPRequest.Result.RESULT_SUCCESS:
		CustomLogger.log_error(
			"Request failed for latest version, check manually for updates. Result code: " + str(p_result)
		)
		return
	
	if p_response_code != 200:
		CustomLogger.log_error(
			"Request failed for latest version, check manually for updates. Response code: " + str(p_response_code)
		)
		return
	
	var json_body: Dictionary = JSON.parse_string(p_body.get_string_from_utf8())
	if json_body == null:
		CustomLogger.log_error("Could not parse request for latest version.")
		return
	var current_version: String = ProjectSettings.get_setting("application/config/version")
	if current_version.containsn("v"):
		current_version = current_version.replacen("v", "")
	var latest_version: String = json_body["tag_name"]
	if latest_version.containsn("v"):
		latest_version = latest_version.replacen("v", "")
	CustomLogger.log_normal(
		"Current version: {current} - Latest version: {latest}".format(
			{"current": current_version, "latest": latest_version}
		)
	)
	var current_version_array: PackedStringArray = current_version.split(".")
	var latest_version_array: PackedStringArray = latest_version.split(".")
	CustomLogger.log_normal(
		"Current version (array): {current} - Latest version (array): {latest}".format(
			{"current": current_version_array, "latest": latest_version_array}
		)
	)
	if current_version_array[0].to_int() == latest_version_array[0].to_int():
		if current_version_array[1].to_int() == latest_version_array[1].to_int():
			if current_version_array[2].to_int() >= latest_version_array[2].to_int():
				CustomLogger.log_normal("There are no new updates (checked major, minor, and patch numbers).")
			else:
				CustomLogger.log_normal("New patch version available.")
				PopupManager.request_popup(PopupManager.PopupType.UPDATE)
		elif current_version_array[1].to_int() > latest_version_array[1].to_int():
			CustomLogger.log_normal("There are no new updates (checked major and minor numbers).")
		else:
			CustomLogger.log_normal("New minor version available.")
			PopupManager.request_popup(PopupManager.PopupType.UPDATE)
	elif current_version_array[0].to_int() > latest_version_array[0].to_int():
		CustomLogger.log_normal("There are no new updates (checked major number).")
	else:
		CustomLogger.log_normal("New major version available.")
		PopupManager.request_popup(PopupManager.PopupType.UPDATE)
