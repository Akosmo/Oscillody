# Oscillody
# Copyright (C) 2025-present Akosmo

# main.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

extends Node

var audio_manager: AudioManager = AudioManager.new()
var element_manager: ElementManager = ElementManager.new()

@onready var files_container: PanelContainer = %FilesContainer
@onready var visualizer_container: VSplitContainer = %VisualizerContainer
@onready var settings_container: PanelContainer = %SettingsContainer
@onready var visualizer: SubViewportContainer = %Visualizer
@onready var player_control_container: PanelContainer = %PlayerControlContainer

func _ready() -> void:
	@warning_ignore("unsafe_property_access")
	files_container.audio_manager = audio_manager
	@warning_ignore("unsafe_property_access")
	visualizer_container.element_manager = element_manager
	@warning_ignore("unsafe_property_access")
	visualizer.audio_manager = audio_manager
	@warning_ignore("unsafe_property_access")
	player_control_container.audio_manager = audio_manager
	
	@warning_ignore("unsafe_method_access")
	if visualizer.connect_player_signals():
		printerr("Could not connect player signals.")
		return
	@warning_ignore("unsafe_method_access")
	if player_control_container.connect_all_signals():
		printerr("Could not connect player signals.")
		return
