# Oscillody
# Copyright (C) 2025-present Akosmo

# progress_popup.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

extends CustomPopup

var _total_progress_value: float
var _destination_folder: String

@onready var _progress_bar: ProgressBar = %ProgressBar
@onready var _cancel_button: Button = %CancelButton
@onready var _audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	if is_visible():
		hide()
	
	panel_container.set_anchors_preset(Control.LayoutPreset.PRESET_CENTER)
	panel_container.set_pivot_offset(panel_container.get_size() * 0.5)
	
	DisplayServer.window_set_taskbar_progress_state(DisplayServer.ProgressState.PROGRESS_STATE_NORMAL)
	
	PopupManager.popup_requested.connect(_on_popup_requested)
	_cancel_button.pressed.connect(_on_cancel_pressed)
	MovieWriterUtilities.export_finished.connect(_on_export_finished)

func _process(_p_delta: float) -> void:
	_total_progress_value = MovieWriterUtilities.get_progress_value()
	_progress_bar.set_value(_total_progress_value * 100.0)
	DisplayServer.window_set_taskbar_progress_value(_total_progress_value)

func _on_popup_requested(p_popup_type: PopupManager.PopupType) -> void:
	if p_popup_type == PopupManager.PopupType.PROGRESS:
		popup_show()

func _toast_notification_callback(p_id: int, p_status: DisplayServer.NotificationStatus) -> void:
	CustomLogger.log_normal("Toast notification callback: ID: " + str(p_id))
	if p_status == DisplayServer.NotificationStatus.NOTIFICATION_ACTIVATED:
		CustomLogger.log_normal("Toast notification activated.")
		if OS.shell_open(_destination_folder):
			CustomLogger.log_error("Failed to open folder: " + _destination_folder)
	elif p_status == DisplayServer.NotificationStatus.NOTIFICATION_DISMISSED:
		CustomLogger.log_normal("Toast notification dismissed.")
	else:
		CustomLogger.log_warning("Failed to raise toast notification.")

func _on_cancel_pressed() -> void:
	CustomLogger.log_normal("Canceling export from popup.")
	MovieWriterUtilities.cancel_export()
	if is_visible():
		popup_hide()

func _on_export_finished(p_path: String) -> void:
	_audio_stream_player.play()
	if not p_path.is_empty():
		_destination_folder = p_path
		DisplayServer.send_toast_notification(
			"Video has finished exporting.",
			"Click here to open the destination folder.",
			null,
			_toast_notification_callback
		)
	popup_hide()
