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

# This script handles the background shader nodes (shaders are in gdshader files).

#region NODES ##################################

@onready var domain_warping: ColorRect = $DomainWarping
@onready var tides: ColorRect = $Tides
@onready var echoes: ColorRect = $Echoes
@onready var isolines: ColorRect = $Isolines
@onready var current_flow: ColorRect = $CurrentFlow
@onready var simple_gradient: ColorRect = $SimpleGradient
@onready var blur: ColorRect = $Blur
@onready var fake_brightness: ColorRect = $FakeBrightness

#endregion ##################################

#region BACKGROUND SHADER VARIABLES ##################################

@onready var domain_warping_material: ShaderMaterial = domain_warping.get_material()
@onready var tides_material: ShaderMaterial = tides.get_material()
@onready var echoes_material: ShaderMaterial = echoes.get_material()
@onready var isolines_material: ShaderMaterial = isolines.get_material()
@onready var current_flow_material: ShaderMaterial = current_flow.get_material()
@onready var simple_gradient_material: ShaderMaterial = simple_gradient.get_material()

# Variable used to increment shader "frames". Used along with shader speed set by the user.
var custom_time: float = 0.0

var current_speed_on_shader: float
var new_user_speed: float

var noise: FastNoiseLite = FastNoiseLite.new()
var noise_time: float = 0.0
var noise_time_factor: float = 50.0
var amplitude_factor: float = 5.0
var center: Vector2 = Vector2.ZERO
var zoom_for_amplitude: Vector2 = Vector2.ZERO
var addend_from_amp_reaction: Vector2 = Vector2.ZERO
var modified_shader_scale: Vector2

#endregion ##################################

func _ready() -> void:
	noise.fractal_octaves = 2
	noise.frequency = 0.00001
	
	MainUtils.update_visualizer.connect(update_bg_shader_canvas)
	update_bg_shader_canvas()

