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

# This script handles post-processing (except bloom) (shaders are in gdshader files).

#region NODES ##################################

@onready var chromatic_aberration: ColorRect = $ChromaticAberrationCanvas/ChromaticAberration
@onready var glitch: ColorRect = $GlitchCanvas/Glitch
@onready var spin_zoom_blur: ColorRect = $SpinZoomBlurCanvas/SpinZoomBlur
@onready var grain: ColorRect = $GrainCanvas/Grain
@onready var grain_texture: TextureRect = $GrainTexture
@onready var tape_distortion: ColorRect = $TapeDistortionCanvas/TapeDistortion
@onready var scanlines: ColorRect = $ScanlinesCanvas/Scanlines
@onready var lens_distortion: ColorRect = $LensDistortionCanvas/LensDistortion
@onready var gradient_overlay: ColorRect = $GradientOverlayCanvas/GradientOverlay
@onready var vignette: ColorRect = $VignetteCanvas/Vignette

#endregion ##################################

#region POST-PROCESSING VARIABLES ##################################

const REDUCE_STRENGTH_CHROMATIC_ABERRATION: float = 0.01
const REDUCE_STRENGTH_GLITCH: float = 0.01
const REDUCE_STRENGTH_SPIN_ZOOM_BLUR: float = 0.01
const REDUCE_STRENGTH_LENS_DISTORTION: float = 0.1
const REDUCE_STRENGTH_VIGNETTE: float = 0.1

# Variable used to increment shader "frames". Used along with shader speed set by the user.
var custom_time: float = 0.0

var current_value_sent_to_shader: float = 0.0

#endregion ##################################

func _ready() -> void:
	MainUtils.update_visualizer.connect(update_post_processing)
	update_post_processing()

func _process(_delta: float) -> void:
	if visible:
		if scanlines.visible:
			custom_time = custom_time + 0.002 * GlobalVariables.scanlines_speed * 10.0
			scanlines.get_material().set_shader_parameter("speed", custom_time)
		if (GlobalVariables.chromatic_aberration_strength_reaction_strength or
		GlobalVariables.glitch_offset_reaction_strength or
		GlobalVariables.spin_zoom_blur_strength_reaction_strength or
		GlobalVariables.vignette_size_reaction_strength):
			post_processing_reaction(MainUtils.cur_mag)

