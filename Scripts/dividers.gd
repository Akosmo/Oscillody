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

# This script handles the dividers that appear on screen with 2 waveforms or more.

func _ready() -> void:
	MainUtils.update_visualizer.connect(update_dividers)
	update_dividers()

func _draw() -> void:
	if not GlobalVariables.vertical_layout:
		if GlobalVariables.number_of_stems > 1:
			if GlobalVariables.number_of_stems == 3:
				draw_line(
					Vector2(float(MainUtils.window_size.x) * 0.5, 0.0),
					Vector2(float(MainUtils.window_size.x) * 0.5, float(MainUtils.window_size.y) * 0.5),
					GlobalVariables.divider_colors[1],
					GlobalVariables.divider_thickness,
					true
					)
			elif GlobalVariables.number_of_stems == 4:
				draw_line(
					Vector2(float(MainUtils.window_size.x) * 0.5, 0.0),
					Vector2(float(MainUtils.window_size.x) * 0.5, float(MainUtils.window_size.y)),
					GlobalVariables.divider_colors[1],
					GlobalVariables.divider_thickness,
					true
					)
			draw_line(
				Vector2(0.0, float(MainUtils.window_size.y) * 0.5),
				Vector2(float(MainUtils.window_size.x), float(MainUtils.window_size.y) * 0.5),
				GlobalVariables.divider_colors[0],
				GlobalVariables.divider_thickness,
				true
				)
	else:
		match GlobalVariables.number_of_stems:
			2:
				draw_line(
					Vector2(0.0, float(MainUtils.window_size.y) * 0.5),
					Vector2(float(MainUtils.window_size.x), float(MainUtils.window_size.y) * 0.5),
					GlobalVariables.divider_colors[0],
					GlobalVariables.divider_thickness,
					true
					)
			3:
				draw_line(
					Vector2(0.0, float(MainUtils.window_size.y) * (1.0 / 3.0)),
					Vector2(float(MainUtils.window_size.x), float(MainUtils.window_size.y) * (1.0 / 3.0)),
					GlobalVariables.divider_colors[0],
					GlobalVariables.divider_thickness,
					true
					)
				draw_line(
					Vector2(0.0, float(MainUtils.window_size.y) * (2.0 / 3.0)),
					Vector2(float(MainUtils.window_size.x), float(MainUtils.window_size.y) * (2.0 / 3.0)),
					GlobalVariables.divider_colors[1],
					GlobalVariables.divider_thickness,
					true
					)
			4:
				draw_line(
					Vector2(0.0, float(MainUtils.window_size.y) * (1.0 / 4.0)),
					Vector2(float(MainUtils.window_size.x), float(MainUtils.window_size.y) * (1.0 / 4.0)),
					GlobalVariables.divider_colors[0],
					GlobalVariables.divider_thickness,
					true
					)
				draw_line(
					Vector2(0.0, float(MainUtils.window_size.y) * (2.0 / 4.0)),
					Vector2(float(MainUtils.window_size.x), float(MainUtils.window_size.y) * (2.0 / 4.0)),
					GlobalVariables.divider_colors[1],
					GlobalVariables.divider_thickness,
					true
					)
				draw_line(
					Vector2(0.0, float(MainUtils.window_size.y) * (3.0 / 4.0)),
					Vector2(float(MainUtils.window_size.x), float(MainUtils.window_size.y) * (3.0 / 4.0)),
					GlobalVariables.divider_colors[2],
					GlobalVariables.divider_thickness,
					true
					)

func update_dividers() -> void:
	if (GlobalVariables.number_of_stems > 1 and
	(not GlobalVariables.vertical_layout or GlobalVariables.include_dividers)):
		visible = true
		queue_redraw()
	else:
		visible = false