func _process(_delta: float) -> void:
	if visible:
		if ((GlobalVariables.background_shader_speed_reaction_strength or
		GlobalVariables.shake_amplitude_reaction_strength or
		GlobalVariables.shake_frequency_reaction_strength) and
		MainUtils.audio_playing):
			bg_shader_reaction(MainUtils.cur_mag)
		else:
			amplitude_factor = 5.0
			addend_from_amp_reaction = Vector2.ZERO
			noise_time_factor = 50.0
		
		match GlobalVariables.background_type:
			"Domain Warping":
				custom_time = custom_time + 0.002 * GlobalVariables.domain_warping_speed
				domain_warping_material.set_shader_parameter("speed", custom_time)
			"Tides":
				custom_time = custom_time + 0.002 * GlobalVariables.tides_speed
				tides_material.set_shader_parameter("speed", custom_time)
			"Echoes":
				custom_time = custom_time + 0.002 * GlobalVariables.echoes_speed
				echoes_material.set_shader_parameter("speed", custom_time)
			"Isolines":
				custom_time = custom_time + 0.002 * GlobalVariables.isolines_speed
				isolines_material.set_shader_parameter("speed", custom_time)
			"Current Flow":
				custom_time = custom_time + 0.002 * GlobalVariables.current_flow_speed
				current_flow_material.set_shader_parameter("speed", custom_time)
		
		if GlobalVariables.background_shake_amplitude:
			noise_time = noise_time + noise_time_factor * GlobalVariables.background_shake_frequency
			
		match GlobalVariables.background_type:
			"Domain Warping":
				if (GlobalVariables.background_shake_amplitude and
				GlobalVariables.background_shake_frequency):
					domain_warping.position.x = center.x \
					+ noise.get_noise_2d(noise_time, 0.0) \
					* GlobalVariables.background_shake_amplitude * amplitude_factor
					domain_warping.position.y = center.y \
					+ noise.get_noise_2d(0.0, noise_time) \
					* GlobalVariables.background_shake_amplitude * amplitude_factor
				else:
					domain_warping.position = center
			"Tides":
				if (GlobalVariables.background_shake_amplitude and
				GlobalVariables.background_shake_frequency):
					tides.position.x = center.x \
					+ noise.get_noise_2d(noise_time, 0.0) \
					* GlobalVariables.background_shake_amplitude * amplitude_factor
					tides.position.y = center.y \
					+ noise.get_noise_2d(0.0, noise_time) \
					* GlobalVariables.background_shake_amplitude * amplitude_factor
				else:
					tides.position = center
			"Echoes":
				if (GlobalVariables.background_shake_amplitude and
				GlobalVariables.background_shake_frequency):
					echoes.position.x = center.x \
					+ noise.get_noise_2d(noise_time, 0.0) \
					* GlobalVariables.background_shake_amplitude * amplitude_factor
					echoes.position.y = center.y \
					+ noise.get_noise_2d(0.0, noise_time) \
					* GlobalVariables.background_shake_amplitude * amplitude_factor
				else:
					echoes.position = center
			"Isolines":
				if (GlobalVariables.background_shake_amplitude and
				GlobalVariables.background_shake_frequency):
					isolines.position.x = center.x \
					+ noise.get_noise_2d(noise_time, 0.0) \
					* GlobalVariables.background_shake_amplitude * amplitude_factor
					isolines.position.y = center.y \
					+ noise.get_noise_2d(0.0, noise_time) \
					* GlobalVariables.background_shake_amplitude * amplitude_factor
				else:
					isolines.position = center
			"Current Flow":
				if (GlobalVariables.background_shake_amplitude and
				GlobalVariables.background_shake_frequency):
					current_flow.position.x = center.x \
					+ noise.get_noise_2d(noise_time, 0.0) \
					* GlobalVariables.background_shake_amplitude * amplitude_factor
					current_flow.position.y = center.y \
					+ noise.get_noise_2d(0.0, noise_time) \
					* GlobalVariables.background_shake_amplitude * amplitude_factor
				else:
					current_flow.position = center
			"Simple Gradient":
				if (GlobalVariables.background_shake_amplitude and
				GlobalVariables.background_shake_frequency):
					simple_gradient.position.x = center.x \
					+ noise.get_noise_2d(noise_time, 0.0) \
					* GlobalVariables.background_shake_amplitude * amplitude_factor
					simple_gradient.position.y = center.y \
					+ noise.get_noise_2d(0.0, noise_time) \
					* GlobalVariables.background_shake_amplitude * amplitude_factor
				else:
					simple_gradient.position = center
			
		zoom_for_amplitude = Vector2(
			GlobalVariables.background_shake_amplitude * 0.025,
			GlobalVariables.background_shake_amplitude * 0.025
			)
		
		modified_shader_scale = Vector2(1.0, 1.0) + zoom_for_amplitude + addend_from_amp_reaction
		
		match GlobalVariables.background_type:
			"Domain Warping":
				domain_warping.pivot_offset = domain_warping.size / 2.0
				domain_warping.set_scale(modified_shader_scale)
				if domain_warping.scale < Vector2(1.0, 1.0):
					domain_warping.set_scale(Vector2(1.0, 1.0))
			"Tides":
				tides.pivot_offset = tides.size / 2.0
				tides.set_scale(modified_shader_scale)
				if tides.scale < Vector2(1.0, 1.0):
					tides.set_scale(Vector2(1.0, 1.0))
			"Echoes":
				echoes.pivot_offset = echoes.size / 2.0
				echoes.set_scale(modified_shader_scale)
				if echoes.scale < Vector2(1.0, 1.0):
					echoes.set_scale(Vector2(1.0, 1.0))
			"Isolines":
				isolines.pivot_offset = isolines.size / 2.0
				isolines.set_scale(modified_shader_scale)
				if isolines.scale < Vector2(1.0, 1.0):
					isolines.set_scale(Vector2(1.0, 1.0))
			"Current Flow":
				current_flow.pivot_offset = current_flow.size / 2.0
				current_flow.set_scale(modified_shader_scale)
				if current_flow.scale < Vector2(1.0, 1.0):
					current_flow.set_scale(Vector2(1.0, 1.0))
			"Simple Gradient":
				simple_gradient.pivot_offset = simple_gradient.size / 2.0
				simple_gradient.set_scale(modified_shader_scale)
				if simple_gradient.scale < Vector2(1.0, 1.0):
					simple_gradient.set_scale(Vector2(1.0, 1.0))

