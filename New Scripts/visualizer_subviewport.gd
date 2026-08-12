# Oscillody
# Copyright (C) 2025-present Akosmo

# visualizer_subviewport.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

# NOTE: If this class has too many responsibilities, some of its functions should be moved elsewhere,
# without compromising readability, or without ending up with spaghetti code. Remember that bus needs to
# be accessed by Analyzer elements.

extends Node

var audio_manager: AudioManager
var _players: Dictionary[StringName, AudioStreamPlayer]
# This is not a special, separated instance. The player assigned to it is chosen from `_players`,
# and allows it to be audible.
# TODO: That needs to be rephrased. See external notes.
var _master_player: AudioStreamPlayer

func connect_player_signals() -> Error:
	if audio_manager.audio_files_changed.connect(_update_audio):
		return ERR_INVALID_PARAMETER
	if audio_manager.master_changed.connect(_on_master_changed):
		return ERR_INVALID_PARAMETER
	
	if audio_manager.play_pause_requested.connect(_on_play_pause_requested):
		return ERR_INVALID_PARAMETER
	if audio_manager.stop_requested.connect(_on_stop_requested):
		return ERR_INVALID_PARAMETER
	if audio_manager.volume_change_requested.connect(_on_volume_change_requested):
		return ERR_INVALID_PARAMETER
	if audio_manager.seek_requested.connect(_on_seek_requested):
		return ERR_INVALID_PARAMETER
	
	return OK

func _update_audio() -> void:
	_update_buses()
	_update_players()

func _update_buses() -> void:
	while AudioServer.get_bus_count() > 1:
		AudioServer.remove_bus(AudioServer.get_bus_count() - 1)
	
	var bus_idx: int = 1
	for stream_name: StringName in audio_manager.get_streams().keys():
		AudioServer.add_bus(bus_idx)
		AudioServer.set_bus_name(bus_idx, stream_name)
		AudioServer.set_bus_mute(bus_idx, true)
		AudioServer.add_bus_effect(bus_idx, AudioEffectCapture.new())
		AudioServer.set_bus_effect_enabled(bus_idx, 0, false)
		AudioServer.add_bus_effect(bus_idx, AudioEffectSpectrumAnalyzer.new())
		AudioServer.set_bus_effect_enabled(bus_idx, 1, false)
		bus_idx += 1

func _update_players() -> void:
	for player: StringName in _players.keys():
		@warning_ignore("unsafe_cast")
		remove_child(_players.get(player) as AudioStreamPlayer)
	
	_players.clear()
	
	var stream_dict: Dictionary[StringName, AudioStream] = audio_manager.get_streams()
	for stream_name: StringName in stream_dict.keys():
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		@warning_ignore("unsafe_call_argument")
		player.set_stream(stream_dict.get(stream_name))
		if player.get_stream() == null:
			printerr("Could not set {stream} to player.".format({"stream": stream_name}))
			return
		player.set_bus(stream_name)
		if not _players.set(stream_name, player):
			printerr("Could not set player to player dictionary.")
			return
		add_child(player)

func _on_master_changed() -> void:
	_on_stop_requested()
	
	if not audio_manager.get_master_name().is_empty():
		AudioServer.set_bus_mute(AudioServer.get_bus_index(audio_manager.get_master_name()), false)
	
	_master_player = _players.get(audio_manager.get_master_name())
	
	if _master_player != null:
		_master_player.set_volume_linear(audio_manager.get_master_volume())

func _on_play_pause_requested() -> void:
	if _master_player != null:
		if is_zero_approx(_master_player.get_playback_position()):
			_master_player.play()
		else:
			_master_player.set_stream_paused(_master_player.is_playing())
		audio_manager.set_master_playing(_master_player.is_playing())

func _on_stop_requested() -> void:
	if _master_player != null:
		_master_player.stop()
		audio_manager.set_master_playing(false)

func _on_volume_change_requested() -> void:
	if _master_player != null:
		_master_player.set_volume_linear(audio_manager.get_master_volume())

func _on_seek_requested(p_time: float) -> void:
	if _master_player != null:
		pass
