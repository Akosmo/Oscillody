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
	# HACK: Pivot offset is not set correctly unless I do this. Probably related to text wrapping.
	var fixed_pivot: Vector2 = Vector2(
		panel_container.get_size().x * 4.0,
		panel_container.get_size().y * 0.25
	)
	panel_container.set_pivot_offset(fixed_pivot)
	
	_button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	popup_hide()
