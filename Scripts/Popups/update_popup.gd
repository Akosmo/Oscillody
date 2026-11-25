# Oscillody
# Copyright (C) 2025-present Akosmo

# update_popup.gd is part of Oscillody.
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

const _LINK_ITCH_IO: String = "https://akosmotunes.itch.io/oscillody"

@onready var _open_button: Button = %OpenButton
@onready var _close_button: Button = %CloseButton

func _ready() -> void:
	if is_visible():
		hide()
	
	panel_container.set_anchors_preset(Control.LayoutPreset.PRESET_CENTER)
	panel_container.set_pivot_offset(panel_container.get_size() * 0.5)
	
	_open_button.set_tooltip_text(_LINK_ITCH_IO)
	
	PopupManager.popup_requested.connect(_on_popup_requested)
	_open_button.pressed.connect(_on_open_button_pressed)
	_close_button.pressed.connect(_on_close_button_pressed)

func _on_popup_requested(p_popup_type: PopupManager.PopupType) -> void:
	if p_popup_type == PopupManager.PopupType.UPDATE:
		popup_show()

func _on_open_button_pressed() -> void:
	if OS.shell_open(_LINK_ITCH_IO):
		CustomLogger.log_error("Could not open link: " + _LINK_ITCH_IO)
	
	popup_hide()

func _on_close_button_pressed() -> void:
	popup_hide()
