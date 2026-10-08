# Oscillody
# Copyright (C) 2025-present Akosmo

# element_canvas_visual_effect.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ElementCanvasVisualEffect
extends ElementCanvas

var element: ElementVisualEffect
var _element_ui_configurations: ElementVisualEffectUIConfigurations

var _color_rect: ColorRect
var _bloom_shader_material: ShaderMaterial
var _chromatic_aberration_shader_material: ShaderMaterial
var _glitch_shader_material: ShaderMaterial
var _grain_shader_material: ShaderMaterial
var _lens_distortion_shader_material: ShaderMaterial
var _scanlines_shader_material: ShaderMaterial
var _spin_zoom_blur_shader_material: ShaderMaterial
var _tape_distortion_shader_material: ShaderMaterial
var _vignette_shader_material: ShaderMaterial

#var _world_environment: WorldEnvironment
#var _environment: Environment

# NOTE: Use these if not making the grain shader static.
#var _soft_light_color_rect: ColorRect
#var _soft_light_shader_material: ShaderMaterial

var _audio_data: RealTimeAudioData

var _glitch_block_time: float
var _glitch_line_time: float
var _scanlines_time: float
var _tape_distortion_wave_time: float
var _tape_distortion_block_time: float

# TEST: Setting reaction controls to non-zero, then removing the audio source, to see if things break.

func _ready() -> void:
	_element_ui_configurations = ElementManager.get_configurations_for_element(element)
	
	_color_rect = ColorRect.new()
	_color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_bloom_shader_material = ShaderMaterial.new()
	_chromatic_aberration_shader_material = ShaderMaterial.new()
	_glitch_shader_material = ShaderMaterial.new()
	_grain_shader_material = ShaderMaterial.new()
	_lens_distortion_shader_material = ShaderMaterial.new()
	_scanlines_shader_material = ShaderMaterial.new()
	_spin_zoom_blur_shader_material = ShaderMaterial.new()
	_tape_distortion_shader_material = ShaderMaterial.new()
	_vignette_shader_material = ShaderMaterial.new()
	_bloom_shader_material.set_shader(preload("uid://nghg812oe6nb"))
	_chromatic_aberration_shader_material.set_shader(preload("uid://c24svugwo5dfm"))
	_glitch_shader_material.set_shader(preload("uid://cxi88e43acnry"))
	_grain_shader_material.set_shader(preload("uid://btoyvqxth4g6p"))
	_lens_distortion_shader_material.set_shader(preload("uid://bgg40oavj55rf"))
	_scanlines_shader_material.set_shader(preload("uid://oon4qo8xclo4"))
	_spin_zoom_blur_shader_material.set_shader(preload("uid://c66qqndbklssq"))
	_tape_distortion_shader_material.set_shader(preload("uid://bhhr0lqg01smy"))
	_vignette_shader_material.set_shader(preload("uid://dfl7xb3hyamjg"))
	#_color_rect.set_material(_shader_material)
	add_child(_color_rect)
	
	#_environment = Environment.new()
	#_environment.set_background(Environment.BG_CANVAS)
	#_environment.set_glow_level(0, 1.0)
	#_environment.set_glow_level(2, 0.6)
	#_environment.set_glow_level(3, 0.4)
	#_environment.set_glow_level(4, 0.2)
	#_environment.set_glow_level(5, 0.1)
	#_environment.set_glow_intensity(0.8)
	#_world_environment = WorldEnvironment.new()
	#_world_environment.set_environment(_environment)
	#add_child(_world_environment)
	
	#_soft_light_color_rect = ColorRect.new()
	#_soft_light_color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	#_soft_light_shader_material = ShaderMaterial.new()
	#_soft_light_shader_material.set_shader(preload("uid://cwmshhxwgfacf"))
	#_soft_light_color_rect.set_material(_blur_shader_material)
	#add_child(_blur_color_rect)
	
	_audio_data = RealTimeAudioData.new()
	
	_glitch_block_time = 0.0
	_glitch_line_time = 0.0
	_scanlines_time = 0.0
	_tape_distortion_wave_time = 0.0
	_tape_distortion_block_time = 0.0
	
	for property_key: StringName in element.get_properties().keys():
		_on_element_property_changed(property_key)
	
	if element.property_changed.connect(_on_element_property_changed):
		printerr("Could not connect signal.")
	
	if AudioManager.stream_list_updated.connect(_on_stream_list_updated):
		printerr("Could not connect signal.")

