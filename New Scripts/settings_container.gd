# Oscillody
# Copyright (C) 2025-present Akosmo

# settings_container.gd is part of Oscillody.
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

const _INPUT_DEVICE_PROPERTY_KEY: StringName = &"Input_Device"
const _OUTPUT_DEVICE_PROPERTY_KEY: StringName = &"Output_Device"
const _EXPORT_RESOLUTION_PROPERTY_KEY: StringName = &"Export_Resolution"
const _THEME_PROPERTY_KEY: StringName = &"Theme"
const _SWITCH_TO_SLIDERS_PROPERTY_KEY: StringName = &"Switch_To_Slider"
const _SYNC_ELEMENT_SHAKE_PROPERTY_KEY: StringName = &"Sync_Element_Shake"

@onready var _input_device_container: BasicPropertyContainer = %InputDeviceContainer
@onready var _output_device_container: BasicPropertyContainer = %OutputDeviceContainer
@onready var _export_resolution_container: BasicPropertyContainer = %ExportResolutionContainer
@onready var _theme_container: BasicPropertyContainer = %ThemeContainer
@onready var _switch_to_sliders_container: BasicPropertyContainer = %SwitchToSlidersContainer
@onready var _sync_element_shake_container: BasicPropertyContainer = %SyncElementShakeContainer

func _ready() -> void:
	_input_device_container.set_control_node(BasicPropertyContainer.ControlNode.OPTION_BUTTON)
	_input_device_container.set_property_key(_INPUT_DEVICE_PROPERTY_KEY)
	for input_device: String in AudioServer.get_input_device_list():
		_input_device_container.option_button.add_item(input_device)
	_input_device_container.set_property_value_with_node(SettingsManager.get_input_device())
	_input_device_container.property_value_changed.connect(_on_property_value_changed)
	
	_output_device_container.set_control_node(BasicPropertyContainer.ControlNode.OPTION_BUTTON)
	_output_device_container.set_property_key(_OUTPUT_DEVICE_PROPERTY_KEY)
	for output_device: String in AudioServer.get_output_device_list():
		_output_device_container.option_button.add_item(output_device)
	_output_device_container.set_property_value_with_node(SettingsManager.get_output_device())
	_output_device_container.property_value_changed.connect(_on_property_value_changed)
	
	_export_resolution_container.set_control_node(BasicPropertyContainer.ControlNode.OPTION_BUTTON)
	_export_resolution_container.set_property_key(_EXPORT_RESOLUTION_PROPERTY_KEY)
	_export_resolution_container.option_button.add_item(SettingsManager.RESOLUTION_720P)
	_export_resolution_container.option_button.add_item(SettingsManager.RESOLUTION_1080P)
	_export_resolution_container.option_button.add_item(SettingsManager.RESOLUTION_1440P)
	_export_resolution_container.set_property_value_with_node(SettingsManager.get_export_resolution())
	_export_resolution_container.property_value_changed.connect(_on_property_value_changed)
	
	_theme_container.set_control_node(BasicPropertyContainer.ControlNode.OPTION_BUTTON)
	_theme_container.set_property_key(_THEME_PROPERTY_KEY)
	_theme_container.set_property_value(SettingsManager.get_app_theme())
	_theme_container.property_value_changed.connect(_on_property_value_changed)
	
	_switch_to_sliders_container.set_control_node(BasicPropertyContainer.ControlNode.CHECK_BUTTON)
	_switch_to_sliders_container.set_property_key(_SWITCH_TO_SLIDERS_PROPERTY_KEY)
	_switch_to_sliders_container.set_property_value_with_node(SettingsManager.are_sliders_enabled())
	_switch_to_sliders_container.property_value_changed.connect(_on_property_value_changed)
	
	_sync_element_shake_container.set_control_node(BasicPropertyContainer.ControlNode.BUTTON)
	_sync_element_shake_container.set_property_key(_SYNC_ELEMENT_SHAKE_PROPERTY_KEY)
	_sync_element_shake_container.use_file_dialog(false)
	_sync_element_shake_container.button.set_text("Sync")
	_sync_element_shake_container.property_value_changed.connect(_on_property_value_changed)
	
	#@warning_ignore("unsafe_property_access")
	#_input_device_container.container_property = SettingsManager.ContainerProperty.INPUT_DEVICE
	#
	#@warning_ignore("unsafe_property_access")
	#_output_device_container.container_property = SettingsManager.ContainerProperty.OUTPUT_DEVICE
	#
	#@warning_ignore("unsafe_property_access")
	#_export_resolution_container.container_property = SettingsManager.ContainerProperty.EXPORT_RESOLUTION
	#
	#@warning_ignore("unsafe_property_access")
	#_theme_container.container_property = SettingsManager.ContainerProperty.THEME
	#
	#@warning_ignore("unsafe_property_access")
	#_switch_to_sliders_container.container_property = SettingsManager.ContainerProperty.SLIDER_SWITCH
	#
	#SettingsManager.notify_setup_request()

func _on_property_value_changed(p_property_key: StringName, p_property_value: Variant) -> void:
	match p_property_key:
		_INPUT_DEVICE_PROPERTY_KEY:
			if SettingsManager.set_input_device(str(p_property_value)):
				printerr("Could not set input device.")
		_OUTPUT_DEVICE_PROPERTY_KEY:
			if SettingsManager.set_output_device(str(p_property_value)):
				printerr("Could not set output device.")
		_EXPORT_RESOLUTION_PROPERTY_KEY:
			if SettingsManager.set_export_resolution(str(p_property_value)):
				printerr("Could not set export resolution.")
		_THEME_PROPERTY_KEY:
			if SettingsManager.set_app_theme(str(p_property_value)):
				printerr("Could not set theme.")
		_SWITCH_TO_SLIDERS_PROPERTY_KEY:
			SettingsManager.enable_sliders(p_property_value as bool)
		_SYNC_ELEMENT_SHAKE_PROPERTY_KEY:
			SettingsManager.sync_element_shake_requested.emit()
