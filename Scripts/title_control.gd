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

extends Control

# This script handles the text the user can input on the visualizer.

#region NODES ##################################

@onready var title: Label = $Title

#endregion ##################################

#region TITLE CONTROL VARIABLES ##################################

const DEFAULT_WEIGHT: int = 400
const BOLD_WEIGHT: int = 700
const MAX_POS_IN_UI: float = 100.0

var center_of_text: Vector2 = Vector2.ZERO
var default_title_pos: Vector2
var max_resolution: Vector2
var title_scale: Vector2

var title_shake_energy: Vector2
var title_size_reaction_addend: int = 0

@onready var title_settings: LabelSettings = title.get_label_settings()
@onready var font_type: SystemFont = title_settings.get_font()

#endregion ##################################

func _ready() -> void:
	font_type.set_font_names(GlobalVariables.title_fonts_in_selector)
	
	MainUtils.update_visualizer.connect(update_title)
	update_title()

func _process(_delta: float) -> void:
	if visible:
		if ((GlobalVariables.title_position_reaction_strength or
		GlobalVariables.title_size_reaction_strength) and
		MainUtils.audio_playing):
			title_reaction(MainUtils.cur_mag)
		else:
			title_size_reaction_addend = 0
			title_shake_energy = Vector2.ZERO
		
		default_title_pos = Vector2(float(MainUtils.window_size.x) \
		* (float(GlobalVariables.title_position.x) \
		/ MAX_POS_IN_UI) - center_of_text.x,
		float(MainUtils.window_size.y) \
		* ((MAX_POS_IN_UI - float(GlobalVariables.title_position.y)) \
		/ MAX_POS_IN_UI) - center_of_text.y)
		
		title_settings.set_font_size(GlobalVariables.title_size + title_size_reaction_addend)
		title.set_position(default_title_pos + title_shake_energy)

func update_title() -> void:
	if GlobalVariables.title != "":
		visible = true
		set_process(true)
		
		title.text = GlobalVariables.title
		
		if GlobalVariables.title_font_bold:
			font_type.set_font_weight(BOLD_WEIGHT)
		else:
			font_type.set_font_weight(DEFAULT_WEIGHT)
		
		font_type.set_font_italic(GlobalVariables.title_font_italic)
		
		center_of_text = title.size * 0.5
		title.pivot_offset = center_of_text
		max_resolution = DisplayServer.screen_get_size()
		title_scale = Vector2(MainUtils.window_size) / max_resolution
		if title_scale.x >= title_scale.y:
			title.scale = Vector2(title_scale.y, title_scale.y)
		else:
			title.scale = Vector2(title_scale.x, title_scale.x)
		
		font_type.font_names[0] = GlobalVariables.title_font
	
		title_settings.set_font_color(GlobalVariables.title_color)
		title_settings.set_shadow_color(GlobalVariables.title_shadow_color)
		title_settings.set_shadow_offset(GlobalVariables.title_shadow_position)
		title_settings.set_outline_color(GlobalVariables.title_outline_color)
		title_settings.set_outline_size(GlobalVariables.title_outline_size)
	else:
		visible = false
		set_process(false)

func title_reaction(mag: float, strength: float = 0.0) -> void:
	mag = clampf(mag, 0.0, 1.0)
	
	if GlobalVariables.title_position_reaction_strength:
		strength = GlobalVariables.title_position_reaction_strength
		
		title_shake_energy = Vector2(randf_range(-mag, mag) * strength, randf_range(-mag, mag) * strength)
	
	if GlobalVariables.title_size_reaction_strength:
		strength = GlobalVariables.title_size_reaction_strength * 40.0 \
		* remap(GlobalVariables.title_size, 20.0, 200.0, 0.1, 1.0)
		
		title_size_reaction_addend = int(mag * strength)
