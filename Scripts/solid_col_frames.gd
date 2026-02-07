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

# This script handles the solid color background.

#region SOLID COLOR VARIABLES ##################################

var normal_layout_pos_zero_x_zero_y: Vector2 = Vector2.ZERO
var normal_layout_pos_half_x_zero_y: Vector2 = Vector2(float(MainUtils.window_size.x) * 0.5, 0)
var normal_layout_pos_zero_x_half_y: Vector2 = Vector2(0, float(MainUtils.window_size.y) * 0.5)
var normal_layout_pos_half_x_half_y: Vector2 = Vector2(MainUtils.window_size * 0.5)
var v_layout_positions: Array[Vector2] = [
	Vector2.ZERO,
	Vector2(0.0, float(MainUtils.window_size.y) * 0.5),
	Vector2(0.0, float(MainUtils.window_size.y) * (1.0 / 3.0)),
	Vector2(0.0, float(MainUtils.window_size.y) * (2.0 / 3.0)),
	Vector2(0.0, float(MainUtils.window_size.y) * (1.0 / 4.0)),
	Vector2(0.0, float(MainUtils.window_size.y) * (2.0 / 4.0)),
	Vector2(0.0, float(MainUtils.window_size.y) * (3.0 / 4.0)),
	]

var full_screen_size: Vector2 = Vector2(MainUtils.window_size)
var half_y_screen_size: Vector2 = Vector2(float(MainUtils.window_size.x), float(MainUtils.window_size.y) * 0.5)
var half_screen_size: Vector2 = Vector2(MainUtils.window_size) * 0.5
var v_layout_sizes: Array[Vector2] = [
	Vector2(MainUtils.window_size),
	Vector2(float(MainUtils.window_size.x), float(MainUtils.window_size.y) / 2.0),
	Vector2(float(MainUtils.window_size.x), float(MainUtils.window_size.y) / 3.0),
	Vector2(float(MainUtils.window_size.x), float(MainUtils.window_size.y) / 4.0)
	]

var rect: Rect2

#endregion ##################################

func _ready() -> void:
	MainUtils.update_visualizer.connect(update_solid_col_frames)
	update_solid_col_frames()

func _draw() -> void:
	if not GlobalVariables.vertical_layout:
		match GlobalVariables.number_of_stems:
			1:
				rect = Rect2(normal_layout_pos_zero_x_zero_y, full_screen_size)
				draw_rect(rect, GlobalVariables.background_colors[0])
			2:
				rect = Rect2(normal_layout_pos_zero_x_zero_y, half_y_screen_size)
				draw_rect(rect, GlobalVariables.background_colors[0])
				rect = Rect2(normal_layout_pos_zero_x_half_y, half_y_screen_size)
				draw_rect(rect, GlobalVariables.background_colors[1])
			3:
				rect = Rect2(normal_layout_pos_zero_x_zero_y, half_screen_size)
				draw_rect(rect, GlobalVariables.background_colors[0])
				rect = Rect2(normal_layout_pos_half_x_zero_y, half_screen_size)
				draw_rect(rect, GlobalVariables.background_colors[1])
				rect = Rect2(normal_layout_pos_zero_x_half_y, half_y_screen_size)
				draw_rect(rect, GlobalVariables.background_colors[2])
			4:
				rect = Rect2(normal_layout_pos_zero_x_zero_y, half_screen_size)
				draw_rect(rect, GlobalVariables.background_colors[0])
				rect = Rect2(normal_layout_pos_half_x_zero_y, half_screen_size)
				draw_rect(rect, GlobalVariables.background_colors[1])
				rect = Rect2(normal_layout_pos_zero_x_half_y, half_screen_size)
				draw_rect(rect, GlobalVariables.background_colors[2])
				rect = Rect2(normal_layout_pos_half_x_half_y, half_screen_size)
				draw_rect(rect, GlobalVariables.background_colors[3])
	else:
		match GlobalVariables.number_of_stems:
			1:
				rect = Rect2(v_layout_positions[0], v_layout_sizes[0])
				draw_rect(rect, GlobalVariables.background_colors[0])
			2:
				rect = Rect2(v_layout_positions[0], v_layout_sizes[1])
				draw_rect(rect, GlobalVariables.background_colors[0])
				rect = Rect2(v_layout_positions[1], v_layout_sizes[1])
				draw_rect(rect, GlobalVariables.background_colors[1])
			3:
				rect = Rect2(v_layout_positions[0], v_layout_sizes[2])
				draw_rect(rect, GlobalVariables.background_colors[0])
				rect = Rect2(v_layout_positions[2], v_layout_sizes[2])
				draw_rect(rect, GlobalVariables.background_colors[1])
				rect = Rect2(v_layout_positions[3], v_layout_sizes[2])
				draw_rect(rect, GlobalVariables.background_colors[2])
			4:
				rect = Rect2(v_layout_positions[0], v_layout_sizes[3])
				draw_rect(rect, GlobalVariables.background_colors[0])
				rect = Rect2(v_layout_positions[4], v_layout_sizes[3])
				draw_rect(rect, GlobalVariables.background_colors[1])
				rect = Rect2(v_layout_positions[5], v_layout_sizes[3])
				draw_rect(rect, GlobalVariables.background_colors[2])
				rect = Rect2(v_layout_positions[6], v_layout_sizes[3])
				draw_rect(rect, GlobalVariables.background_colors[3])

func update_solid_col_frames() -> void:
	if GlobalVariables.background_type == "Solid Colors":
		visible = true
		
		normal_layout_pos_zero_x_zero_y = Vector2.ZERO
		normal_layout_pos_half_x_zero_y = Vector2(float(MainUtils.window_size.x) * 0.5, 0)
		normal_layout_pos_zero_x_half_y = Vector2(0, float(MainUtils.window_size.y) * 0.5)
		normal_layout_pos_half_x_half_y = Vector2(MainUtils.window_size * 0.5)
		v_layout_positions = [
			Vector2.ZERO,
			Vector2(0.0, float(MainUtils.window_size.y) * 0.5),
			Vector2(0.0, float(MainUtils.window_size.y) * (1.0 / 3.0)),
			Vector2(0.0, float(MainUtils.window_size.y) * (2.0 / 3.0)),
			Vector2(0.0, float(MainUtils.window_size.y) * (1.0 / 4.0)),
			Vector2(0.0, float(MainUtils.window_size.y) * (2.0 / 4.0)),
			Vector2(0.0, float(MainUtils.window_size.y) * (3.0 / 4.0)),
			]
		
		full_screen_size = Vector2(MainUtils.window_size)
		half_y_screen_size = Vector2(float(MainUtils.window_size.x), float(MainUtils.window_size.y) * 0.5)
		half_screen_size = Vector2(MainUtils.window_size) * 0.5
		v_layout_sizes = [
			Vector2(MainUtils.window_size),
			Vector2(float(MainUtils.window_size.x), float(MainUtils.window_size.y) / 2.0),
			Vector2(float(MainUtils.window_size.x), float(MainUtils.window_size.y) / 3.0),
			Vector2(float(MainUtils.window_size.x), float(MainUtils.window_size.y) / 4.0)
			]
		
		queue_redraw()
	else:
		visible = false
