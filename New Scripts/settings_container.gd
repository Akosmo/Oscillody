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

var _settings_property_container_script: Script = preload("res://New Scripts/settings_property_container.gd")

@onready var input_device_container: PanelContainer = %InputDeviceContainer
@onready var output_device_container: PanelContainer = %OutputDeviceContainer
@onready var export_resolution_container: PanelContainer = %ExportResolutionContainer
@onready var theme_container: PanelContainer = %ThemeContainer
@onready var switch_to_sliders_container: PanelContainer = %SwitchToSlidersContainer

func _ready() -> void:
	input_device_container.set_script(_settings_property_container_script)
	@warning_ignore("unsafe_property_access")
	input_device_container.container_property = SettingsManager.ContainerProperty.INPUT_DEVICE
	
	output_device_container.set_script(_settings_property_container_script)
	@warning_ignore("unsafe_property_access")
	output_device_container.container_property = SettingsManager.ContainerProperty.OUTPUT_DEVICE
	
	export_resolution_container.set_script(_settings_property_container_script)
	@warning_ignore("unsafe_property_access")
	export_resolution_container.container_property = SettingsManager.ContainerProperty.EXPORT_RESOLUTION
	
	theme_container.set_script(_settings_property_container_script)
	@warning_ignore("unsafe_property_access")
	theme_container.container_property = SettingsManager.ContainerProperty.THEME
	
	switch_to_sliders_container.set_script(_settings_property_container_script)
	@warning_ignore("unsafe_property_access")
	switch_to_sliders_container.container_property = SettingsManager.ContainerProperty.SLIDER_SWITCH
	
	SettingsManager.update_settings.emit()
