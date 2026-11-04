# Oscillody
# Copyright (C) 2025-present Akosmo

# preset_popup.gd is part of Oscillody.
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

var _overwrite_mode: bool

@onready var _label: Label = %Label
@onready var _line_edit: LineEdit = %LineEdit
@onready var _save_button: Button = %SaveButton
@onready var _cancel_button: Button = %CancelButton

func _ready() -> void:
	if is_visible():
		hide()
	
	panel_container.set_anchors_preset(Control.PRESET_CENTER)
	panel_container.set_pivot_offset(panel_container.get_size() * 0.5)
	
	_line_edit.text_submitted.connect(_on_text_submitted)
	_save_button.pressed.connect(_on_save_pressed)
	_cancel_button.pressed.connect(_on_cancel_pressed)
	visibility_changed.connect(_on_visibility_changed)
	
	_set_to_overwrite(false)

func _set_to_overwrite(p_overwrite: bool = true) -> void:
	_overwrite_mode = p_overwrite
	
	if not p_overwrite:
		_label.set_text("Choose preset name:")
		_save_button.set_text("Save")
		_cancel_button.set_text("Cancel")
		return
	
	_label.set_text("Preset already exists. Overwrite?")
	_save_button.set_text("Yes")
	_cancel_button.set_text("No")

func _on_text_submitted(p_text: String) -> void:
	if not p_text.is_empty():
		_on_save_pressed()

func _on_save_pressed() -> void:
	var raw_preset_name: String = _line_edit.get_text()
	var preset_name: String = raw_preset_name.validate_filename()
	
	CustomLogger.log_normal("Attempting to save preset with the name: " + raw_preset_name)
	
	if preset_name.is_empty():
		preset_name = "_"
	
	# TEST: Test this conditional.
	if not preset_name.is_valid_filename():
		if preset_name[0] == " ":
			preset_name[0] = "_"
		if preset_name.length() > 1 and preset_name[-1] == " ":
			preset_name[-1] = "_"
	
	if not _overwrite_mode and FileManager.preset_exists(preset_name):
		CustomLogger.log_warning("The preset \"{preset}\" already exists.".format({"preset": preset_name}))
		_set_to_overwrite()
		return
	
	if FileManager.save_preset(preset_name):
		CustomLogger.log_critical_error("Could not save preset: " + preset_name)
	
	if _overwrite_mode:
		_set_to_overwrite(false)
	
	popup_hide()

func _on_cancel_pressed() -> void:
	if _overwrite_mode:
		_set_to_overwrite(false)
	
	popup_hide()

func _on_visibility_changed() -> void:
	if is_visible():
		_line_edit.grab_focus()
		_line_edit.set_text(FileManager.get_selected_preset())
		_line_edit.select_all()
	else:
		_line_edit.release_focus()
		_save_button.release_focus()
		_cancel_button.release_focus()
