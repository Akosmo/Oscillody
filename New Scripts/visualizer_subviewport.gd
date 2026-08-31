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

# TEST: Importing audio files with the same name and extension.
var _players: Dictionary[StringName, AudioStreamPlayer]
# This is not a special, separated instance. The player assigned to it is chosen from `_players`,
# and allows it to be audible.
# TODO: That needs to be rephrased. See external notes.
var _master_player: AudioStreamPlayer

var element_empty_scene: PackedScene = PackedScene.new()
var element_analyzer_scene: PackedScene = PackedScene.new()

@onready var sub_viewport: SubViewport = $SubViewport

func _ready() -> void:
	if element_empty_scene.pack(ElementCanvasEmpty.new()):
		printerr("Could not pack node.")
	if element_analyzer_scene.pack(ElementCanvasAnalyzer.new()):
		printerr("Could not pack node.")
	
	WindowUtilities.set_subviewport_size(sub_viewport.get_size())
	
	if _connect_signals():
		printerr("Could not connect signals.")

func _process(_delta: float) -> void:
	if _master_player != null and _master_player.get_stream() != null:
		if AudioManager.is_master_playing():
			AudioManager.set_master_position(_master_player.get_playback_position())
	
	WindowUtilities.set_subviewport_size(sub_viewport.get_size())

func _connect_signals() -> Error:
	if AudioManager.stream_list_updated.connect(_update_audio):
		return ERR_INVALID_PARAMETER
	if AudioManager.master_changed.connect(_on_master_changed):
		return ERR_INVALID_PARAMETER
	
	if AudioManager.play_pause_requested.connect(_on_play_pause_requested):
		return ERR_INVALID_PARAMETER
	if AudioManager.stop_requested.connect(_on_stop_requested):
		return ERR_INVALID_PARAMETER
	if AudioManager.volume_change_requested.connect(_on_volume_change_requested):
		return ERR_INVALID_PARAMETER
	if AudioManager.seek_requested.connect(_on_seek_requested):
		return ERR_INVALID_PARAMETER
	
	if ElementManager.element_created.connect(_on_element_created):
		return ERR_INVALID_PARAMETER
	if ElementManager.element_deleted.connect(_on_element_deleted):
		return ERR_INVALID_PARAMETER
	if ElementManager.element_type_changed.connect(_on_element_created):
		return ERR_INVALID_PARAMETER
	
	return OK

func _update_audio() -> void:
	_update_buses()
	_update_players()

func _update_buses() -> void:
	while AudioServer.get_bus_count() > 1:
		AudioServer.remove_bus(AudioServer.get_bus_count() - 1)
	
	var bus_idx: int = 1
	for stream_name: StringName in AudioManager.get_streams().keys():
		AudioServer.add_bus(bus_idx)
		AudioServer.set_bus_name(bus_idx, stream_name)
		AudioServer.set_bus_mute(bus_idx, true)
		AudioServer.add_bus_effect(bus_idx, AudioEffectCapture.new())
		#AudioServer.set_bus_effect_enabled(bus_idx, 0, false)
		AudioServer.add_bus_effect(bus_idx, AudioEffectSpectrumAnalyzer.new())
		#AudioServer.set_bus_effect_enabled(bus_idx, 1, false)
		bus_idx += 1

func _update_players() -> void:
	for player: StringName in _players.keys():
		@warning_ignore("unsafe_cast")
		remove_child(_players.get(player) as AudioStreamPlayer)
	
	_players.clear()
	
	var stream_dict: Dictionary[StringName, AudioStream] = AudioManager.get_streams()
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
	# Clean-up (if needed) and changing to a valid Master.
	_on_stop_requested()
	
	_master_player = null
	
	if not AudioManager.get_master_name().is_empty():
		AudioServer.set_bus_mute(AudioServer.get_bus_index(AudioManager.get_master_name()), false)
	
	if _master_player != null and _master_player.finished.is_connected(_on_master_finished):
		_master_player.finished.disconnect(_on_master_finished)
	
	# Set-up.
	if not AudioManager.get_master_name().is_empty():
		_master_player = _players.get(AudioManager.get_master_name())
	
	if _master_player != null:
		_master_player.set_volume_linear(AudioManager.get_master_volume())
		
		if not _master_player.finished.is_connected(_on_master_finished):
			if _master_player.finished.connect(_on_master_finished):
				printerr("Could not connect finished signal from the Master Player.")
		
		if _master_player.get_stream() != null:
			AudioManager.set_master_duration(_master_player.get_stream().get_length())
	#else:
		#AudioManager.set_master_duration(0.0)

func _on_play_pause_requested() -> void:
	if _master_player != null:
		# If Master Player is stopped.
		if not AudioManager.is_master_playing() and not _master_player.get_stream_paused():
			# User can seek while Master Player is stopped.
			_master_player.play(AudioManager.get_master_position())
			AudioManager.set_master_playing(true)
		else:
			# Master Player is either playing or paused.
			_master_player.set_stream_paused(AudioManager.is_master_playing())
			# If user seeked while the Master Player was paused.
			if _master_player.get_playback_position() != AudioManager.get_master_position():
				if (
					AudioManager.get_master_position() < AudioManager.get_master_duration() or
					AudioManager.is_loop_enabled()
				):
					_master_player.seek(AudioManager.get_master_position())
					AudioManager.set_master_playing(not AudioManager.is_master_playing())
				else:
					# If user seeked at or past duration and looping is disabled.
					# Seeking at the exact duration just loops back, so avoid that.
					_master_player.seek(AudioManager.get_master_position() - 0.01)
			else:
				AudioManager.set_master_playing(not AudioManager.is_master_playing())
		

func _on_stop_requested() -> void:
	if _master_player != null:
		_master_player.stop()
	
	AudioManager.set_master_position(0.0)
	AudioManager.set_master_playing(false)

func _on_volume_change_requested() -> void:
	if _master_player != null:
		AudioServer.set_bus_volume_linear(0, AudioManager.get_master_volume())

func _on_seek_requested(p_time: float) -> void:
	if _master_player != null:
		if p_time < AudioManager.get_master_duration() or AudioManager.is_loop_enabled():
			_master_player.seek(p_time)
		else:
			# Seeking at the exact duration just loops back, so avoid that.
			_master_player.seek(p_time - 0.01)

func _on_master_finished() -> void:
	if AudioManager.is_loop_enabled():
		_master_player.play()
	else:
		AudioManager.set_master_position(0.0)
		AudioManager.set_master_playing(false)

func _on_element_created(p_element: Element) -> void:
	match p_element.get_type():
		Element.ElementType.EMPTY:
			var node_instance: ElementCanvasEmpty = element_empty_scene.instantiate()
			node_instance.element = p_element
			sub_viewport.add_child(node_instance)
		Element.ElementType.ANALYZER:
			var node_instance: ElementCanvasAnalyzer = element_analyzer_scene.instantiate()
			node_instance.element = p_element
			sub_viewport.add_child(node_instance)
		Element.ElementType.IMAGE:
			pass
		Element.ElementType.POST_PROCESSING:
			pass
		Element.ElementType.SHADER:
			pass
		Element.ElementType.SHAPE:
			pass
		Element.ElementType.TEXT:
			pass

func _on_element_deleted(p_element: Element) -> void:
	for node: Node in sub_viewport.get_children():
		if node.get_name().containsn(str(p_element.get_unique_id())):
			sub_viewport.remove_child(node)