func _process(_delta: float) -> void:
	if element.get_visual_effect_type() == ElementVisualEffect.VisualEffectType.GLITCH:
		_glitch_block_time += 0.5 * \
		element.get_glitch_block_speed() + \
		_get_reaction_magnitude(element.get_glitch_block_speed_reaction()) - 1.0
		_glitch_shader_material.set_shader_parameter("block_time", _glitch_block_time)
		_glitch_line_time += 0.5 * \
		element.get_glitch_line_speed() + \
		_get_reaction_magnitude(element.get_glitch_line_speed_reaction()) - 1.0
		_glitch_shader_material.set_shader_parameter("line_time", _glitch_line_time)
	elif element.get_visual_effect_type() == ElementVisualEffect.VisualEffectType.SCANLINES:
		_scanlines_time += 0.5 * \
		element.get_scanlines_speed() + \
		_get_reaction_magnitude(element.get_scanlines_speed_reaction()) - 1.0
		_scanlines_shader_material.set_shader_parameter("custom_time", _scanlines_time)
	elif element.get_visual_effect_type() == ElementVisualEffect.VisualEffectType.TAPE_DISTORTION:
		_tape_distortion_wave_time += 0.02 * element.get_tape_distortion_wave_speed()
		_tape_distortion_shader_material.set_shader_parameter("wave_speed", _tape_distortion_wave_time)
		_tape_distortion_block_time += 0.02 * element.get_tape_distortion_block_speed()
		_tape_distortion_shader_material.set_shader_parameter("block_speed", _tape_distortion_block_time)
	
	if element.get_visual_effect_type() == ElementVisualEffect.VisualEffectType.BLOOM:
		_bloom_shader_material.set_shader_parameter(
			"opacity",
			element.get_bloom_opacity() + \
			_get_reaction_magnitude(element.get_bloom_opacity_reaction() * 0.5) - \
			1.0
		)
	elif element.get_visual_effect_type() == ElementVisualEffect.VisualEffectType.CHROMATIC_ABERRATION:
		_chromatic_aberration_shader_material.set_shader_parameter(
			"amount",
			(element.get_chromatic_aberration_amount() + \
			_get_reaction_magnitude(element.get_chromatic_aberration_amount_reaction()) - \
			1.0) * \
			0.01 
		)
	elif element.get_visual_effect_type() == ElementVisualEffect.VisualEffectType.GLITCH:
		_glitch_shader_material.set_shader_parameter(
			"block_offset_amount",
			(element.get_glitch_block_offset_amount() + \
			_get_reaction_magnitude(element.get_glitch_block_offset_amount_reaction()) - \
			1.0) * \
			0.02
		)
		_glitch_shader_material.set_shader_parameter(
			"line_offset_amount",
			(element.get_glitch_line_offset_amount() + \
			_get_reaction_magnitude(element.get_glitch_line_offset_amount_reaction()) - \
			1.0) * \
			0.02
		)
	elif element.get_visual_effect_type() == ElementVisualEffect.VisualEffectType.LENS_DISTORTION:
		_lens_distortion_shader_material.set_shader_parameter(
			"amount",
			element.get_lens_distortion_amount() + \
			_get_reaction_magnitude(element.get_lens_distortion_amount_reaction() * 0.2) - \
			1.0
		)
		_lens_distortion_shader_material.set_shader_parameter(
			"zoom_factor",
			element.get_lens_distortion_zoom_factor() + \
			_get_reaction_magnitude(element.get_lens_distortion_zoom_factor_reaction() * 0.2) - \
			1.0
		)
	elif element.get_visual_effect_type() == ElementVisualEffect.VisualEffectType.SPIN_ZOOM_BLUR:
		_spin_zoom_blur_shader_material.set_shader_parameter(
			"amount",
			element.get_spin_zoom_blur_amount() + \
			_get_reaction_magnitude(element.get_spin_zoom_blur_amount_reaction()) - \
			1.0
		)
	elif element.get_visual_effect_type() == ElementVisualEffect.VisualEffectType.VIGNETTE:
		_vignette_shader_material.set_shader_parameter(
			"size",
			element.get_vignette_size() * \
			4.0 + \
			_get_reaction_magnitude(element.get_vignette_size_reaction()) - \
			1.0
		)

