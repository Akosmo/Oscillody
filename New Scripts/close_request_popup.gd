# Oscillody
# Copyright (C) 2025-present Akosmo

# close_request_popup.gd is part of Oscillody.
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

@onready var _quit_button: Button = %QuitButton
@onready var _cancel_button: Button = %CancelButton

func _ready() -> void:
	if is_visible():
		hide()
	
	panel_container.set_anchors_preset(Control.PRESET_CENTER)
	panel_container.set_pivot_offset(panel_container.get_size() * 0.5)
	
	_quit_button.pressed.connect(_on_quit_pressed)
	_cancel_button.pressed.connect(_on_cancel_pressed)

func _on_quit_pressed() -> void:
	if FileManager.save_settings():
		CustomLogger.log_warning(
			"Could not save settings. Next app luanch will load either default settings, or settings \
saved previously"
		)
	CustomLogger.log_normal("Closing Oscillody.")
	get_tree().quit()

func _on_cancel_pressed() -> void:
	popup_hide()
