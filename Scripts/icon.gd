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

extends TextureRect

# This script handles the icon that appears in the center.

#region ICON VARIABLES ##################################

const INCREASE_STRENGTH_ROTATION: int = 9

var icon_image_ratio: float
var icon_image_size: Vector2
var icon_image_scale_factor: float = remap(
	float(GlobalVariables.icon_size),
	1.0,
	10.0,
	0.05,
	1.0
	)
var icon_image_scale: Vector2
var window_ratio: float
var difference: Vector2
var icon_shake_energy: Vector2

#endregion ##################################

func _ready() -> void:
	MainUtils.update_visualizer.connect(update_icon)
	MainUtils.icon_file_selected.connect(load_icon)
	update_icon()

func _process(_delta: float) -> void:
	if MainUtils.audio_playing:
		icon_reaction(MainUtils.cur_mag)
	else:
		position = difference * -1.0
		set_scale(icon_image_scale)
		set_rotation_degrees(GlobalVariables.icon_rotation)

func update_icon() -> void:
	visible = GlobalVariables.icon_enabled
	if visible:
		if (GlobalVariables.icon_position_reaction_strength or
		GlobalVariables.icon_rotation_reaction_strength or
		GlobalVariables.icon_size_reaction_strength):
			set_process(true)
		else:
			set_process(false)
		
		icon_image_scale_factor = remap(
			GlobalVariables.icon_size,
			1.0,
			10.0,
			0.05,
			1.0
			)
		
		# Avoid edge cases where one of the window's values = 0.
		if mini(MainUtils.window_size.x, MainUtils.window_size.y) > 0:
			window_ratio = MainUtils.window_size.x / MainUtils.window_size.y
		# Scaling to different axis depending on the aspect ratio.
		if window_ratio <= icon_image_ratio:
			icon_image_scale = Vector2(
				Vector2(MainUtils.window_size).x / icon_image_size.x * icon_image_scale_factor,
				Vector2(MainUtils.window_size).x / icon_image_size.x * icon_image_scale_factor
				)
		else:
			icon_image_scale = Vector2(
				Vector2(MainUtils.window_size).y / icon_image_size.y * icon_image_scale_factor,
				Vector2(MainUtils.window_size).y / icon_image_size.y * icon_image_scale_factor
				)
		
		set_self_modulate(GlobalVariables.icon_color)
		
		size = icon_image_size
		
		pivot_offset = size * 0.5
		
		set_scale(icon_image_scale)
		
		set_rotation_degrees(GlobalVariables.icon_rotation)
		
		# Repositioning image, since it is placed with its top-left corner at origin point.
		# Difference from middle of icon image to middle of window.
		difference = Vector2(
			pivot_offset.x - float(MainUtils.window_size.x) * 0.5,
			pivot_offset.y - float(MainUtils.window_size.y) * 0.5
			)
		position = difference * -1.0
	else:
		set_process(false)

func icon_reaction(mag: float, strength: float = 0.0) -> void:
	mag = clampf(mag, 0.0, 1.0)
	
	if GlobalVariables.icon_position_reaction_strength:
		strength = GlobalVariables.icon_position_reaction_strength * 5.0
		
		position = difference * -1.0
		
		icon_shake_energy = Vector2(
			randf_range(-mag, mag) * strength,
			randf_range(-mag, mag) * strength
			)
		position += icon_shake_energy
	
	if GlobalVariables.icon_size_reaction_strength:
		strength = GlobalVariables.icon_size_reaction_strength * 0.1
		
		set_scale(Vector2(
			icon_image_scale.x * (1 + mag * strength),
			icon_image_scale.y * (1 + mag * strength)
			))
	
	if GlobalVariables.icon_rotation_reaction_strength:
		strength = GlobalVariables.icon_rotation_reaction_strength * INCREASE_STRENGTH_ROTATION
		
		set_rotation_degrees(GlobalVariables.icon_rotation + mag * strength)

func load_icon() -> void:
	if GlobalVariables.icon_path == "":
		texture = null
		return
	if not FileAccess.file_exists(GlobalVariables.icon_path):
		MainUtils.logger("Icon image \"" + GlobalVariables.icon_path.get_file() + "\" does not exist.", true)
		return
	var image: Image = Image.load_from_file(GlobalVariables.icon_path)
	if image.is_empty():
		MainUtils.logger("Loaded image for icon has no data: " + GlobalVariables.icon_path, true)
		return
	var texture_from_img: Texture2D = ImageTexture.create_from_image(image)
	if texture_from_img.get_image() == null:
		MainUtils.logger(
			"Could not convert icon image to texture, or the image was improperly loaded internally.",
			true,
			true
			)
		return
	set_texture(texture_from_img)
	icon_image_size = image.get_size()
	icon_image_ratio = icon_image_size.x / icon_image_size.y
	update_icon()
	
	MainUtils.logger("New image for icon loaded: " + GlobalVariables.icon_path)