func update_bg_shader_canvas() -> void:
	if (not GlobalVariables.background_type == "Solid Colors" and
	not GlobalVariables.background_type == "Image"):
		visible = true
		set_process(true)
		
		match GlobalVariables.background_type:
			"Domain Warping":
				domain_warping.visible = true
				tides.visible = false
				echoes.visible = false
				isolines.visible = false
				current_flow.visible = false
				simple_gradient.visible = false
				
				domain_warping_material.set_shader_parameter(
					"noise_color", GlobalVariables.domain_warping_color
					)
				domain_warping_material.set_shader_parameter(
					"color_mix", GlobalVariables.domain_warping_color_mix
					)
				domain_warping_material.set_shader_parameter(
					"invert_colors", GlobalVariables.domain_warping_invert_colors
					)
				domain_warping_material.set_shader_parameter(
					"hue_shift_amt",
					remap(
						GlobalVariables.domain_warping_hue_shift,
						-10.0,
						10.0,
						-3.14,
						3.14
						)
					)
				domain_warping_material.set_shader_parameter(
					"octaves", GlobalVariables.domain_warping_octaves
					)
				domain_warping_material.set_shader_parameter(
					"frequency_factor", GlobalVariables.domain_warping_frequency_factor
					)
				domain_warping_material.set_shader_parameter(
					"amplitude", GlobalVariables.domain_warping_amplitude * 0.1
					)
				domain_warping_material.set_shader_parameter(
					"frequency_increment",
					GlobalVariables.domain_warping_frequency_increment
					)
				domain_warping_material.set_shader_parameter(
					"amplitude_decrement",
					(10.0 - GlobalVariables.domain_warping_amplitude_decrement + 1.0) * 0.1
					)
			"Tides":
				domain_warping.visible = false
				tides.visible = true
				echoes.visible = false
				isolines.visible = false
				current_flow.visible = false
				simple_gradient.visible = false
				
				tides_material.set_shader_parameter(
					"wave_color", GlobalVariables.tides_wave_color
					)
				tides_material.set_shader_parameter(
					"tint", GlobalVariables.tides_tint
					)
				tides_material.set_shader_parameter(
					"color_mix", GlobalVariables.tides_color_mix
					)
				tides_material.set_shader_parameter(
					"invert_colors", GlobalVariables.tides_invert_colors
					)
				tides_material.set_shader_parameter(
					"hue_shift_amt",
					remap(
						GlobalVariables.tides_hue_shift,
						-10.0,
						10.0,
						-3.14,
						3.14
						)
					)
				tides_material.set_shader_parameter(
					"iterations", GlobalVariables.tides_iterations
					)
			"Echoes":
				domain_warping.visible = false
				tides.visible = false
				echoes.visible = true
				isolines.visible = false
				current_flow.visible = false
				simple_gradient.visible = false
				
				echoes_material.set_shader_parameter(
					"main_color", GlobalVariables.echoes_main_color
					)
				echoes_material.set_shader_parameter(
					"background_color", GlobalVariables.echoes_background_color
					)
				echoes_material.set_shader_parameter(
					"param_20", GlobalVariables.echoes_fractal_uv
					)
				echoes_material.set_shader_parameter(
					"change_origin", GlobalVariables.echoes_change_origin
					)
				echoes_material.set_shader_parameter(
					"iterations", GlobalVariables.echoes_iterations
					)
				echoes_material.set_shader_parameter(
					"param_1", GlobalVariables.echoes_uv_scale
					)
				echoes_material.set_shader_parameter(
					"param_2", GlobalVariables.echoes_vector_scale_1
					)
				echoes_material.set_shader_parameter(
					"param_3", GlobalVariables.echoes_iterator_factor_1
					)
				echoes_material.set_shader_parameter(
					"param_4", GlobalVariables.echoes_uv_length_factor
					)
				echoes_material.set_shader_parameter(
					"param_5", GlobalVariables.echoes_vector_scale_2
					)
				echoes_material.set_shader_parameter(
					"param_6", GlobalVariables.echoes_iterator_factor_2
					)
				echoes_material.set_shader_parameter(
					"param_7", GlobalVariables.echoes_time_scale
					)
				echoes_material.set_shader_parameter(
					"param_8", GlobalVariables.echoes_iterator_factor_3
					)
				echoes_material.set_shader_parameter(
					"param_9", GlobalVariables.echoes_distance_scale
					)
				echoes_material.set_shader_parameter(
					"param_10", GlobalVariables.echoes_pulse_frequency
					)
				echoes_material.set_shader_parameter(
					"param_11", GlobalVariables.echoes_line_thickness
					)
				echoes_material.set_shader_parameter(
					"param_12", GlobalVariables.echoes_iterator_factor_4
					)
				echoes_material.set_shader_parameter(
					"param_21", GlobalVariables.echoes_assignment_mode_1
					)
				echoes_material.set_shader_parameter(
					"param_22", GlobalVariables.echoes_thickness_variation
					)
				echoes_material.set_shader_parameter(
					"param_23", GlobalVariables.echoes_assignment_mode_2
					)
				echoes_material.set_shader_parameter(
					"param_24", GlobalVariables.echoes_thin_lines
					)
				echoes_material.set_shader_parameter(
					"param_25", GlobalVariables.echoes_assignment_mode_3
					)
				echoes_material.set_shader_parameter(
					"param_26", GlobalVariables.echoes_assignment_mode_4
					)
				echoes_material.set_shader_parameter(
					"param_27", GlobalVariables.echoes_fractal_distance
					)
			"Isolines":
				domain_warping.visible = false
				tides.visible = false
				echoes.visible = false
				isolines.visible = true
				current_flow.visible = false
				simple_gradient.visible = false
				
				isolines_material.set_shader_parameter(
					"line_color", GlobalVariables.isolines_line_color
					)
				isolines_material.set_shader_parameter(
					"background_color", GlobalVariables.isolines_background_color
					)
				isolines_material.set_shader_parameter(
					"filled", GlobalVariables.isolines_filled
					)
				isolines_material.set_shader_parameter(
					"line_thickness", GlobalVariables.isolines_line_thickness
					)
				isolines_material.set_shader_parameter(
					"thickness_variation", GlobalVariables.isolines_thickness_variation
					)
				isolines_material.set_shader_parameter(
					"line_amount", GlobalVariables.isolines_line_amount
					)
				isolines_material.set_shader_parameter(
					"uv_scale", GlobalVariables.isolines_uv_scale
					)
			"Current Flow":
				domain_warping.visible = false
				tides.visible = false
				echoes.visible = false
				isolines.visible = false
				current_flow.visible = true
				simple_gradient.visible = false
				
				current_flow_material.set_shader_parameter(
					"main_color", GlobalVariables.current_flow_main_color
					)
				current_flow_material.set_shader_parameter(
					"background_color", GlobalVariables.current_flow_background_color
					)
				current_flow_material.set_shader_parameter(
					"filled", GlobalVariables.current_flow_filled
					)
				current_flow_material.set_shader_parameter(
					"uv_scale", GlobalVariables.current_flow_uv_scale
					)
				current_flow_material.set_shader_parameter(
					"iterations", GlobalVariables.current_flow_iterations
					)
				current_flow_material.set_shader_parameter(
					"wave_thickness", GlobalVariables.current_flow_wave_thickness
					)
			"Simple Gradient":
				domain_warping.visible = false
				tides.visible = false
				echoes.visible = false
				isolines.visible = false
				current_flow.visible = false
				simple_gradient.visible = true
				
				simple_gradient_material.set_shader_parameter(
					"color_1", GlobalVariables.simple_gradient_color_1
					)
				simple_gradient_material.set_shader_parameter(
					"color_2", GlobalVariables.simple_gradient_color_2
					)
				simple_gradient_material.set_shader_parameter(
					"direction", GlobalVariables.simple_gradient_direction
					)
					
		if GlobalVariables.shader_blur > 0:
			blur.visible = true
			blur.get_material().set_shader_parameter(
				"blur_strength",
				remap(float(GlobalVariables.shader_blur), 0.0, 100.0, 0.0, 5.0)
				)
		else:
			blur.visible = false
			
		if abs(GlobalVariables.shader_brightness) != 0.0:
			fake_brightness.visible = true
			if GlobalVariables.shader_brightness > 0.0:
				fake_brightness.color = Color(1.0, 1.0, 1.0, GlobalVariables.shader_brightness)
			else:
				fake_brightness.color = Color(0.0, 0.0, 0.0, abs(GlobalVariables.shader_brightness))
		else:
			fake_brightness.visible = false
	else:
		visible = false
		set_process(false)

