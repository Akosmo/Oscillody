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

extends Control

# This script handles the player control part of the app.

#region NODES ##################################

@onready var play_pause_button: Button = %PlayPauseButton
@onready var stop_button: Button = %StopButton
@onready var loop_button: Button = %LoopButton
@onready var vol_slider: HSlider = %VolSlider
@onready var vol_amt_display: Label = %VolAmtDisplay
@onready var seek_slider: HSlider = %SeekSlider
@onready var seek_time_display: Label = %SeekTimeDisplay
@onready var audio_pos_hint: Label = %AudioPosHint

#endregion ##################################

#region PLAYER CONTROL VARIABLES ##################################

# Grabber is 16x16. Divide by 2...
const GRABBER_OFFSET: float = 8.0

var user_seeking: bool = false
var mouse_x_pos: String
var mouse_x_pos_remapped: float
var audio_pos_mouse: float

var pos_mins: String
var pos_secs: String

var pos_mins_mouse: String
var pos_secs_mouse: String

var hint_offset: int = 6

var dur_mins: String
var dur_secs: String

#endregion ##################################

func _ready() -> void:
	MainUtils.update_visualizer.connect(update_player_control)
	MainUtils.audio_stopped.connect(audio_stopped)
	MainUtils.audio_finished.connect(audio_finished)
	MainUtils.audio_file_selected.connect(reset_player)
	update_player_control()

func _process(_delta: float) -> void:
	seek_slider.max_value = MainUtils.audio_duration
	if not user_seeking:
		seek_slider.set_value_no_signal(MainUtils.audio_position)
	
	pos_mins = str(floori(MainUtils.audio_position / 60.0))
	pos_secs = str(int(fmod(MainUtils.audio_position, 60.0))).pad_zeros(2)
	dur_mins = str(floori(MainUtils.audio_duration / 60.0))
	dur_secs = str(int(fmod(MainUtils.audio_duration, 60.0))).pad_zeros(2)
	
	seek_time_display.text = "{pm}:{ps} | {dm}:{ds}".format(
		{"pm": pos_mins, "ps": pos_secs,
		"dm": dur_mins, "ds": dur_secs}
		)

# Shortcut doesn't work if button is not visible in tree.
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("play_pause") and not MainUtils.ui_visible and play_pause_button.text == "Play":
		play_pause_button.pressed.emit()
	elif event.is_action_pressed("play_pause") and not MainUtils.ui_visible and play_pause_button.text != "Play":
		play_pause_button.pressed.emit()

func update_player_control() -> void:
	vol_slider.custom_minimum_size.x = MainUtils.window_size.x / 12.0
	# 720 = space (in pixels) used by buttons, margins, labels, and panel.
	seek_slider.custom_minimum_size.x = MainUtils.window_size.x - (720.0 + vol_slider.custom_minimum_size.x)

func audio_stopped() -> void:
	play_pause_button.text = "Play"

func audio_finished() -> void:
	if not MainUtils.loop_enabled:
		play_pause_button.text = "Play"

func reset_player() -> void:
	play_pause_button.text = "Play"

#region PLAYER CONTROL BUILT-IN SIGNAL FUNCTIONS ##################################

func _on_play_pause_button_pressed() -> void:
	if GlobalVariables.master_audio_path != "":
		if MainUtils.audio_playing:
			play_pause_button.text = "Play"
			MainUtils.audio_paused.emit()
		else:
			play_pause_button.text = "Pause"
			MainUtils.audio_played.emit()

func _on_stop_button_pressed() -> void:
	if GlobalVariables.master_audio_path != "":
		MainUtils.audio_stopped.emit()

func _on_loop_button_toggled(toggled_on: bool) -> void:
	MainUtils.loop_enabled = toggled_on

func _on_vol_slider_value_changed(value: float) -> void:
	vol_amt_display.text = str(roundi(value * 100.0)) + "%"
	MainUtils.new_volume_in_db = linear_to_db(value)

func _on_seek_slider_gui_input(event: InputEvent) -> void:
	if "pressed=true" in str(event) and "mask=1" in str(event) and "Mouse" in str(event):
		user_seeking = true
	
	# Get audio position to show on a label based on where the mouse is.
	if GlobalVariables.master_audio_path != "" and "position=" in str(event):
		var slice_idx: int = 0
		var event_array: PackedStringArray = str(event).split(", ")
		for slice: String in event_array:
			if slice.contains("position"):
				break
			else:
				slice_idx += 1
		mouse_x_pos = str(event).get_slice(", ", slice_idx).replace("position=((", "")
		mouse_x_pos_remapped = clampf(
			remap(
				mouse_x_pos.to_float(),
				GRABBER_OFFSET,
				seek_slider.custom_minimum_size.x - GRABBER_OFFSET,
				0.0,
				1.0
				),
			0.0,
			1.0
			)
		
		audio_pos_mouse = remap(
			mouse_x_pos_remapped,
			0.0,
			1.0,
			0.0,
			seek_slider.max_value
			)
			
		pos_mins_mouse = str(floori(audio_pos_mouse / 60.0))
		pos_secs_mouse = str(int(fmod(audio_pos_mouse, 60.0))).pad_zeros(2)
		audio_pos_hint.text = pos_mins_mouse + ":" + pos_secs_mouse
		
		if audio_pos_hint.text.length() == 4:
			hint_offset = 6
		else:
			hint_offset = 12
		
		audio_pos_hint.position.x = remap(
			clampf(mouse_x_pos.to_float(), 0.0, seek_slider.custom_minimum_size.x) \
			/ seek_slider.custom_minimum_size.x,
			0.0,
			1.0,
			seek_slider.position.x,
			seek_slider.position.x + seek_slider.custom_minimum_size.x
			) - hint_offset

func _on_seek_slider_drag_ended(_value_changed: bool) -> void:
	user_seeking = false
	if GlobalVariables.master_audio_path != "":
		MainUtils.audio_pos_changed.emit()

func _on_seek_slider_value_changed(value: float) -> void:
	if user_seeking:
		MainUtils.new_audio_pos_from_seek = value

func _on_seek_slider_mouse_entered() -> void:
	audio_pos_hint.visible = true

func _on_seek_slider_mouse_exited() -> void:
	audio_pos_hint.visible = false

func _on_panel_container_gui_input(event: InputEvent) -> void:
	if "pressed=true" in str(event):
		get_viewport().gui_release_focus()

#endregion ##################################
