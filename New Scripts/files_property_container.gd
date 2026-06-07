# Oscillody
# Copyright (C) 2025-present Akosmo

# files_property_container.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

extends PanelContainer

var audio_manager: AudioManager

var option_button: OptionButton

# Init is used instead of `_ready()`, because when it is called on the node, it has no script attached.
# `_ready()` is called because the node has entered the tree and is ready.
# But `_init()` is called when a script is attached.
func _init() -> void:
	option_button = $MarginContainer/HBoxContainer/HBoxContainer/OptionButton
	
	var err_item_selected: Error = option_button.connect("item_selected", _on_item_selected)
	if err_item_selected:
		printerr("Could not connect signal.")

func update_audio_list() -> void:
	for stream: StringName in audio_manager.get_streams().keys():
		option_button.add_item(String(stream))
	
	audio_manager.set_master(option_button.get_item_text(option_button.get_selected()))

func _on_item_selected(p_index: int) -> void:
	audio_manager.set_master(StringName(option_button.get_item_text(p_index)))
