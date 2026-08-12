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

var audio_manager: AudioManager

@onready var _play_pause_button: Button = %PlayPauseButton
@onready var _stop_button: Button = %StopButton
@onready var _loop_button: Button = %LoopButton
@onready var _volume_slider: HSlider = %VolumeSlider
@onready var _volume_label: Label = %VolumeLabel
@onready var _time_slider: HSlider = %TimeSlider
@onready var _time_label: Label = %TimeLabel

# Shortcut doesn't work if button is not visible in tree.
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("play_pause"):
		audio_manager.request_play_pause()

func connect_all_signals() -> Error:
	if _play_pause_button.pressed.connect(_on_play_pause_pressed):
		return ERR_INVALID_PARAMETER
	if _stop_button.pressed.connect(_on_stop_pressed):
		return ERR_INVALID_PARAMETER
	if _loop_button.toggled.connect(_on_loop_toggled):
		return ERR_INVALID_PARAMETER
	if _volume_slider.value_changed.connect(_on_volume_value_changed):
		return ERR_INVALID_PARAMETER
	if _time_slider.value_changed.connect(_on_time_slider_value_changed):
		return ERR_INVALID_PARAMETER
	
	if audio_manager.master_play_state_changed.connect(_on_master_play_state_changed):
		return ERR_INVALID_PARAMETER
	
	return OK

func _on_play_pause_pressed() -> void:
	audio_manager.request_play_pause()

func _on_stop_pressed() -> void:
	audio_manager.request_stop()

func _on_loop_toggled(p_toggled_on: bool) -> void:
	audio_manager.enable_loop(p_toggled_on)

func _on_volume_value_changed(p_value: float) -> void:
	audio_manager.request_volume_change(p_value)
	_volume_label.set_text(str(roundi(p_value * 100.0)) + "%")

func _on_time_slider_value_changed(p_value: float) -> void:
	audio_manager.request_seek(p_value)

func _on_master_play_state_changed() -> void:
	if audio_manager.is_master_playing():
		_play_pause_button.set_text("PAUSE")
	else:
		_play_pause_button.set_text("PLAY")
