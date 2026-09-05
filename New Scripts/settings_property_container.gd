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

var _reset_button: Button
var _button: Button
var _check_button: CheckButton
var _option_button: OptionButton

var _reset_value: Variant

# `_init()` is used instead of `_ready()`, because when it is called on the node, it has no script attached.
# `_ready()` is called because the node has entered the tree and is ready.
# But `_init()` is called when a script is attached.
func _init() -> void:
	_reset_button = %ResetButton
	_button = %Button
	_check_button = %CheckButton
	_option_button = %OptionButton
	
	if _connect_signals():
		printerr("Could not connect signals.")
		return

func _connect_signals() -> Error:
	if _reset_button.pressed.connect(_on_reset_pressed):
		return ERR_INVALID_PARAMETER
	if _button.pressed.connect(_on_button_pressed):
		return ERR_INVALID_PARAMETER
	if _check_button.toggled.connect(_on_check_toggled):
		return ERR_INVALID_PARAMETER
	if _option_button.item_selected.connect(_on_item_selected):
		return ERR_INVALID_PARAMETER
	
	if SettingsManager.setup_requested.connect(_on_update_settings):
		return ERR_INVALID_PARAMETER
	
	return OK

func _on_reset_pressed() -> void:
	match container_property:
		SettingsManager.ContainerProperty.INPUT_DEVICE:
			pass
		SettingsManager.ContainerProperty.OUTPUT_DEVICE:
			pass
		SettingsManager.ContainerProperty.EXPORT_RESOLUTION:
			pass
		SettingsManager.ContainerProperty.THEME:
			pass
		SettingsManager.ContainerProperty.SLIDER_SWITCH:
			pass
		_:
			printerr("Unknown property.")

func _on_button_pressed() -> void:
	SettingsManager.sync_element_shake_requested.emit()

func _on_check_toggled(p_toggled_on: bool) -> void:
	SettingsManager.enable_sliders(p_toggled_on)

func _on_item_selected(p_index: int) -> void:
	match container_property:
		SettingsManager.ContainerProperty.INPUT_DEVICE:
			if SettingsManager.set_input_device(_option_button.get_item_text(p_index)):
				printerr("Could not set input device.")
		SettingsManager.ContainerProperty.OUTPUT_DEVICE:
			if SettingsManager.set_output_device(_option_button.get_item_text(p_index)):
				printerr("Could not set output device.")
		SettingsManager.ContainerProperty.EXPORT_RESOLUTION:
			if SettingsManager.set_export_resolution(_option_button.get_item_text(p_index)):
				printerr("Could not set export resolution.")
		SettingsManager.ContainerProperty.THEME:
			if SettingsManager.set_app_theme(_option_button.get_item_text(p_index)):
				printerr("Could not set theme.")
		_:
			printerr("Unknown property.")

func _on_update_settings() -> void:
	match container_property:
		SettingsManager.ContainerProperty.INPUT_DEVICE:
			for input_device: String in AudioServer.get_input_device_list():
				_option_button.add_item(input_device)
			_option_button.select(
				AudioServer.get_input_device_list().find(SettingsManager.get_input_device())
			)
		SettingsManager.ContainerProperty.OUTPUT_DEVICE:
			for output_device: String in AudioServer.get_output_device_list():
				_option_button.add_item(output_device)
			_option_button.select(
				AudioServer.get_output_device_list().find(SettingsManager.get_output_device())
			)
		SettingsManager.ContainerProperty.EXPORT_RESOLUTION:
			_option_button.add_item(SettingsManager.RESOLUTION_720P)
			_option_button.add_item(SettingsManager.RESOLUTION_1080P)
			_option_button.add_item(SettingsManager.RESOLUTION_1440P)
			_option_button.select(1)
		SettingsManager.ContainerProperty.THEME:
			pass
		SettingsManager.ContainerProperty.SLIDER_SWITCH:
			pass
		SettingsManager.ContainerProperty.SYNC_ELEMENT_SHAKE:
			pass
		_:
			printerr("Unknown property.")
