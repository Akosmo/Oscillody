# Oscillody
# Copyright (C) 2025-present Akosmo

# about_popup.gd is part of Oscillody.
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

@onready var _button: Button = %Button

func _ready() -> void:
	if is_visible():
		hide()
	
	panel_container.set_anchors_preset(Control.LayoutPreset.PRESET_CENTER)
	# NOTE: Text is split manually instead of using autowrapper, which messes with the container size,
	# makes it difficult to set the correct pivot offset, and breaks the look of the popup.
	panel_container.set_pivot_offset(panel_container.get_size() * 0.5)
	
	PopupManager.popup_requested.connect(_on_popup_requested)
	_button.pressed.connect(_on_button_pressed)

func _on_popup_requested(p_popup_type: PopupManager.PopupType) -> void:
	if p_popup_type == PopupManager.PopupType.ABOUT:
		popup_show()

func _on_button_pressed() -> void:
	popup_hide()
