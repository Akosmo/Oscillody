# Oscillody
# Copyright (C) 2025-present Akosmo

# This file is part of Oscillody. Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

extends CenterContainer

# This script handles the pop-up for saving presets.

#region NODES ##################################

@onready var preset_name: LineEdit = %PresetName
@onready var ui_anim_player: AnimationPlayer = %UIAnimPlayer
@onready var save_p_label: Label = %SavePLabel
@onready var save_p_confirm: Button = %SavePConfirm
@onready var save_p_cancel: Button = %SavePCancel

#endregion ##################################

#region SAVE PRESET VARIABLES ##################################

var overwrite_mode: bool = false
var new_preset_name: String

#endregion ##################################

func _ready() -> void:
	MainUtils.saving_preset.connect(ready_for_typing)

func ready_for_typing() -> void:
	preset_name.grab_focus()
	preset_name.set_text(GlobalVariables.preset_name)
	preset_name.select_all()

func save_new_preset() -> void:
	if not overwrite_mode:
		GlobalVariables.presets_in_selector.append(new_preset_name.validate_filename())
	GlobalVariables.save_preset(new_preset_name)
	GlobalVariables.preset_name = new_preset_name
	MainUtils.new_preset_saved.emit()
	ui_anim_player.play("save_out")
	preset_name.release_focus()
	save_p_confirm.release_focus()
	if not overwrite_mode:
		MainUtils.logger("New preset saved: " + new_preset_name)
	else:
		MainUtils.logger("Preset overwritten: " + new_preset_name)
	preset_name.text = ""

func is_blank_name() -> bool:
	if preset_name.text == "":
		return true
	
	var valid_found: bool
	for character in preset_name.text:
		if character == "" or character == " ":
			continue
		else:
			valid_found = true
			break
	if not valid_found:
		return true
	else:
		return false

#region SAVE PRESET BUILT-IN SIGNAL FUNCTIONS ##################################

func _on_save_p_confirm_pressed() -> void:
	if is_blank_name():
		MainUtils.logger("Choose a valid filename.", true)
		ui_anim_player.play("save_out")
		preset_name.release_focus()
		save_p_cancel.release_focus()
		preset_name.text = ""
		return
	new_preset_name = preset_name.text
	if new_preset_name == GlobalVariables.RENDER_PRESET_FILENAME:
		new_preset_name = new_preset_name + "_user"
	if not overwrite_mode:
		if new_preset_name.validate_filename() not in GlobalVariables.presets_in_selector:
			save_new_preset()
		else:
			save_p_label.text = "Overwrite preset?"
			preset_name.editable = false
			save_p_confirm.text = "Yes"
			save_p_cancel.text = "No"
			overwrite_mode = true
	else:
		save_new_preset()
		save_p_label.text = "Save Preset:"
		preset_name.editable = true
		save_p_confirm.text = "Save"
		save_p_cancel.text = "Cancel"
		overwrite_mode = false

func _on_save_p_cancel_pressed() -> void:
	if not overwrite_mode:
		ui_anim_player.play("save_out")
		preset_name.release_focus()
		save_p_cancel.release_focus()
		preset_name.text = ""
	else:
		save_p_label.text = "Save Preset:"
		preset_name.editable = true
		save_p_confirm.text = "Save"
		save_p_cancel.text = "Cancel"
		preset_name.text = ""
		overwrite_mode = false
		preset_name.grab_focus()

func _on_preset_name_text_submitted(_new_text: String) -> void:
	save_p_confirm.pressed.emit()

#endregion ##################################