func update_post_processing() -> void:
	if (GlobalVariables.chromatic_aberration_strength or
	GlobalVariables.glitch_block_offset_amount or
	GlobalVariables.glitch_pixel_offset_amount or
	GlobalVariables.spin_zoom_blur_strength or
	GlobalVariables.grain_opacity or
	GlobalVariables.tape_distortion_wave_strength or
	GlobalVariables.tape_distortion_block_strength or
	GlobalVariables.scanlines_darkness or
	GlobalVariables.lens_distortion_strength or
	GlobalVariables.gradient_overlay_opacity or
	GlobalVariables.vignette_size):
		visible = true
		set_process(true)
	else:
		visible = false
		set_process(false)
		
	if GlobalVariables.chromatic_aberration_strength:
		chromatic_aberration.visible = true
		chromatic_aberration.get_material().set_shader_parameter(
			"strength",
			remap(GlobalVariables.chromatic_aberration_strength, 0.0, 10.0, 0.0, 0.005)
			)
	else:
		chromatic_aberration.visible = false
	
	if GlobalVariables.glitch_block_offset_amount or GlobalVariables.glitch_pixel_offset_amount:
		glitch.visible = true
		glitch.get_material().set_shader_parameter(
			"block_offset_amount",
			GlobalVariables.glitch_block_offset_amount * 0.0005
			)
		glitch.get_material().set_shader_parameter(
			"pixel_offset_amount",
			GlobalVariables.glitch_pixel_offset_amount * 0.0005
			)
		glitch.get_material().set_shader_parameter(
			"speed_factor",
			GlobalVariables.glitch_speed_factor
			)
	else:
		glitch.visible = false
	
	if GlobalVariables.spin_zoom_blur_strength:
		spin_zoom_blur.visible = true
		spin_zoom_blur.get_material().set_shader_parameter(
			"zoom_mode",
			GlobalVariables.spin_zoom_blur_change_mode
			)
		spin_zoom_blur.get_material().set_shader_parameter(
			"blur_strength",
			GlobalVariables.spin_zoom_blur_strength * 0.1
			)
	else:
		spin_zoom_blur.visible = false
	
	if GlobalVariables.grain_opacity:
		if not GlobalVariables.grain_static:
			grain.visible = true
			grain_texture.visible = false
			grain.get_material().set_shader_parameter("opacity", GlobalVariables.grain_opacity * 0.01)
		else:
			grain_texture.visible = true
			grain.visible = false
			grain_texture.get_material().set_shader_parameter("opacity", GlobalVariables.grain_opacity * 0.01)
	else:
		grain.visible = false
		grain_texture.visible = false
	
	if GlobalVariables.tape_distortion_wave_strength or GlobalVariables.tape_distortion_block_strength:
		tape_distortion.visible = true
		tape_distortion.get_material().set_shader_parameter(
			"wave_strength",
			GlobalVariables.tape_distortion_wave_strength * 0.1
			)
		tape_distortion.get_material().set_shader_parameter(
			"wave_speed",
			GlobalVariables.tape_distortion_wave_speed * 0.1
			)
		tape_distortion.get_material().set_shader_parameter(
			"wave_freq",
			GlobalVariables.tape_distortion_wave_frequency
			)
		tape_distortion.get_material().set_shader_parameter(
			"wave_thickness",
			int(remap(float(GlobalVariables.tape_distortion_wave_thickness), 10.0, 100.0, 100.0, 10.0))
			)
		tape_distortion.get_material().set_shader_parameter(
			"block_strength",
			GlobalVariables.tape_distortion_block_strength * 0.001
			)
		tape_distortion.get_material().set_shader_parameter(
			"block_speed",
			GlobalVariables.tape_distortion_block_speed * 0.1
			)
		tape_distortion.get_material().set_shader_parameter(
			"block_freq",
			GlobalVariables.tape_distortion_block_frequency
			)
	else:
		tape_distortion.visible = false
	
	if GlobalVariables.scanlines_darkness:
		scanlines.visible = true
		scanlines.get_material().set_shader_parameter(
			"darkness",
			GlobalVariables.scanlines_darkness * 0.1
			)
		scanlines.get_material().set_shader_parameter(
			"amount_of_lines",
			GlobalVariables.scanlines_amount_of_lines
			)
		scanlines.get_material().set_shader_parameter(
			"interlaced_scan",
			GlobalVariables.scanlines_interlaced_scan
			)
	else:
		scanlines.visible = false
	
	if GlobalVariables.lens_distortion_strength:
		lens_distortion.visible = true
		lens_distortion.get_material().set_shader_parameter(
			"strength",
			GlobalVariables.lens_distortion_strength * 0.1
			)
		lens_distortion.get_material().set_shader_parameter(
			"zoom",
			GlobalVariables.lens_distortion_zoom
			)
		lens_distortion.get_material().set_shader_parameter(
			"border",
			GlobalVariables.lens_distortion_border
			)
		lens_distortion.get_material().set_shader_parameter(
			"border_color",
			GlobalVariables.lens_distortion_border_color
			)
		lens_distortion.get_material().set_shader_parameter(
			"chromatic_aberration_strength",
			GlobalVariables.lens_distortion_chromatic_aberration_strength
			)
	else:
		lens_distortion.visible = false
	
	if GlobalVariables.gradient_overlay_opacity:
		gradient_overlay.visible = true
		gradient_overlay.get_material().set_shader_parameter(
			"color_1",
			GlobalVariables.gradient_overlay_color_1
			)
		gradient_overlay.get_material().set_shader_parameter(
			"color_2",
			GlobalVariables.gradient_overlay_color_2
			)
		gradient_overlay.get_material().set_shader_parameter(
			"direction",
			GlobalVariables.gradient_overlay_direction
			)
		gradient_overlay.get_material().set_shader_parameter(
			"opacity",
			GlobalVariables.gradient_overlay_opacity * 0.01
			)
	else:
		gradient_overlay.visible = false
	
	if GlobalVariables.vignette_size:
		vignette.visible = true
		vignette.get_material().set_shader_parameter("vignette_color", GlobalVariables.vignette_color)
		vignette.get_material().set_shader_parameter("vignette_size", GlobalVariables.vignette_size * 0.1)
		vignette.get_material().set_shader_parameter("vignette_sharpness",
			GlobalVariables.vignette_sharpness
			)
	else:
		vignette.visible = false

