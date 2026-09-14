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

@onready var _input_device_container: PanelContainer = %InputDeviceContainer
@onready var _output_device_container: PanelContainer = %OutputDeviceContainer
@onready var _export_resolution_container: PanelContainer = %ExportResolutionContainer
@onready var _theme_container: PanelContainer = %ThemeContainer
@onready var _switch_to_sliders_container: PanelContainer = %SwitchToSlidersContainer

func _ready() -> void:
	@warning_ignore("unsafe_property_access")
	_input_device_container.container_property = SettingsManager.ContainerProperty.INPUT_DEVICE
	
	@warning_ignore("unsafe_property_access")
	_output_device_container.container_property = SettingsManager.ContainerProperty.OUTPUT_DEVICE
	
	@warning_ignore("unsafe_property_access")
	_export_resolution_container.container_property = SettingsManager.ContainerProperty.EXPORT_RESOLUTION
	
	@warning_ignore("unsafe_property_access")
	_theme_container.container_property = SettingsManager.ContainerProperty.THEME
	
	@warning_ignore("unsafe_property_access")
	_switch_to_sliders_container.container_property = SettingsManager.ContainerProperty.SLIDER_SWITCH
	
	SettingsManager.notify_setup_request()
