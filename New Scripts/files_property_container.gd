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

var _reset_button: Button
var _option_button: OptionButton

# Init is used instead of `_ready()`, because when it is called on the node, it has no script attached.
# `_ready()` is called because the node has entered the tree and is ready.
# But `_init()` is called when a script is attached.
func _init() -> void:
	_reset_button = $MarginContainer/HBoxContainer/Button
	_option_button = $MarginContainer/HBoxContainer/HBoxContainer/OptionButton
	
	if _connect_node_signals():
		printerr("Could not connect node signals.")
		return

func update_audio_list() -> void:
	_option_button.clear()
	
	var stream_dict: Dictionary[StringName, AudioStream] = audio_manager.get_streams()
	if not stream_dict.is_empty():
		for stream: StringName in stream_dict:
			_option_button.add_item(String(stream))
		
		_reset_button.show()
	
		audio_manager.set_master_name(_option_button.get_item_text(_option_button.get_selected()))
	else:
		audio_manager.set_master_name(&"")
		
		_reset_button.hide()

func connect_audio_manager_signals() -> Error:
	if audio_manager.audio_files_changed.connect(update_audio_list):
		return ERR_INVALID_PARAMETER
	
	return OK

func _connect_node_signals() -> Error:
	if _reset_button.pressed.connect(_on_reset_pressed):
		return ERR_INVALID_PARAMETER
	if _option_button.item_selected.connect(_on_item_selected):
		return ERR_INVALID_PARAMETER
	
	return OK

func _on_reset_pressed() -> void:
	audio_manager.clear_streams()

func _on_item_selected(p_index: int) -> void:
	audio_manager.set_master_name(StringName(_option_button.get_item_text(p_index)))
