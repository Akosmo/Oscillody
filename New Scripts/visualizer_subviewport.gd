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

extends SubViewportContainer

var _players: Dictionary[StringName, AudioStreamPlayer]
# This is not a special, separated instance. The player assigned to it is chosen from `_players`,
# and allows it to be audible.
var _master_player: AudioStreamPlayer

var element_empty_scene: PackedScene = PackedScene.new()
var element_analyzer_scene: PackedScene = PackedScene.new()
var element_image_scene: PackedScene = PackedScene.new()
var element_shader_scene: PackedScene = PackedScene.new()
var element_text_scene: PackedScene = PackedScene.new()
var element_visual_effect_scene: PackedScene = PackedScene.new()

@onready var _sub_viewport: SubViewport = $SubViewport
@onready var _frozen_visualizer_canvas_layer: CanvasLayer = %FrozenVisualizerCanvasLayer
@onready var _texture_rect: TextureRect = %TextureRect

func _ready() -> void:
	if OS.has_feature("movie"):
		CustomLogger.log_normal("Oscillody fully launched in Movie Writer mode.")
	
	if _pack_canvas_nodes():
		CustomLogger.log_critical_error("Could not pack canvas nodes.")
	
	WindowUtilities.set_subviewport(_sub_viewport)
	
	_connect_signals()
	
	if OS.has_feature("movie"):
		CustomLogger.log_normal("Initializing nodes.")
		if await MovieWriterUtilities.initialize_nodes():
			get_tree().quit(1)

func _process(_p_delta: float) -> void:
	if _master_player != null and _master_player.get_stream() != null:
		if AudioManager.is_master_playing():
			AudioManager.set_master_position(_master_player.get_playback_position())
	
	# Subtract one: the ColorRect and CanvasLayer nodes.
	DebugUtilities.set_element_canvas_count(_sub_viewport.get_child_count() - 2)

func _pack_canvas_nodes() -> Error:
	var element_canvas_empty: ElementCanvasEmpty = ElementCanvasEmpty.new()
	var element_canvas_analyzer: ElementCanvasAnalyzer = ElementCanvasAnalyzer.new()
	var element_canvas_image: ElementCanvasImage = ElementCanvasImage.new()
	var element_canvas_shader: ElementCanvasShader = ElementCanvasShader.new()
	var element_canvas_text: ElementCanvasText = ElementCanvasText.new()
	var element_canvas_visual_effect: ElementCanvasVisualEffect = ElementCanvasVisualEffect.new()
	
	if element_empty_scene.pack(element_canvas_empty):
		return Error.FAILED
	if element_analyzer_scene.pack(element_canvas_analyzer):
		return Error.FAILED
	if element_image_scene.pack(element_canvas_image):
		return Error.FAILED
	if element_shader_scene.pack(element_canvas_shader):
		return Error.FAILED
	if element_text_scene.pack(element_canvas_text):
		return Error.FAILED
	if element_visual_effect_scene.pack(element_canvas_visual_effect):
		return Error.FAILED
	
	# Avoiding leaks.
	element_canvas_empty.free()
	element_canvas_analyzer.free()
	element_canvas_image.free()
	element_canvas_shader.free()
	element_canvas_text.free()
	element_canvas_visual_effect.free()
	
	return Error.OK

func _connect_signals() -> void:
	AudioManager.stream_list_updated.connect(_update_audio)
	AudioManager.master_changed.connect(_on_master_changed)
	
	AudioManager.play_pause_requested.connect(_on_play_pause_requested)
	AudioManager.stop_requested.connect(_on_stop_requested)
	AudioManager.volume_change_requested.connect(_on_volume_change_requested)
	AudioManager.seek_requested.connect(_on_seek_requested)
	
	ElementManager.element_created.connect(_on_element_created)
	ElementManager.element_deleted.connect(_on_element_deleted)
	ElementManager.element_type_changed.connect(_on_element_type_changed)
	
	DebugUtilities.freeze_visualizer_changed.connect(_on_freeze_visualizer)

