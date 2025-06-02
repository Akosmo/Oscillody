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

extends CanvasLayer

# This script handles the background image.

#region NODES ##################################

@onready var image_rect: TextureRect = $ImageRect
@onready var blur: ColorRect = $Blur

#endregion ##################################

#region BACKGROUND IMAGE VARIABLES ##################################

const MAX_OPACITY_IN_UI: float = 100.0

var image_size: Vector2
var image_scale_factor: float = remap(
	float(GlobalVariables.image_size),
	1.0,
	10.0,
	1.0,
	2.0
	)
var image_scale: Vector2 = Vector2(MainUtils.window_size) / image_size * image_scale_factor

var noise: FastNoiseLite = FastNoiseLite.new()
var custom_time: float = 0.0
var time_factor: float = 50.0
var amplitude_factor: float = 5.0
var center: Vector2 = Vector2.ZERO
var zoom_for_amplitude: Vector2 = Vector2.ZERO
var addend_from_amp_reaction: Vector2 = Vector2.ZERO
var size_reaction_factor: float = 1.0
var modified_image_scale: Vector2

#endregion ##################################

func _ready() -> void:
	noise.fractal_octaves = 2
	noise.frequency = 0.00001
	
	MainUtils.update_visualizer.connect(update_image)
	MainUtils.image_file_selected.connect(load_image)
	update_image()

func _process(_delta: float) -> void:
	if visible:
		if ((GlobalVariables.background_image_size_reaction_strength or
		GlobalVariables.shake_amplitude_reaction_strength or
		GlobalVariables.shake_frequency_reaction_strength) and
		MainUtils.audio_playing):
			image_reaction(MainUtils.cur_mag)
		else:
			size_reaction_factor = 1.0
			amplitude_factor = 5.0
			addend_from_amp_reaction = Vector2.ZERO
			time_factor = 50.0
		
		if GlobalVariables.background_shake_amplitude and GlobalVariables.background_shake_frequency:
			custom_time = custom_time + time_factor * GlobalVariables.background_shake_frequency
			
			image_rect.position.x = center.x \
			+ noise.get_noise_2d(custom_time, 0.0) \
			* GlobalVariables.background_shake_amplitude * 0.5 * amplitude_factor
			image_rect.position.y = center.y \
			+ noise.get_noise_2d(0.0, custom_time) \
			* GlobalVariables.background_shake_amplitude * 0.5 * amplitude_factor
		else:
			image_rect.position = center
			
		zoom_for_amplitude = Vector2(
			GlobalVariables.background_shake_amplitude * 0.005,
			GlobalVariables.background_shake_amplitude * 0.005
			)
		
		image_scale_factor = remap(
			float(GlobalVariables.image_size),
			1.0,
			10.0,
			1.0,
			2.0
			)
		image_scale = Vector2(MainUtils.window_size) / image_size * image_scale_factor
		
		modified_image_scale = (image_scale + zoom_for_amplitude + addend_from_amp_reaction) * size_reaction_factor
		image_rect.set_scale(modified_image_scale)
		
		if image_rect.scale < image_scale:
			image_rect.set_scale(image_scale)

func update_image() -> void:
	if GlobalVariables.background_type == "Image":
		visible = true
		set_process(true)
		
		image_rect.set_self_modulate(Color(1.0, 1.0, 1.0, float(GlobalVariables.image_opacity \
		/ MAX_OPACITY_IN_UI)))
		
		image_rect.size = image_size
		image_rect.pivot_offset = image_rect.size / 2.0
		# Difference from middle of icon image to middle of window.
		var difference: Vector2 = Vector2(
			image_rect.size.x / 2.0 - float(MainUtils.window_size.x) / 2.0,
			image_rect.size.y / 2.0 - float(MainUtils.window_size.y) / 2.0
			)
		image_rect.position = difference * -1.0
		center = image_rect.position
		
		if GlobalVariables.image_blur > 0:
			blur.visible = true
			blur.get_material().set_shader_parameter("blur_strength",
				remap(float(GlobalVariables.image_blur), 0.0, 100.0, 0.0, 5.0)
				)
		else:
			blur.visible = false
	else:
		visible = false
		set_process(false)

func image_reaction(mag: float, strength: float = 0.0) -> void:
	if (GlobalVariables.background_image_size_reaction_strength and
	not GlobalVariables.shake_amplitude_reaction_strength):
		strength = GlobalVariables.background_image_size_reaction_strength * 0.1
		size_reaction_factor = 1.0 + mag * strength
	else:
		size_reaction_factor = 1.0
	
	if (GlobalVariables.shake_amplitude_reaction_strength and
	GlobalVariables.background_shake_amplitude):
		strength = GlobalVariables.shake_amplitude_reaction_strength * 0.1
		amplitude_factor = 5.0 + mag * (strength * 0.1)
		addend_from_amp_reaction = Vector2(mag * strength / 2.5, mag * strength / 2.5)
	else:
		amplitude_factor = 5.0
		addend_from_amp_reaction = Vector2.ZERO
	
	if GlobalVariables.shake_frequency_reaction_strength:
		strength = GlobalVariables.shake_frequency_reaction_strength * 200.0
		time_factor = 50.0 + mag * strength
	else:
		time_factor = 50.0

func load_image() -> void:
	if GlobalVariables.image_path == "":
		image_rect.texture = null
		return
	if not FileAccess.file_exists(GlobalVariables.image_path):
		MainUtils.logger("Background image \"" + GlobalVariables.image_path.get_file() + "\" does not exist.", true)
		return
	var image: Image = Image.load_from_file(GlobalVariables.image_path)
	if image.is_empty():
		MainUtils.logger("Loaded image for background has no data: " + GlobalVariables.image_path, true)
		return
	var texture_from_img: Texture2D = ImageTexture.create_from_image(image)
	if texture_from_img.get_image() == null:
		MainUtils.logger(
			"Could not convert background image to texture, or the image was improperly loaded internally.",
			true,
			true
			)
		return
	image_rect.set_texture(texture_from_img)
	image_size = Vector2(image.get_size())
	update_image()
	
	MainUtils.logger("New image for background selected: " + GlobalVariables.image_path)
