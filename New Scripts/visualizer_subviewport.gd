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

extends SubViewportContainer

var audio_manager: AudioManager
var _players: Dictionary[StringName, AudioStreamPlayer]
# This is not a special, separated instance. The player assigned to it is chosen from `_players`,
# and allows it to be audible.
# TODO: That needs to be rephrased. See external notes.
var _master_player: AudioStreamPlayer

var element_manager: ElementManager

var element_analyzer_node: ElementAnalyzer = ElementAnalyzer.new()
var element_analyzer_scene: PackedScene = PackedScene.new()

@onready var sub_viewport: SubViewport = $SubViewport

func _ready() -> void:
	if element_analyzer_scene.pack(element_analyzer_node):
		printerr("Could not pack new node.")

func _process(_delta: float) -> void:
	if _master_player != null and _master_player.get_stream() != null:
		if audio_manager.is_master_playing():
			audio_manager.set_master_position(_master_player.get_playback_position())

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
	
	if element_manager.element_created.connect(_on_element_created):
		return ERR_INVALID_PARAMETER
	if element_manager.element_deleted.connect(_on_element_deleted):
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
	
	_master_player = null
	
	if not audio_manager.get_master_name().is_empty():
		AudioServer.set_bus_mute(AudioServer.get_bus_index(audio_manager.get_master_name()), false)
	
	if _master_player != null and _master_player.finished.is_connected(_on_master_finished):
		_master_player.finished.disconnect(_on_master_finished)
	
	if not audio_manager.get_master_name().is_empty():
		_master_player = _players.get(audio_manager.get_master_name())
	
	if _master_player != null:
		_master_player.set_volume_linear(audio_manager.get_master_volume())
		
		if _master_player.finished.connect(_on_master_finished):
			printerr("Could not connect finished signal from the master player.")
			return
		
		if _master_player.get_stream() != null:
			audio_manager.set_master_duration(_master_player.get_stream().get_length())
	else:
		audio_manager.set_master_duration(0.0)

func _on_play_pause_requested() -> void:
	if _master_player != null:
		if not audio_manager.is_master_playing() and not _master_player.get_stream_paused():
			_master_player.play(audio_manager.get_master_position())
			audio_manager.set_master_playing(true)
		else:
			_master_player.set_stream_paused(audio_manager.is_master_playing())
			if _master_player.get_playback_position() != audio_manager.get_master_position():
				if (
					audio_manager.get_master_position() < audio_manager.get_master_duration() or
					audio_manager.is_loop_enabled()
				):
					_master_player.seek(audio_manager.get_master_position())
					audio_manager.set_master_playing(not audio_manager.is_master_playing())
				else:
					_master_player.seek(audio_manager.get_master_position() - 0.01)
			else:
				audio_manager.set_master_playing(not audio_manager.is_master_playing())
		

func _on_stop_requested() -> void:
	if _master_player != null:
		_master_player.stop()
	
	# Just in case... mostly needed in case the master is cleared.
	audio_manager.set_master_position(0.0)
	audio_manager.set_master_playing(false)

func _on_volume_change_requested() -> void:
	if _master_player != null:
		_master_player.set_volume_linear(audio_manager.get_master_volume())

func _on_seek_requested(p_time: float) -> void:
	if _master_player != null:
		if p_time < audio_manager.get_master_duration() or audio_manager.is_loop_enabled():
			_master_player.seek(p_time)
		else:
			_master_player.seek(p_time - 0.01)

func _on_master_finished() -> void:
	if audio_manager.is_loop_enabled():
		_master_player.play()
	else:
		audio_manager.set_master_position(0.0)
		audio_manager.set_master_playing(false)

func _on_element_created(p_element_uid: int) -> void:
	match element_manager.get_element_property(p_element_uid, element_manager.TYPE):
		element_manager.ElementType.EMPTY:
			pass
		element_manager.ElementType.ANALYZER:
			var node_instance: ElementAnalyzer = element_analyzer_scene.instantiate()
			node_instance.element_manager = element_manager
			node_instance.element_uid = p_element_uid
			sub_viewport.add_child(node_instance)
			node_instance.setup_element()
		element_manager.ElementType.GRADIENT:
			pass
		element_manager.ElementType.IMAGE:
			pass
		element_manager.ElementType.POST_PROCESSING:
			pass
		element_manager.ElementType.SHADER:
			pass
		element_manager.ElementType.SHAPE:
			pass
		element_manager.ElementType.SOLID_COLOR:
			pass
		element_manager.ElementType.TEXT:
			pass

func _on_element_deleted(p_element_uid: int) -> void:
	for node: Node in sub_viewport.get_children():
		if node.get_name().containsn(str(p_element_uid)):
			sub_viewport.remove_child(node)