func _play_streams(p_at_pos: float = 0.0) -> void:
	for player: AudioStreamPlayer in _players.values():
		if player != null and player.get_stream() != null:
			player.play(p_at_pos)

func _pause_streams(p_paused: bool) -> void:
	for player: AudioStreamPlayer in _players.values():
		if player != null and player.get_stream() != null:
			player.set_stream_paused(p_paused)

func _seek_streams(p_time: float) -> void:
	for player: AudioStreamPlayer in _players.values():
		if player != null and player.get_stream() != null:
			player.seek(p_time)

func _stop_streams() -> void:
	for player: AudioStreamPlayer in _players.values():
		if player != null and player.get_stream() != null:
			player.stop()

func _update_audio() -> void:
	_update_buses()
	_update_players()

func _update_buses() -> void:
	while AudioServer.get_bus_count() > 1:
		AudioServer.remove_bus(AudioServer.get_bus_count() - 1)
	
	var bus_idx: int = 1
	for stream_name: StringName in AudioManager.get_stream_names().values():
		AudioServer.add_bus(bus_idx)
		AudioServer.set_bus_name(bus_idx, stream_name)
		AudioServer.set_bus_mute(bus_idx, true)
		AudioServer.add_bus_effect(bus_idx, AudioEffectSpectrumAnalyzer.new())
		bus_idx += 1

func _update_players() -> void:
	for player: AudioStreamPlayer in _players.values():
		player.queue_free()
	
	_players.clear()
	
	var stream_dict: Dictionary[StringName, AudioStream] = AudioManager.get_streams()
	var name_dict: Dictionary[StringName, StringName] = AudioManager.get_stream_names()
	for stream_key: StringName in stream_dict.keys():
		var stream_name: StringName = name_dict.get(stream_key)
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		player.set_stream(stream_dict.get(stream_key))
		if player.get_stream() == null:
			CustomLogger.log_critical_error("Could not set {stream} to player.".format({"stream": stream_name}))
			return
		player.set_bus(stream_name)
		if not _players.set(stream_name, player):
			CustomLogger.log_critical_error("Could not set player to player dictionary.")
			return
		add_child(player)
	
	DebugUtilities.set_audio_players(_players)

func _on_master_changed() -> void:
	# Clean-up (if needed) and changing to a valid Master.
	_on_stop_requested()
	
	if _master_player != null and _master_player.finished.is_connected(_on_master_finished):
		_master_player.finished.disconnect(_on_master_finished)
	
	_master_player = null
	
	if not AudioManager.get_master_name().is_empty():
		for bus_idx: int in AudioServer.get_bus_count():
			if bus_idx == 0:
				continue
			AudioServer.set_bus_mute(
				bus_idx,
				not StringName(AudioServer.get_bus_name(bus_idx)) == AudioManager.get_master_name()
			)
	
	# Set-up.
	if not AudioManager.get_master_name().is_empty():
		_master_player = _players.get(AudioManager.get_master_name())
	
	if _master_player != null:
		if not _master_player.finished.is_connected(_on_master_finished):
			_master_player.finished.connect(_on_master_finished)
		
		if _master_player.get_stream() != null:
			AudioManager.set_master_duration(_master_player.get_stream().get_length())

func _on_play_pause_requested() -> void:
	if _master_player != null:
		# If Master Player is stopped.
		if not AudioManager.is_master_playing() and not _master_player.get_stream_paused():
			# User can seek while Master Player is stopped.
			_play_streams(AudioManager.get_master_position())
			AudioManager.set_master_playing(true)
		else:
			# Master Player is either playing or paused.
			_pause_streams(AudioManager.is_master_playing())
			# If user seeked while the Master Player was paused.
			if _master_player.get_playback_position() != AudioManager.get_master_position():
				if (
					AudioManager.get_master_position() < AudioManager.get_master_duration() or
					AudioManager.is_loop_enabled()
				):
					_seek_streams(AudioManager.get_master_position())
					AudioManager.set_master_playing(not AudioManager.is_master_playing())
				else:
					# If user seeked at or past duration and looping is disabled.
					# Seeking at the exact duration just loops back, so avoid that.
					_seek_streams(AudioManager.get_master_position() - 0.01)
			else:
				AudioManager.set_master_playing(not AudioManager.is_master_playing())
		