func get_element() -> Element:
	return element

func _get_visual_effect_material(p_visual_effect: ElementVisualEffect.VisualEffectType) -> ShaderMaterial:
	match p_visual_effect:
		ElementVisualEffect.VisualEffectType.BLOOM:
			return _bloom_shader_material
		ElementVisualEffect.VisualEffectType.CHROMATIC_ABERRATION:
			return _chromatic_aberration_shader_material
		ElementVisualEffect.VisualEffectType.GLITCH:
			return _glitch_shader_material
		ElementVisualEffect.VisualEffectType.GRAIN:
			return _grain_shader_material
		ElementVisualEffect.VisualEffectType.LENS_DISTORTION:
			return _lens_distortion_shader_material
		ElementVisualEffect.VisualEffectType.SCANLINES:
			return _scanlines_shader_material
		ElementVisualEffect.VisualEffectType.SPIN_ZOOM_BLUR:
			return _spin_zoom_blur_shader_material
		ElementVisualEffect.VisualEffectType.TAPE_DISTORTION:
			return _tape_distortion_shader_material
		ElementVisualEffect.VisualEffectType.VIGNETTE:
			return _vignette_shader_material
		_:
			printerr("Unknown visual effect type, returning empty.")
			return ShaderMaterial.new()

func _get_reaction_magnitude(p_amount: float) -> float:
	return 1.0 + _audio_data.get_current_magnitude() * p_amount

