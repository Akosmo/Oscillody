# Oscillody
# Copyright (C) 2025-present Akosmo

# settings_property_container.gd is part of Oscillody.
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

var container_property: SettingsManager.ContainerProperty

var settings_manager: SettingsManager

var _reset_button: Button
var _option_button: OptionButton
var _check_button: CheckButton

var _default_value: Variant

# `_init()` is used instead of `_ready()`, because when it is called on the node, it has no script attached.
# `_ready()` is called because the node has entered the tree and is ready.
# But `_init()` is called when a script is attached.
func _init() -> void:
	_reset_button = $MarginContainer/HBoxContainer/Button
	_option_button = $MarginContainer/HBoxContainer/HBoxContainer/OptionButton
	_check_button = $MarginContainer/HBoxContainer/HBoxContainer/CheckButton
	
	if _connect_node_signals():
		printerr("Could not connect node signals.")
		return

func set_matching_property() -> void:
	match container_property:
		settings_manager.ContainerProperty.INPUT_DEVICE:
			for input_device: String in AudioServer.get_input_device_list():
				_option_button.add_item(input_device)
			_option_button.select(
				AudioServer.get_input_device_list().find(settings_manager.get_input_device())
			)
		settings_manager.ContainerProperty.OUTPUT_DEVICE:
			for output_device: String in AudioServer.get_output_device_list():
				_option_button.add_item(output_device)
			_option_button.select(
				AudioServer.get_output_device_list().find(settings_manager.get_output_device())
			)
		settings_manager.ContainerProperty.EXPORT_RESOLUTION:
			_option_button.add_item("720p")
			_option_button.add_item("1080p")
			_option_button.add_item("1440p")
			_option_button.select(1)
		settings_manager.ContainerProperty.THEME:
			pass
		settings_manager.ContainerProperty.SLIDER_SWITCH:
			pass

func _connect_node_signals() -> Error:
	if _reset_button.pressed.connect(_on_reset_pressed):
		return ERR_INVALID_PARAMETER
	if _option_button.item_selected.connect(_on_item_selected):
		return ERR_INVALID_PARAMETER
	if _check_button.toggled.connect(_on_check_pressed):
		return ERR_INVALID_PARAMETER
	
	return OK

func _on_reset_pressed() -> void:
	match container_property:
		settings_manager.ContainerProperty.INPUT_DEVICE:
			pass
		settings_manager.ContainerProperty.OUTPUT_DEVICE:
			pass
		settings_manager.ContainerProperty.EXPORT_RESOLUTION:
			pass
		settings_manager.ContainerProperty.THEME:
			pass
		settings_manager.ContainerProperty.SLIDER_SWITCH:
			pass

func _on_item_selected(p_index: int) -> void:
	match container_property:
		settings_manager.ContainerProperty.INPUT_DEVICE:
			if settings_manager.set_input_device(_option_button.get_item_text(p_index)):
				printerr("Could not set input device.")
		settings_manager.ContainerProperty.OUTPUT_DEVICE:
			if settings_manager.set_output_device(_option_button.get_item_text(p_index)):
				printerr("Could not set output device.")
		settings_manager.ContainerProperty.EXPORT_RESOLUTION:
			if settings_manager.set_export_resolution(_option_button.get_item_text(p_index)):
				printerr("Could not set export resolution.")
		settings_manager.ContainerProperty.THEME:
			if settings_manager.set_app_theme(_option_button.get_item_text(p_index)):
				printerr("Could not set theme.")
		_:
			pass

func _on_check_pressed(p_toggled_on: bool) -> void:
	settings_manager.enable_sliders(p_toggled_on)
