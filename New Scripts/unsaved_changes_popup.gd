# Oscillody
# Copyright (C) 2025-present Akosmo

# unsaved_changes_checker.gd is part of Oscillody.
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

@onready var _change_button: Button = %ChangeButton
@onready var _cancel_button: Button = %CancelButton

func _ready() -> void:
	if is_visible():
		hide()
	
	panel_container.set_anchors_preset(Control.PRESET_CENTER)
	panel_container.set_pivot_offset(panel_container.get_size() * 0.5)
	
	PopupManager.popup_requested.connect(_on_popup_requested)
	_change_button.pressed.connect(_on_change_button_pressed)
	_cancel_button.pressed.connect(_on_cancel_button_pressed)

func _on_popup_requested(p_popup_type: PopupManager.PopupType) -> void:
	if p_popup_type == PopupManager.PopupType.UNSAVED_CHANGES:
		popup_show()

func _on_change_button_pressed() -> void:
	FileManager.load_preset(FileManager.get_desired_preset())
	FileManager.set_desired_preset("")
	
	popup_hide()

func _on_cancel_button_pressed() -> void:
	FileManager.set_desired_preset("")
	FileManager.notify_canceled_preset_change()
	
	popup_hide()
