# Oscillody
# Copyright (C) 2025-present Akosmo

# player_control.gd is part of Oscillody.
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

# This represents the size of the grabber divided by 2.
const _GRABBER_OFFSET: float = 8.0
const _HINT_Y_POSITION: float = -40.0

var _position_secs: String
var _position_mins: String
var _duration_secs: String
var _duration_mins: String

var _user_seeking: bool

var _mouse_motion: InputEventMouseMotion
var _mouse_x_position_remapped: float
var _audio_position_mouse: float
var _position_mins_mouse: String
var _position_secs_mouse: String
var _hint_position: Vector2
var _hint_position_offset: float

@onready var _play_pause_button: Button = %PlayPauseButton
@onready var _stop_button: Button = %StopButton
@onready var _loop_button: Button = %LoopButton
@onready var _volume_slider: HSlider = %VolumeSlider
@onready var _volume_label: Label = %VolumeLabel
@onready var _time_slider: HSlider = %TimeSlider
@onready var _time_label: Label = %TimeLabel

@onready var _time_slider_position_hint: Label = %TimeSliderPositionHint

func _ready() -> void:
	_time_slider.set_max(0.0)
	
	_duration_mins = str(0)
	_duration_secs = str(0).pad_zeros(2)
	
	_hint_position = Vector2(0.0, _HINT_Y_POSITION)
	
	_user_seeking = false
	
	if _connect_all_signals():
		printerr("Could not connect all signals.")

func _process(_delta: float) -> void:
	if not _user_seeking:
		_time_slider.set_value_no_signal(AudioManager.get_master_position())
	
	_position_mins = str(floori(AudioManager.get_master_position() / 60.0))
	_position_secs = str(int(fmod(AudioManager.get_master_position(), 60.0))).pad_zeros(2)
	
	_time_label.set_text(
		"{pm}:{ps} / {dm}:{ds}".format(
			{"pm": _position_mins, "ps": _position_secs,
			"dm": _duration_mins, "ds": _duration_secs}
		)
	)

# Shortcut doesn't work if button is not visible in tree.
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("play_pause"):
		AudioManager.request_play_pause()

func _connect_all_signals() -> Error:
	if _play_pause_button.pressed.connect(_on_play_pause_pressed):
		return ERR_INVALID_PARAMETER
	if _stop_button.pressed.connect(_on_stop_pressed):
		return ERR_INVALID_PARAMETER
	if _loop_button.toggled.connect(_on_loop_toggled):
		return ERR_INVALID_PARAMETER
	if _volume_slider.value_changed.connect(_on_volume_value_changed):
		return ERR_INVALID_PARAMETER
	if _time_slider.drag_started.connect(_on_time_slider_drag_started):
		return ERR_INVALID_PARAMETER
	if _time_slider.drag_ended.connect(_on_time_slider_drag_ended):
		return ERR_INVALID_PARAMETER
	if _time_slider.gui_input.connect(_on_time_slider_gui_input):
		return ERR_INVALID_PARAMETER
	if _time_slider.mouse_entered.connect(_on_time_slider_mouse_entered):
		return ERR_INVALID_PARAMETER
	if _time_slider.mouse_exited.connect(_on_time_slider_mouse_exited):
		return ERR_INVALID_PARAMETER
	
	# TODO: Add new_audio_imported here to reset player when streams are cleared.
	if AudioManager.master_changed.connect(_on_master_changed):
		return ERR_INVALID_PARAMETER
	if AudioManager.master_play_state_changed.connect(_on_master_play_state_changed):
		return ERR_INVALID_PARAMETER
	
	return OK

func _on_play_pause_pressed() -> void:
	AudioManager.request_play_pause()

func _on_stop_pressed() -> void:
	AudioManager.request_stop()

func _on_loop_toggled(p_toggled_on: bool) -> void:
	AudioManager.enable_loop(p_toggled_on)

func _on_volume_value_changed(p_value: float) -> void:
	AudioManager.request_volume_change(p_value)
	_volume_label.set_text(str(roundi(p_value * 100.0)) + "%")

func _on_time_slider_drag_started() -> void:
	_user_seeking = true

func _on_time_slider_drag_ended(_p_value_changed: bool) -> void:
	# FIXME: Can't seek while audio is paused...
	AudioManager.request_seek(_time_slider.get_value())
	_user_seeking = false

# TODO: Shift time by half a second to it always lands at the expected time.
# Currently, clicking at :10 for example, can either land at :10 or :11 in the audio.
func _on_time_slider_gui_input(p_event: InputEvent) -> void:
	if p_event is InputEventMouseMotion:
		_mouse_motion = p_event
	
	# Remapped.
	_mouse_x_position_remapped = clampf(
		(_mouse_motion.get_position().x - _GRABBER_OFFSET) / \
		(_time_slider.get_size().x - _GRABBER_OFFSET * 2.0),
		0.0,
		1.0
	)
	
	# Remapped.
	_audio_position_mouse = _time_slider.get_max() * _mouse_x_position_remapped
	
	_position_mins_mouse = str(floori(_audio_position_mouse / 60.0))
	_position_secs_mouse = str(int(fmod(_audio_position_mouse, 60.0))).pad_zeros(2)
	_time_slider_position_hint.set_text(_position_mins_mouse + ":" + _position_secs_mouse)
	
	if _time_slider_position_hint.get_text().length() == 4:
		_hint_position_offset = 6.0
	else:
		# TEST: Check with long files.
		_hint_position_offset = 12.0
	
	# Remapped.
	_hint_position.x = (_time_slider.get_position().x + \
	_time_slider.get_size().x * \
	(_mouse_motion.get_position().x / _time_slider.get_size().x)) - \
	_hint_position_offset - _time_slider_position_hint.get_position().x
	
	_time_slider_position_hint.set_offset_transform_position(_hint_position)

func _on_time_slider_mouse_entered() -> void:
	if not is_zero_approx(AudioManager.get_master_duration()):
		_time_slider_position_hint.set_visible(true)

func _on_time_slider_mouse_exited() -> void:
	_time_slider_position_hint.set_visible(false)

func _on_master_changed() -> void:
	_time_slider.set_max(AudioManager.get_master_duration())
	
	_duration_mins = str(floori(AudioManager.get_master_duration() / 60.0))
	_duration_secs = str(int(fmod(AudioManager.get_master_duration(), 60.0))).pad_zeros(2)

# TEST: Check how this changes on loop.
func _on_master_play_state_changed() -> void:
	if AudioManager.is_master_playing():
		_play_pause_button.set_text("PAUSE")
	else:
		_play_pause_button.set_text("PLAY")
