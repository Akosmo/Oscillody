# Oscillody
# Copyright (C) 2025 Akosmo

# This file is part of Oscillody. Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

extends Node2D

# This script mostly handles audio reaction.

#region NODES ##################################

@onready var audio_players: Node = %AudioPlayers

#endregion ##################################

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	
	MainUtils.close_requested.connect(on_close_requested)
	
	# Start loads preset and audio for rendering.
	if OS.has_feature("movie"):
		var user_arguments: Dictionary[String, String] = {} # Dictionary that will hold user arguments
		MainUtils.logger("Starting render with arguments: " + str(OS.get_cmdline_user_args()))
		for argument: String in OS.get_cmdline_user_args(): # ["--load_preset=render_preset"] - supports multiple args
			if "=" in argument:
				# Sets key_value to ["--load_preset", "render_preset"]
				var key_value: PackedStringArray = argument.split("=")
				# user_arguments{"load_preset": "render_preset"}
				user_arguments[key_value[0].lstrip("--")] = key_value[1]
			else:
				user_arguments[argument.lstrip("--")] = "" # Key with no value
		GlobalVariables.load_preset(user_arguments["load_preset"])
		GlobalVariables.load_audio()
		MainUtils.update_visualizer.emit()
		await get_tree().create_timer(1.0).timeout # Letting waveforms and audio load
		audio_players.play_audio_spectrum_data_node() # Playing this earlier so it's synced to audio
		await get_tree().create_timer(0.1).timeout
		audio_players.play_audio_nodes()

func on_close_requested() -> void:
	if OS.has_feature("movie"):
		MainUtils.logger("Rendering canceled / Session closing (render process).")
		audio_players.stop_audio_nodes()
		audio_players.queue_free()
		get_tree().quit()
