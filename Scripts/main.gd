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

extends CanvasLayer

var _is_ui_visible: bool
var _mouse_moving: bool

var _fading_logo_rect: TextureRect
var _fading_background_rect: TextureRect
var _launch_audio_player: AudioStreamPlayer

@onready var _mouse_timer: Timer = $MouseTimer

@onready var _main_container: PanelContainer = %MainContainer
@onready var _debug_container: PanelContainer = %DebugContainer
@onready var _player_control_container: PanelContainer = %PlayerControlContainer

@onready var _close_request_popup: CustomPopup = $CloseRequestPopup

func _ready() -> void:
	_is_ui_visible = true
	
	_mouse_timer.timeout.connect(_on_mouse_timer_timeout)
	
	CustomLogger.log_normal("Oscillody fully launched.")
	
	_fading_logo_rect = TextureRect.new()
	_fading_logo_rect.set_texture(preload("uid://ctpaskguaxpuu"))
	_fading_logo_rect.set_expand_mode(TextureRect.ExpandMode.EXPAND_IGNORE_SIZE)
	_fading_logo_rect.set_anchors_preset(Control.LayoutPreset.PRESET_FULL_RECT)
	_fading_logo_rect.set_pivot_offset(WindowUtilities.get_window_size() * 0.5)
	add_child(_fading_logo_rect)
	move_child(_fading_logo_rect, 4) # Just behind the popups in the tree.
	
	_fading_background_rect = TextureRect.new()
	_fading_background_rect.set_texture(preload("uid://by6gjepqa5s2y"))
	_fading_background_rect.set_expand_mode(TextureRect.ExpandMode.EXPAND_IGNORE_SIZE)
	_fading_background_rect.set_anchors_preset(Control.LayoutPreset.PRESET_FULL_RECT)
	add_child(_fading_background_rect)
	move_child(_fading_background_rect, 4) # Just behind the logo in the tree.
	
	var tween: Tween
	tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EaseType.EASE_IN).set_trans(Tween.TransitionType.TRANS_BACK)
	tween.tween_method(_fading_logo_rect.set_scale, Vector2.ONE, Vector2.ONE * 1.5, 0.25)
	tween.tween_method(_fading_logo_rect.set_modulate, Color.WHITE, Color(1.0, 1.0, 1.0, 0.0), 0.25)
	tween.tween_method(_fading_background_rect.set_modulate, Color.WHITE, Color(1.0, 1.0, 1.0, 0.0), 0.25)
	tween.finished.connect(_on_tween_finished, CONNECT_ONE_SHOT)
	
	_launch_audio_player = AudioStreamPlayer.new()
	_launch_audio_player.set_stream(preload("uid://og7aec2o5dkr"))
	_launch_audio_player.set_autoplay(true)
	add_child(_launch_audio_player)
	_launch_audio_player.finished.connect(_on_audio_finished, CONNECT_ONE_SHOT)

func _process(_p_delta: float) -> void:
	if _is_ui_visible or _close_request_popup.is_visible():
		if not _mouse_timer.is_stopped():
			_mouse_timer.stop()
		if DisplayServer.mouse_get_mode() == DisplayServer.MouseMode.MOUSE_MODE_HIDDEN:
			DisplayServer.mouse_set_mode(DisplayServer.MouseMode.MOUSE_MODE_VISIBLE)
		return
	
	_mouse_moving = Input.get_last_mouse_velocity().length() != 0.0
	
	if not _mouse_moving and _mouse_timer.is_stopped():
		_mouse_timer.start()
	elif _mouse_moving:
		if not _mouse_timer.is_stopped():
			_mouse_timer.stop()
		if DisplayServer.mouse_get_mode() == DisplayServer.MouseMode.MOUSE_MODE_HIDDEN:
			DisplayServer.mouse_set_mode(DisplayServer.MouseMode.MOUSE_MODE_VISIBLE)

func _unhandled_key_input(event: InputEvent) -> void:
	var is_fullscreen: bool = DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN
	
	if event.is_action_pressed("fullscreen") and not is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
		is_fullscreen = true
	elif event.is_action_pressed("fullscreen") and is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WindowFlags.WINDOW_FLAG_BORDERLESS, false)
		is_fullscreen = false
	
	if event.is_action_pressed("toggle_ui"):
		_main_container.set_visible(not _is_ui_visible)
		if SettingsManager.get_debug_panel():
			_debug_container.set_visible(not _is_ui_visible)
		_player_control_container.set_visible(not _is_ui_visible)
		_is_ui_visible = not _is_ui_visible

func _on_mouse_timer_timeout() -> void:
	if DisplayServer.mouse_get_mode() == DisplayServer.MouseMode.MOUSE_MODE_VISIBLE:
		DisplayServer.mouse_set_mode(DisplayServer.MouseMode.MOUSE_MODE_HIDDEN)

func _on_tween_finished() -> void:
	_fading_logo_rect.queue_free()
	_fading_background_rect.queue_free()

func _on_audio_finished() -> void:
	_launch_audio_player.queue_free()