func bg_shader_reaction(mag: float, strength: float = 0.0) -> void:
	strength = GlobalVariables.background_shader_speed_reaction_strength * 0.005
	match GlobalVariables.background_type:
		"Domain Warping":
			current_speed_on_shader = domain_warping_material.get_shader_parameter("speed")
			new_user_speed = current_speed_on_shader + mag * strength
			
			custom_time = new_user_speed
		"Tides":
			current_speed_on_shader = tides_material.get_shader_parameter("speed")
			new_user_speed = current_speed_on_shader + mag * strength
			
			custom_time = new_user_speed
		"Echoes":
			current_speed_on_shader = echoes_material.get_shader_parameter("speed")
			new_user_speed = current_speed_on_shader + mag * strength
			
			custom_time = new_user_speed
		"Isolines":
			current_speed_on_shader = isolines_material.get_shader_parameter("speed")
			new_user_speed = current_speed_on_shader + mag * strength
			
			custom_time = new_user_speed
		"Current Flow":
			current_speed_on_shader = current_flow_material.get_shader_parameter("speed")
			new_user_speed = current_speed_on_shader + mag * strength
			
			custom_time = new_user_speed
	
	if (GlobalVariables.shake_amplitude_reaction_strength and
	GlobalVariables.background_shake_amplitude):
		strength = GlobalVariables.shake_amplitude_reaction_strength * 0.1
		amplitude_factor = 5.0 + mag * (strength * 5.0)
		addend_from_amp_reaction = Vector2(mag * strength / 2.0, mag * strength / 2.0)
	else:
		amplitude_factor = 5.0
		addend_from_amp_reaction = Vector2.ZERO
	
	if GlobalVariables.shake_frequency_reaction_strength:
		strength = GlobalVariables.shake_frequency_reaction_strength * 200.0
		noise_time_factor = 50.0 + mag * strength
	else:
		noise_time_factor = 50.0