func post_processing_reaction(mag: float, strength: float = 0.0) -> void:
	if MainUtils.audio_playing:
		if GlobalVariables.chromatic_aberration_strength_reaction_strength:
			strength = GlobalVariables.chromatic_aberration_strength_reaction_strength * 0.1
			current_value_sent_to_shader = remap(
				GlobalVariables.chromatic_aberration_strength,
				0.0,
				10.0,
				0.0,
				0.005
				)
			
			chromatic_aberration.get_material().set_shader_parameter(
				"strength",
				current_value_sent_to_shader + mag * REDUCE_STRENGTH_CHROMATIC_ABERRATION * strength
				)
		
		if GlobalVariables.glitch_offset_reaction_strength:
			strength = GlobalVariables.glitch_offset_reaction_strength * 0.25
			current_value_sent_to_shader = GlobalVariables.glitch_block_offset_amount * 0.0005
			
			if current_value_sent_to_shader > 0.0:
				glitch.get_material().set_shader_parameter(
					"block_offset_amount",
					current_value_sent_to_shader + mag * REDUCE_STRENGTH_GLITCH * strength
					)
			
			current_value_sent_to_shader = GlobalVariables.glitch_pixel_offset_amount * 0.0005
			
			if current_value_sent_to_shader > 0.0:
				glitch.get_material().set_shader_parameter(
					"pixel_offset_amount",
					current_value_sent_to_shader + mag * REDUCE_STRENGTH_GLITCH * strength
					)
		
		if GlobalVariables.spin_zoom_blur_strength_reaction_strength:
			strength = GlobalVariables.spin_zoom_blur_strength_reaction_strength * 25.0
			current_value_sent_to_shader = GlobalVariables.spin_zoom_blur_strength * 0.1
			
			spin_zoom_blur.get_material().set_shader_parameter(
				"blur_strength",
				current_value_sent_to_shader + mag * REDUCE_STRENGTH_SPIN_ZOOM_BLUR * strength
				)
		
		if GlobalVariables.vignette_size_reaction_strength:
			strength = GlobalVariables.vignette_size_reaction_strength * 0.25
			current_value_sent_to_shader = GlobalVariables.vignette_size * 0.1
			
			vignette.get_material().set_shader_parameter(
				"vignette_size",
				current_value_sent_to_shader - mag * REDUCE_STRENGTH_VIGNETTE * strength
				)
	else:
		if GlobalVariables.chromatic_aberration_strength_reaction_strength:
			chromatic_aberration.get_material().set_shader_parameter(
				"strength",
				remap(GlobalVariables.chromatic_aberration_strength, 0.0, 10.0, 0.0, 0.005)
				)
		
		if GlobalVariables.glitch_offset_reaction_strength:
			glitch.get_material().set_shader_parameter(
				"block_offset_amount",
				GlobalVariables.glitch_block_offset_amount * 0.0005
				)
			glitch.get_material().set_shader_parameter(
				"pixel_offset_amount",
				GlobalVariables.glitch_pixel_offset_amount * 0.0005
				)
		
		if GlobalVariables.spin_zoom_blur_strength_reaction_strength:
			spin_zoom_blur.get_material().set_shader_parameter(
				"blur_strength",
				GlobalVariables.spin_zoom_blur_strength * 0.1
				)
		
		if GlobalVariables.vignette_size_reaction_strength:
			vignette.get_material().set_shader_parameter("vignette_size", GlobalVariables.vignette_size * 0.1)
