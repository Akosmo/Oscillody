# Oscillody
# Copyright (C) 2025-present Akosmo

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

# This script handles modification of audio data and waveform display, all in real-time.
# It is attached to a Node2D in a saved scene, instantiated on the scene Visualizer Screen.
# It relies on AudioEffectCapture to get audio data (see: main_utils script).

#region OSCILLOSCOPE VARIABLES ##################################

var waveform_number: int
var waveform_x_spacing: float
var waveform_y_pos: int
var waveform_color: Color

var waveform_points: PackedVector2Array # Array which will contain data for drawing waveform lines

var waveform_height: float
var adjust_to_window: float

var offset: float # Offset for a waveform's initial X position

var array_with_samples: PackedFloat32Array

#endregion ##################################

func _ready() -> void:
	MainUtils.update_visualizer.connect(update_oscilloscope)
	update_oscilloscope()

# Redraws canvas.
func _draw() -> void:
	for stem: int in GlobalVariables.number_of_stems:
		if GlobalVariables.number_of_stems > 1:
			waveform(GlobalVariables.waveform_configs[stem], MainUtils.audio_sample_buffers[stem])
		else:
			waveform(GlobalVariables.waveform_configs[stem], MainUtils.audio_sample_buffers[4])

# Runs as fast as possible (limited to 60 FPS).
func _process(_delta: float) -> void:
	queue_redraw() # Calls `_draw()`

func update_oscilloscope() -> void:
	waveform_height = GlobalVariables.waveform_height * 0.1
	
	# In theory, these numbers should work, always. But in some cases, the samples go out of bounds.
	# I think it's better that, in those cases, the user just lowers the height,
	# and give the opportunity for quiet audio to have tall waveforms too,
	# than try to make loud audio fit the window, but not let quiet audio be as tall.
	if GlobalVariables.vertical_layout and GlobalVariables.number_of_stems == 4:
		adjust_to_window = MainUtils.window_size.y * 0.125
	elif GlobalVariables.vertical_layout and GlobalVariables.number_of_stems == 3:
		adjust_to_window = MainUtils.window_size.y * 0.165
	elif ((not GlobalVariables.vertical_layout and GlobalVariables.number_of_stems > 1)
	or (GlobalVariables.vertical_layout and GlobalVariables.number_of_stems == 2)):
		adjust_to_window = MainUtils.window_size.y * 0.25
	else:
		adjust_to_window = MainUtils.window_size.y * 0.5
	
	waveform_height *= adjust_to_window

# Handles audio data and waveform display.
func waveform(waveform_configs: Array[Variant], buffers: Array) -> void:
	waveform_number = waveform_configs[0]
	waveform_x_spacing = waveform_configs[1]
	waveform_y_pos = waveform_configs[2]
	waveform_color = waveform_configs[3]
	
	if waveform_color.a == 0.0:
		return
	
	if GlobalVariables.number_of_stems > 2 and not GlobalVariables.vertical_layout:
		if waveform_number == 1 or waveform_number == 3:
			offset = 0.0
		else:
			offset = float(MainUtils.window_size.x) * 0.5
	else:
		offset = 0.0
	
	array_with_samples.clear()
	
	for buffer_idx: PackedFloat32Array in buffers:
		array_with_samples.append_array(buffer_idx)
	
	waveform_points.clear()
	waveform_points.resize(array_with_samples.size())
	
	# Slow, this entire script should be in C#.
	if buffers.size() == MainUtils.buffer_queue_size:
		for point: int in array_with_samples.size():
			waveform_points[point].x = point * waveform_x_spacing + offset
			waveform_points[point].y = array_with_samples[point] * waveform_height + waveform_y_pos
	
	# Displays waveform.
	if waveform_points.size() > 1 and buffers.size() > 0:
		draw_polyline(
			waveform_points,
			waveform_color,
			GlobalVariables.waveform_thickness,
			GlobalVariables.waveform_antialiasing
			)
