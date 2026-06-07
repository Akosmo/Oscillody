# Oscillody
# Copyright (C) 2025-present Akosmo

# new_player_control.gd is part of Oscillody.
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

var audio_manager: AudioManager = AudioManager.new()
var players: Dictionary[StringName, AudioStreamPlayer]
var master_player: AudioStreamPlayer

@onready var play_pause_button: Button = %PlayPauseButton
@onready var stop_button: Button = %StopButton
@onready var loop_button: Button = %LoopButton
@onready var volume_slider: HSlider = %VolumeSlider
@onready var volume_label: Label = %VolumeLabel
@onready var time_slider: HSlider = %TimeSlider
@onready var time_label: Label = %TimeLabel

func _ready() -> void:
	var err_signals: Error = _connect_all_signals()
	if err_signals:
		printerr("Could not connect signals.")

# This should probably be in audio manager, and the player should just interact with the master player.
func _update_players() -> void:
	for bus_idx: int in AudioServer.get_bus_count():
		if bus_idx == 0:
			continue
		AudioServer.remove_bus(bus_idx)
	var bus_idx: int = 1
	players.clear()
	
	for stream_name: StringName in audio_manager.get_streams().keys():
		AudioServer.add_bus(bus_idx)
		AudioServer.set_bus_name(bus_idx, stream_name)
		if not stream_name == audio_manager.get_master():
			AudioServer.set_bus_mute(bus_idx, true)
		AudioServer.add_bus_effect(bus_idx, AudioEffectCapture.new())
		bus_idx += 1
		
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		@warning_ignore("unsafe_call_argument")
		player.set_stream(audio_manager.get_streams().get(stream_name))
		player.set_bus(stream_name)
		var err_bool: bool = players.set(stream_name, player)
		if not err_bool:
			printerr("Could not set player to player dictionary.")
			return
		add_child(player)
		
		master_player = players.get(&"Master")
		if master_player.stream == null:
			printerr("Master player stream is null.")
			return

func _connect_all_signals() -> Error:
	var err: Error = play_pause_button.connect("pressed", _on_play_pause_pressed)
	if err:
		return FAILED
	err = stop_button.connect("pressed", _on_stop_pressed)
	if err:
		return FAILED
	err = loop_button.connect("toggled", _on_loop_toggled)
	if err:
		return FAILED
	err = volume_slider.connect("value_changed", _on_volume_value_changed)
	if err:
		return FAILED
	err = time_slider.connect("value_changed", _on_time_slider_value_changed)
	if err:
		return FAILED
	
	err = audio_manager.connect("audio_files_changed", _update_players)
	if err:
		return FAILED
	
	return OK

func _on_play_pause_pressed() -> void:
	master_player.set_playing(not master_player.playing)

func _on_stop_pressed() -> void:
	master_player.stop()

func _on_loop_toggled(p_toggled_on: bool) -> void:
	pass

func _on_volume_value_changed() -> void:
	pass

func _on_time_slider_value_changed() -> void:
	pass

func _on_master_finished() -> void:
	pass