func _on_stop_requested() -> void:
	if _master_player != null:
		_stop_streams()
	
	AudioManager.set_master_position(0.0)
	AudioManager.set_master_playing(false)

func _on_volume_change_requested() -> void:
	AudioServer.set_bus_volume_linear(0, AudioManager.get_master_volume())

func _on_seek_requested(p_time: float) -> void:
	if _master_player != null:
		if p_time < AudioManager.get_master_duration() or AudioManager.is_loop_enabled():
			_seek_streams(p_time)
		else:
			# Seeking at the exact duration just loops back, so avoid that.
			_seek_streams(p_time - 0.01)

func _on_master_finished() -> void:
	if OS.has_feature("movie"):
		CustomLogger.log_normal("Video exporting has finished.")
		get_tree().quit()
	
	if AudioManager.is_loop_enabled():
		_play_streams()
	else:
		AudioManager.set_master_position(0.0)
		AudioManager.set_master_playing(false)

func _on_element_created(p_element: Element) -> void:
	match p_element.get_element_type():
		Element.ElementType.EMPTY:
			var node_instance: ElementCanvasEmpty = element_empty_scene.instantiate()
			node_instance.element = p_element
			_sub_viewport.add_child(node_instance)
		Element.ElementType.ANALYZER:
			var node_instance: ElementCanvasAnalyzer = element_analyzer_scene.instantiate()
			node_instance.element = p_element
			_sub_viewport.add_child(node_instance)
		Element.ElementType.IMAGE:
			var node_instance: ElementCanvasImage = element_image_scene.instantiate()
			node_instance.element = p_element
			_sub_viewport.add_child(node_instance)
		Element.ElementType.SHADER:
			var node_instance: ElementCanvasShader = element_shader_scene.instantiate()
			node_instance.element = p_element
			_sub_viewport.add_child(node_instance)
		Element.ElementType.TEXT:
			var node_instance: ElementCanvasText = element_text_scene.instantiate()
			node_instance.element = p_element
			_sub_viewport.add_child(node_instance)
		Element.ElementType.VISUAL_EFFECT:
			var node_instance: ElementCanvasVisualEffect = element_visual_effect_scene.instantiate()
			node_instance.element = p_element
			_sub_viewport.add_child(node_instance)
	
	_frozen_visualizer_canvas_layer.set_layer(ElementManager.get_element_count())

func _on_element_deleted(p_element: Element) -> void:
	for node: Node in _sub_viewport.get_children():
		if node is ElementCanvas and node.get_element() == p_element:
			node.queue_free()
	
	_frozen_visualizer_canvas_layer.set_layer(ElementManager.get_element_count())

func _on_element_type_changed(_p_old_element: Element, p_new_element: Element) -> void:
	_on_element_created(p_new_element)

func _on_freeze_visualizer(p_frozen: bool) -> void:
	CustomLogger.log_normal("Setting frozen visualizer status to: " + str(p_frozen))
	
	if p_frozen:
		var image_texture: ImageTexture
		image_texture = ImageTexture.create_from_image(_sub_viewport.get_texture().get_image())
		_texture_rect.set_texture(image_texture)
	else:
		_texture_rect.set_texture(null)
	
	_frozen_visualizer_canvas_layer.set_visible(p_frozen)
	_texture_rect.set_visible(p_frozen)

func _notification(what: int) -> void:
	if OS.has_feature("movie") and what == NOTIFICATION_WM_CLOSE_REQUEST:
		CustomLogger.log_normal("Video exporting canceled manually.")
		AudioManager.request_stop()
		get_tree().quit(2)
