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

extends CanvasLayer

# This script handles the background image.

#region NODES ##################################

@onready var image_rect: TextureRect = $ImageRect
@onready var blur: ColorRect = $Blur

#endregion ##################################

#region BACKGROUND IMAGE VARIABLES ##################################

const MAX_OPACITY_IN_UI: float = 100.0

const DECREASE_STRENGTH_SIZE: float = 0.1
const INCREASE_AMPLITUDE: int = 2

var difference: Vector2
var image_size: Vector2
var image_scale_factor: float = remap(
	float(GlobalVariables.image_size),
	1.0,
	10.0,
	1.0,
	2.0
	)
var image_scale: Vector2 = Vector2(MainUtils.window_size) / image_size * image_scale_factor

var image_size_reaction_factor: float = 1.0

var noise: FastNoiseLite = FastNoiseLite.new()
# Variable used to increment noise position. Used along with shake frequency and amplitude set by the user.
var noise_scroll: float = 0.0
var noise_position: Vector2 = Vector2.ZERO
var scale_for_amplitude: Vector2 = Vector2.ZERO
var amplitude_factor: float = 1.0
var frequency_factor: float = 1.0
# Variable used in place of `GlobalVariables.background_shake_amplitude` and
# `GlobalVariables.background_shake_frequency` to allow reaction strengths to have effect.
var mag_for_zero_default_shake: float = 0.0

#endregion ##################################

func _ready() -> void:
	noise.fractal_octaves = 2
	noise.frequency = 0.0005
	
	MainUtils.update_visualizer.connect(update_image)
	MainUtils.image_file_selected.connect(load_image)
	update_image()

func _process(_delta: float) -> void:
	if ((GlobalVariables.background_image_size_reaction_strength or
	GlobalVariables.shake_amplitude_reaction_strength or
	GlobalVariables.shake_frequency_reaction_strength) and
	MainUtils.audio_playing):
		image_reaction(MainUtils.cur_mag)
	else:
		image_size_reaction_factor = 1.0
		amplitude_factor = 1.0
		frequency_factor = 1.0
	
	if (GlobalVariables.background_shake_frequency or
	GlobalVariables.shake_amplitude_reaction_strength and
	(GlobalVariables.background_shake_frequency or GlobalVariables.shake_frequency_reaction_strength)):
		if GlobalVariables.background_shake_frequency != 0.0:
			noise_scroll += GlobalVariables.background_shake_frequency * frequency_factor
		else:
			noise_scroll += GlobalVariables.shake_frequency_reaction_strength * 5.0 \
			* mag_for_zero_default_shake * frequency_factor
		
		# Scale the image a bit, to avoid showing past the edges.
		# We figure how much needs to be added to scale by checking how many pixels we need on both
		# top and bottom to move Amp amount of pixels, considering Y axis since it has less pixels,
		# and dividing by the size of the image in the same axis.
		# At max amplitude, we need 100 extra pixels on top and 100 extra on the bottom, which
		# equals 200 pixels. The image needs to be scaled by an amount that would give us that,
		# which is what we find first below.
		# We're only multiplying by 4 because amplitude is later multiplied by 2.
		if GlobalVariables.background_shake_amplitude != 0.0:
			scale_for_amplitude = Vector2(
				GlobalVariables.background_shake_amplitude * 4.0 * amplitude_factor / image_size.y,
				GlobalVariables.background_shake_amplitude * 4.0 * amplitude_factor / image_size.y
				)
			
			noise_position = Vector2(
				noise.get_noise_2d(noise_scroll, 0.0) \
				* GlobalVariables.background_shake_amplitude * INCREASE_AMPLITUDE * amplitude_factor,
				noise.get_noise_2d(0.0, noise_scroll) \
				* GlobalVariables.background_shake_amplitude * INCREASE_AMPLITUDE * amplitude_factor
				)
		else:
			scale_for_amplitude = Vector2(
				GlobalVariables.shake_amplitude_reaction_strength * mag_for_zero_default_shake \
				* 4.0 * amplitude_factor / image_size.y,
				GlobalVariables.shake_amplitude_reaction_strength * mag_for_zero_default_shake \
				* 4.0 * amplitude_factor / image_size.y
				)
			
			noise_position = Vector2(
				noise.get_noise_2d(noise_scroll, 0.0) \
				* GlobalVariables.shake_amplitude_reaction_strength * mag_for_zero_default_shake \
				* INCREASE_AMPLITUDE * amplitude_factor,
				noise.get_noise_2d(0.0, noise_scroll) \
				* GlobalVariables.shake_amplitude_reaction_strength * mag_for_zero_default_shake \
				* INCREASE_AMPLITUDE * amplitude_factor
				)
	else:
		scale_for_amplitude = Vector2.ZERO
		noise_position = Vector2.ZERO
	
	# Repositioning image based on 2D noise. 
	image_rect.position = difference * -1.0 + noise_position
	
	image_scale = Vector2(MainUtils.window_size) / image_size * image_scale_factor \
	* image_size_reaction_factor + scale_for_amplitude
	image_rect.set_scale(image_scale)

func update_image() -> void:
	if GlobalVariables.background_type == "Image":
		visible = true
		# A CanvasLayer visibility doesn't propagate to underlying layers.
		image_rect.visible = true
		set_process(true)
		
		image_rect.set_self_modulate(Color(1.0, 1.0, 1.0, float(GlobalVariables.image_opacity \
		/ MAX_OPACITY_IN_UI)))
		
		# Repositioning image, since it is placed with its top-left corner at origin point.
		image_rect.size = image_size
		image_rect.pivot_offset = image_rect.size * 0.5
		# Difference from middle of background image to middle of window.
		difference = Vector2(
			image_rect.pivot_offset.x - float(MainUtils.window_size.x) * 0.5,
			image_rect.pivot_offset.y - float(MainUtils.window_size.y) * 0.5
			)
		
		image_scale_factor = remap(
			float(GlobalVariables.image_size),
			1.0,
			10.0,
			1.0,
			2.0
			)
		
		if GlobalVariables.image_blur > 0:
			blur.visible = true
			blur.get_material().set_shader_parameter("blur_strength",
				remap(float(GlobalVariables.image_blur), 0.0, 100.0, 0.0, 5.0)
				)
		else:
			blur.visible = false
	else:
		visible = false
		image_rect.visible = false
		set_process(false)

func image_reaction(mag: float, strength: float = 0.0) -> void:
	mag = clampf(mag, 0.0, 1.0)
	mag_for_zero_default_shake = mag
	
	if (GlobalVariables.background_image_size_reaction_strength and
	not GlobalVariables.shake_amplitude_reaction_strength):
		strength = GlobalVariables.background_image_size_reaction_strength * DECREASE_STRENGTH_SIZE
		# Prefer a factor than an addend, since it reacts the same way regardless of image size.
		image_size_reaction_factor = 1.0 + mag * strength
	else:
		image_size_reaction_factor = 1.0
	
	if (GlobalVariables.background_shake_frequency or
	GlobalVariables.shake_amplitude_reaction_strength and
	(GlobalVariables.background_shake_frequency or GlobalVariables.shake_frequency_reaction_strength)):
		if GlobalVariables.shake_amplitude_reaction_strength:
			strength = GlobalVariables.shake_amplitude_reaction_strength
			amplitude_factor = 1.0 + mag * strength
		else:
			amplitude_factor = 1.0
		
		if GlobalVariables.shake_frequency_reaction_strength:
			strength = GlobalVariables.shake_frequency_reaction_strength
			frequency_factor = 1.0 + mag * strength
		else:
			frequency_factor = 1.0

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
