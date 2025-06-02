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

# This script handles the solid color background.

#region NODES ##################################

@onready var frame_one: ColorRect = $FrameOne
@onready var frame_two: ColorRect = $FrameTwo
@onready var frame_three: ColorRect = $FrameThree
@onready var frame_four: ColorRect = $FrameFour

#endregion ##################################

#region SOLID COLOR VARIABLES ##################################

var v_layout_sizes: Array[Vector2i] = [
	MainUtils.window_size,
	Vector2i(MainUtils.window_size.x, MainUtils.window_size.y / 2),
	Vector2i(MainUtils.window_size.x, MainUtils.window_size.y / 3),
	Vector2i(MainUtils.window_size.x, MainUtils.window_size.y / 4)
	]
var full_screen_size: Vector2i = MainUtils.window_size
var half_y_screen_size: Vector2i = Vector2i(MainUtils.window_size.x, MainUtils.window_size.y / 2)
var half_screen_size: Vector2i = MainUtils.window_size / 2

var frame_one_pos_normal_layout: Vector2i = Vector2i.ZERO
var frame_two_pos_normal_layout: Vector2i = Vector2i(MainUtils.window_size.x / 2, 0)
var frame_three_pos_normal_layout: Vector2i = Vector2i(0, MainUtils.window_size.y / 2)
var frame_four_pos_normal_layout: Vector2i = MainUtils.window_size / 2

#endregion ##################################

func _ready() -> void:
	MainUtils.update_visualizer.connect(update_solid_col_frames)
	update_solid_col_frames()

func update_solid_col_frames() -> void:
	var visibility: Array[bool] = [false, false, false, false]
	
	if GlobalVariables.background_type == "Solid Colors":
		visible = true
		
		v_layout_sizes = [
			MainUtils.window_size,
			Vector2i(MainUtils.window_size.x, MainUtils.window_size.y / 2),
			Vector2i(MainUtils.window_size.x, MainUtils.window_size.y / 3),
			Vector2i(MainUtils.window_size.x, MainUtils.window_size.y / 4)
		]
		
		for waveform: int in GlobalVariables.number_of_stems:
			visibility[waveform] = true
			
		frame_one.visible = visibility[0]
		frame_two.visible = visibility[1]
		frame_three.visible = visibility[2]
		frame_four.visible = visibility[3]
		
		frame_one.color = GlobalVariables.background_colors[0]
		frame_two.color = GlobalVariables.background_colors[1]
		frame_three.color = GlobalVariables.background_colors[2]
		frame_four.color = GlobalVariables.background_colors[3]
		
		full_screen_size = MainUtils.window_size
		half_y_screen_size = Vector2i(MainUtils.window_size.x, MainUtils.window_size.y / 2)
		half_screen_size = MainUtils.window_size / 2
		
		frame_one_pos_normal_layout = Vector2i.ZERO
		frame_two_pos_normal_layout = Vector2i(MainUtils.window_size.x / 2, 0)
		frame_three_pos_normal_layout = Vector2i(0, MainUtils.window_size.y / 2)
		frame_four_pos_normal_layout = MainUtils.window_size / 2
		
		if not GlobalVariables.vertical_layout:
			match GlobalVariables.number_of_stems:
				1:
					frame_one.size = full_screen_size
				2:
					if not GlobalVariables.vertical_layout:
						frame_one.size = half_y_screen_size
						frame_two.size = half_y_screen_size
						frame_two.position = frame_three_pos_normal_layout
				3:
					if not GlobalVariables.vertical_layout:
						frame_one.size = half_screen_size
						frame_two.size = half_screen_size
						frame_two.position = frame_two_pos_normal_layout
						frame_three.size = half_y_screen_size
						frame_three.position = frame_three_pos_normal_layout
				4:
					if not GlobalVariables.vertical_layout:
						frame_one.size = half_screen_size
						frame_two.size = half_screen_size
						frame_two.position = frame_two_pos_normal_layout
						frame_three.size = half_screen_size
						frame_three.position = frame_three_pos_normal_layout
						frame_four.size = half_screen_size
						frame_four.position = frame_four_pos_normal_layout
		else:
			match GlobalVariables.number_of_stems:
				1:
					frame_one.size = v_layout_sizes[0]
				2:
					frame_one.size = v_layout_sizes[1]
					frame_two.size = v_layout_sizes[1]
					frame_two.position = Vector2i(0, MainUtils.window_size.y / 2)
				3:
					frame_one.size = v_layout_sizes[2]
					frame_two.size = v_layout_sizes[2]
					frame_two.position = Vector2i(0, MainUtils.window_size.y / 3)
					frame_three.size = v_layout_sizes[2]
					frame_three.position = Vector2i(0, (MainUtils.window_size.y / 3) * 2)
				4:
					frame_one.size = v_layout_sizes[3]
					frame_two.size = v_layout_sizes[3]
					frame_two.position = Vector2i(0, MainUtils.window_size.y / 4)
					frame_three.size = v_layout_sizes[3]
					frame_three.position = Vector2i(0, (MainUtils.window_size.y / 4) * 2)
					frame_four.size = v_layout_sizes[3]
					frame_four.position = Vector2i(0, (MainUtils.window_size.y / 4) * 3)
	else:
		visible = false