func _on_element_property_changed(p_property: StringName) -> void:
	match p_property:
		ElementVisualEffect.SN_ELEMENT_NAME:
			set_name(element.get_element_name() + "_" + str(element.get_element_unique_id()))
		ElementVisualEffect.SN_ELEMENT_TYPE:
			if element.get_element_type() != Element.ElementType.VISUAL_EFFECT:
				queue_free()
		ElementVisualEffect.SN_ELEMENT_LAYER:
			set_layer(element.get_element_layer())
			#_environment.set_canvas_max_layer(element.get_element_layer() - 2048)
		ElementVisualEffect.SN_ELEMENT_VISIBILITY:
			set_visible(element.get_element_visibility())
			set_process(element.get_element_visibility())
		ElementVisualEffect.SN_VISUAL_EFFECT_TYPE:
			_color_rect.set_material(_get_visual_effect_material(element.get_visual_effect_type()))
			#_environment.set_glow_enabled(
				#element.get_visual_effect_type() == ElementVisualEffect.VisualEffectType.BLOOM
			#)
			#_color_rect.set_visible(
				#not element.get_visual_effect_type() == ElementVisualEffect.VisualEffectType.BLOOM
			#)
			
			_element_ui_configurations.enable_visual_effect_visibility(element.get_visual_effect_type())
			_element_ui_configurations.set_reaction_visibility(
				element.get_visual_effect_type(),
				not element.get_audio_source().is_empty()
			)
		ElementVisualEffect.SN_BLOOM_OPACITY:
			pass
		ElementVisualEffect.SN_BLOOM_RADIUS:
			_bloom_shader_material.set_shader_parameter("radius", element.get_bloom_radius())
		ElementVisualEffect.SN_BLOOM_BLEND_MODE:
			_bloom_shader_material.set_shader_parameter("blend_mode", element.get_bloom_blend_mode())
			#_environment.set_glow_blend_mode(element.get_bloom_blend_mode() as Environment.GlowBlendMode)
		ElementVisualEffect.SN_CHROMATIC_ABERRATION_AMOUNT:
			pass
		ElementVisualEffect.SN_GLITCH_BLOCK_OFFSET_AMOUNT:
			pass
		ElementVisualEffect.SN_GLITCH_BLOCK_SPEED:
			pass
		ElementVisualEffect.SN_GLITCH_LINE_OFFSET_AMOUNT:
			pass
		ElementVisualEffect.SN_GLITCH_LINE_SPEED:
			pass
		ElementVisualEffect.SN_GRAIN_OPACITY:
			_grain_shader_material.set_shader_parameter("opacity", element.get_grain_opacity())
		ElementVisualEffect.SN_GRAIN_BLEND_MODE:
			_grain_shader_material.set_shader_parameter("blend_mode", element.get_grain_blend_mode())
			print(element.get_grain_blend_mode())
		ElementVisualEffect.SN_GRAIN_STATIC:
			_grain_shader_material.set_shader_parameter("static", element.get_grain_static())
		ElementVisualEffect.SN_GRAIN_BLUR:
			_grain_shader_material.set_shader_parameter("blur", element.get_grain_blur())
		ElementVisualEffect.SN_LENS_DISTORTION_AMOUNT:
			pass
		ElementVisualEffect.SN_LENS_DISTORTION_ZOOM_FACTOR:
			pass
		ElementVisualEffect.SN_LENS_DISTORTION_BORDER:
			_lens_distortion_shader_material.set_shader_parameter(
				"border",
				element.get_lens_distortion_border()
			)
		ElementVisualEffect.SN_LENS_DISTORTION_BORDER_COLOR:
			_lens_distortion_shader_material.set_shader_parameter(
				"border_color",
				element.get_lens_distortion_border_color()
			)
		ElementVisualEffect.SN_LENS_DISTORTION_CHROMATIC_ABERRATION_AMOUNT:
			_lens_distortion_shader_material.set_shader_parameter(
				"chromatic_aberration_amount",
				element.get_lens_distortion_chromatic_aberration_amount()
			)
		ElementVisualEffect.SN_SCANLINES_OPACITY:
			_scanlines_shader_material.set_shader_parameter("opacity", element.get_scanlines_opacity())
		ElementVisualEffect.SN_SCANLINES_INTERLACED_SCAN:
			_scanlines_shader_material.set_shader_parameter(
				"interlaced_scan",
				element.get_scanlines_interlaced_scan()
			)
		ElementVisualEffect.SN_SCANLINES_SCALE:
			_scanlines_shader_material.set_shader_parameter(
				"scale",
				remap(element.get_scanlines_scale(), 0.0, 1.0, 200.0, 800.0)
			)
		ElementVisualEffect.SN_SCANLINES_SPEED:
			pass
		ElementVisualEffect.SN_SPIN_ZOOM_BLUR_AMOUNT:
			pass
		ElementVisualEffect.SN_SPIN_ZOOM_BLUR_MODE:
			_spin_zoom_blur_shader_material.set_shader_parameter("mode", element.get_spin_zoom_blur_mode())
		ElementVisualEffect.SN_TAPE_DISTORTION_WAVE_OFFSET_AMOUNT:
			_tape_distortion_shader_material.set_shader_parameter(
				"wave_offset_amount",
				element.get_tape_distortion_wave_offset_amount() * 0.5
			)
		ElementVisualEffect.SN_TAPE_DISTORTION_WAVE_AMOUNT:
			_tape_distortion_shader_material.set_shader_parameter(
				"wave_amount",
				element.get_tape_distortion_wave_amount() * 4.0 + 2.0
			)
		ElementVisualEffect.SN_TAPE_DISTORTION_WAVE_THICKNESS:
			_tape_distortion_shader_material.set_shader_parameter(
				"wave_thickness",
				element.get_tape_distortion_wave_thickness() * 90.0 + 10.0
			)
		ElementVisualEffect.SN_TAPE_DISTORTION_WAVE_SPEED:
			pass
		ElementVisualEffect.SN_TAPE_DISTORTION_BLOCK_OFFSET_AMOUNT:
			_tape_distortion_shader_material.set_shader_parameter(
				"block_offset_amount",
				element.get_tape_distortion_block_offset_amount() * 0.1
			)
		ElementVisualEffect.SN_TAPE_DISTORTION_BLOCK_AMOUNT:
			_tape_distortion_shader_material.set_shader_parameter(
				"block_amount",
				element.get_tape_distortion_block_amount() * 7.0 + 1.0
			)
		ElementVisualEffect.SN_TAPE_DISTORTION_BLOCK_SPEED:
			pass
		ElementVisualEffect.SN_VIGNETTE_SIZE:
			pass
		ElementVisualEffect.SN_VIGNETTE_COLOR:
			_vignette_shader_material.set_shader_parameter("color", element.get_vignette_color())
		ElementVisualEffect.SN_VIGNETTE_SHARPNESS:
			_vignette_shader_material.set_shader_parameter(
				"sharpness",
				pow(element.get_vignette_sharpness() * 19.0 + 1.0, 2.0)
			)
		ElementVisualEffect.SN_VIGNETTE_CURVE:
			_vignette_shader_material.set_shader_parameter("curve", element.get_vignette_curve() * 19.0 + 1.0)
		ElementVisualEffect.SN_VIGNETTE_SHAPE:
			_vignette_shader_material.set_shader_parameter("shape", element.get_vignette_shape())
		ElementVisualEffect.SN_VIGNETTE_FALLOFF_FUNCTION:
			_vignette_shader_material.set_shader_parameter(
				"falloff_function",
				element.get_vignette_falloff_function()
			)
		ElementVisualEffect.SN_AUDIO_SOURCE:
			_on_stream_list_updated()
		ElementVisualEffect.SN_BEGIN_FREQUENCY:
			_audio_data.set_begin_frequency(element.get_begin_frequency())
		ElementVisualEffect.SN_END_FREQUENCY:
			_audio_data.set_end_frequency(element.get_end_frequency())
		ElementVisualEffect.SN_MINIMUM_DECIBELS:
			_audio_data.set_minimum_decibels(element.get_minimum_decibels())
		ElementVisualEffect.SN_SMOOTHING_TYPE:
			_audio_data.set_smoothing_type(element.get_smoothing_type())
		ElementVisualEffect.SN_SMOOTHING_AMOUNT:
			_audio_data.set_smoothing_amount(element.get_smoothing_amount())
		ElementVisualEffect.SN_BLOOM_OPACITY_REACTION:
			pass
		ElementVisualEffect.SN_CHROMATIC_ABERRATION_AMOUNT_REACTION:
			pass
		ElementVisualEffect.SN_GLITCH_BLOCK_OFFSET_AMOUNT_REACTION:
			pass
		ElementVisualEffect.SN_GLITCH_BLOCK_SPEED_REACTION:
			pass
		ElementVisualEffect.SN_GLITCH_LINE_OFFSET_AMOUNT_REACTION:
			pass
		ElementVisualEffect.SN_GLITCH_LINE_SPEED_REACTION:
			pass
		ElementVisualEffect.SN_LENS_DISTORTION_AMOUNT_REACTION:
			pass
		ElementVisualEffect.SN_LENS_DISTORTION_ZOOM_FACTOR_REACTION:
			pass
		ElementVisualEffect.SN_SCANLINES_SPEED_REACTION:
			pass
		ElementVisualEffect.SN_SPIN_ZOOM_BLUR_AMOUNT_REACTION:
			pass
		ElementVisualEffect.SN_VIGNETTE_SIZE_REACTION:
			pass

func _on_stream_list_updated() -> void:
	if not element.get_audio_source().is_empty():
		var spectrum_analyzer_effect_instance: AudioEffectSpectrumAnalyzerInstance
		spectrum_analyzer_effect_instance = AudioServer.get_bus_effect_instance(
			AudioServer.get_bus_index(element.get_audio_source()),
			1,
			0
		)
		_audio_data.set_spectrum_analyzer_effect_instance(spectrum_analyzer_effect_instance)
	else:
		_audio_data.set_spectrum_analyzer_effect_instance(null)
	
	_element_ui_configurations.set_reaction_visibility(
		element.get_visual_effect_type(),
		not element.get_audio_source().is_empty()
	)
