# Oscillody
# Copyright (C) 2025-present Akosmo

# element_canvas_shader.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ElementCanvasShader
extends ElementCanvas

var element: ElementShader
var _element_ui_configurations: ElementShaderUIConfigurations

var _color_rect: ColorRect
var _shader_material: ShaderMaterial

var _blur_color_rect: ColorRect
var _blur_shader_material: ShaderMaterial

var _brightness_color_rect: ColorRect

var _noise_utilities: NoiseUtilities
var _audio_data: RealTimeAudioData

var _shader_time: float

# TEST: Setting reaction controls to non-zero, then removing the audio source, to see if things break.

func _ready() -> void:
	#set_name(element.get_element_name() + "_" + str(element.get_unique_id()))
	#set_layer(element.get_layer())
	
	_element_ui_configurations = preload("uid://ccdqa8ifs0fso")
	#_element_ui_configurations.enable_shader_visibility(element.get_shader_type())
	#_element_ui_configurations.set_reaction_visibility(not element.get_audio_source().is_empty())
	
	_color_rect = ColorRect.new()
	_color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_shader_material = ShaderMaterial.new()
	#_shader_material.set_shader(_get_shader_for_material(element.get_shader_type()))
	_color_rect.set_material(_shader_material)
	add_child(_color_rect)
	
	_blur_color_rect = ColorRect.new()
	_blur_color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_blur_shader_material = ShaderMaterial.new()
	_blur_shader_material.set_shader(preload("uid://nddyss8tny8y"))
	_blur_color_rect.set_material(_blur_shader_material)
	add_child(_blur_color_rect)
	
	_brightness_color_rect = ColorRect.new()
	_brightness_color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	#if element.get_shader_brightness() > 0.0:
		#_brightness_color_rect.set_color(Color(1.0, 1.0, 1.0, element.get_shader_brightness()))
	#elif element.get_shader_brightness() < 0.0:
		#_brightness_color_rect.set_color(Color(0.0, 0.0, 0.0, absf(element.get_shader_brightness())))
	#else:
		#_brightness_color_rect.set_color(Color(1.0, 1.0, 1.0, 0.0))
	add_child(_brightness_color_rect)
	
	_noise_utilities = NoiseUtilities.new()
	#_noise_utilities.set_seed(element.get_shake_seed())
	#_noise_utilities.reset_noise_scroll()
	
	_audio_data = RealTimeAudioData.new()
	#if not element.get_audio_source().is_empty():
		#var spectrum_analyzer_effect_instance: AudioEffectSpectrumAnalyzerInstance
		#spectrum_analyzer_effect_instance = AudioServer.get_bus_effect_instance(
			#AudioServer.get_bus_index(element.get_audio_source()),
			#0,
			#0
		#)
		#_audio_data.set_spectrum_analyzer_effect_instance(spectrum_analyzer_effect_instance)
	#else:
		#_audio_data.set_spectrum_analyzer_effect_instance(null)
	#_audio_data.set_begin_frequency(element.get_begin_frequency())
	#_audio_data.set_end_frequency(element.get_end_frequency())
	#_audio_data.set_minimum_decibels(element.get_minimum_decibels())
	#_audio_data.set_smoothing_type(element.get_smoothing_type())
	#_audio_data.set_smoothing_amount(element.get_smoothing_amount())
	
	_shader_time = 0.0
	
	for property_key: StringName in element.get_property_dictionary().keys():
		_on_element_property_changed(property_key)
	
	if element.property_changed.connect(_on_element_property_changed):
		printerr("Could not connect signal.")
	
	if AudioManager.stream_list_updated.connect(_on_stream_list_updated):
		printerr("Could not connect signal.")
	if SettingsManager.sync_element_shake_requested.connect(_on_sync_element_shake):
		printerr("Could not connect signal.")
	if WindowUtilities.subviewport_size_changed.connect(_on_subviewport_size_changed):
		printerr("Could not connect signal.")

func _process(_delta: float) -> void:
	_shader_time += 0.04 * \
	element.get_shader_speed() + \
	_get_reaction_magnitude(element.get_shader_speed_reaction() * 0.05) - 1.0
	_shader_material.set_shader_parameter("speed", _shader_time)
	
	if not is_equal_approx(element.get_shader_rotation_reaction(), 0.0):
		_color_rect.set_rotation_degrees(
			element.get_shader_rotation() + \
			(_get_reaction_magnitude(element.get_shader_rotation_reaction() * 50.0) - 1.0)
		)
	else:
		_color_rect.set_rotation_degrees(element.get_shader_rotation())
	
	if element.get_shader_scale_reaction() > 0.0:
		_color_rect.set_scale(
			Vector2.ONE * \
			element.get_shader_scale() * \
			_get_reaction_magnitude(element.get_shader_scale_reaction()) + \
			_get_scale_for_amplitude()
		)
	else:
		_color_rect.set_scale(Vector2.ONE * element.get_shader_scale() + _get_scale_for_amplitude())
	
	if element.get_shake_frequency() > 0.0:
		_noise_utilities.increment_noise_scroll(
			element.get_shake_frequency() * \
			100.0 * \
			_get_reaction_magnitude(element.get_shake_frequency_reaction() * 10.0)
		)
	elif element.get_shake_frequency_reaction() > 0.0:
		_noise_utilities.increment_noise_scroll(
			100.0 * \
			(_get_reaction_magnitude(element.get_shake_frequency_reaction()) - 1.0)
		)
	if element.get_shake_frequency() > 0.0 or element.get_shake_frequency_reaction() > 0.0:
		if element.get_shake_amplitude() > 0.0:
			_color_rect.set_position(
				_get_fixed_position() + \
				_noise_utilities.get_noise_vector() * \
				element.get_shake_amplitude() * \
				200.0 * \
				_get_reaction_magnitude(element.get_shake_amplitude_reaction())
			)
			_color_rect.set_scale(Vector2.ONE * element.get_shader_scale() + _get_scale_for_amplitude())
		elif element.get_shake_amplitude_reaction() > 0.0:
			_color_rect.set_position(
				_get_fixed_position() + \
				_noise_utilities.get_noise_vector() * \
				element.get_shake_amplitude_reaction() * \
				200.0 * \
				(_get_reaction_magnitude(element.get_shake_amplitude_reaction()) - 1.0)
			)
			_color_rect.set_scale(Vector2.ONE * element.get_shader_scale() + _get_scale_for_amplitude())
		else:
			_color_rect.set_position(_get_fixed_position())
	else:
		_color_rect.set_position(_get_fixed_position())

func get_element() -> Element:
	return element

func _get_shader_for_material(p_shader: ElementShader.ShaderType) -> Shader:
	match p_shader:
		ElementShader.ShaderType.CURRENT_FLOW:
			return preload("uid://dr5ho3b0t0qp8")
		ElementShader.ShaderType.DOMAIN_WARPING:
			return preload("uid://b7ja07xbjdjlm")
		ElementShader.ShaderType.ECHOES:
			return preload("uid://cym35ti4xlrtv")
		ElementShader.ShaderType.ISOLINES:
			return preload("uid://cspxuscf7xri7")
		ElementShader.ShaderType.SIMPLE_GRADIENT:
			return preload("uid://ijhyd3qa7ldu")
		ElementShader.ShaderType.TIDES:
			return preload("uid://dc5q4smj13aiv")
		_:
			printerr("Unknown shader type, returning empty.")
			return Shader.new()

func _get_fixed_position() -> Vector2:
	return Vector2(element.get_shader_x_position(), element.get_shader_y_position()) * \
	Vector2(WindowUtilities.get_subviewport_size()) - _color_rect.get_pivot_offset()

func _get_scale_for_amplitude() -> Vector2:
	var ret: Vector2 = Vector2.ZERO
	if element.get_shake_amplitude_compensation():
		if element.get_shake_amplitude() > 0.0:
			ret = Vector2.ONE * \
			element.get_shake_amplitude() * \
			_get_reaction_magnitude(element.get_shake_amplitude_reaction()) * \
			400.0 / \
			minf(_color_rect.get_size().x, _color_rect.get_size().y)
		elif element.get_shake_amplitude_reaction() > 0.0:
			ret = Vector2.ONE * \
			element.get_shake_amplitude_reaction() * \
			400.0 / \
			minf(_color_rect.get_size().x, _color_rect.get_size().y)
			ret *= _get_reaction_magnitude(element.get_shake_amplitude_reaction()) - 1.0
	
	return ret

func _get_reaction_magnitude(p_amount: float) -> float:
	return 1.0 + _audio_data.get_current_magnitude() * p_amount

func _on_element_property_changed(p_property: StringName) -> void:
	match p_property:
		ElementShader.SN_NAME:
			set_name(element.get_element_name() + "_" + str(element.get_unique_id()))
		ElementShader.SN_TYPE:
			if element.get_type() != Element.ElementType.SHADER:
				queue_free()
		ElementShader.SN_LAYER:
			set_layer(element.get_layer())
		ElementShader.SN_VISIBILITY:
			set_visible(element.get_visibility())
			set_process(element.get_visibility())
		ElementShader.SN_SHADER_TYPE:
			_shader_material.set_shader(_get_shader_for_material(element.get_shader_type()))
			_element_ui_configurations.enable_shader_visibility(element.get_shader_type())
		ElementShader.SN_CURRENT_FLOW_WAVE_COLOR:
			if element.get_shader_type() == ElementShader.ShaderType.CURRENT_FLOW:
				_shader_material.set_shader_parameter("wave_color", element.get_current_flow_wave_color())
		ElementShader.SN_CURRENT_FLOW_BACKGROUND_COLOR:
			if element.get_shader_type() == ElementShader.ShaderType.CURRENT_FLOW:
				_shader_material.set_shader_parameter(
					"background_color",
					element.get_current_flow_background_color()
				)
		ElementShader.SN_CURRENT_FLOW_ITERATIONS:
			if element.get_shader_type() == ElementShader.ShaderType.CURRENT_FLOW:
				_shader_material.set_shader_parameter("iterations", element.get_current_flow_iterations())
		ElementShader.SN_CURRENT_FLOW_UV_SCALE:
			if element.get_shader_type() == ElementShader.ShaderType.CURRENT_FLOW:
				_shader_material.set_shader_parameter(
					"uv_scale",
					element.get_current_flow_uv_scale() * 20.0
				)
		ElementShader.SN_CURRENT_FLOW_FILLED:
			if element.get_shader_type() == ElementShader.ShaderType.CURRENT_FLOW:
				_shader_material.set_shader_parameter("filled", element.get_current_flow_filled())
		ElementShader.SN_CURRENT_FLOW_WAVE_THICKNESS:
			if element.get_shader_type() == ElementShader.ShaderType.CURRENT_FLOW:
				_shader_material.set_shader_parameter(
					"wave_thickness",
					remap(element.get_current_flow_wave_thickness(), 0.1, 1.0, 0.01, 0.5)
				)
		ElementShader.SN_DOMAIN_WARPING_COLOR:
			if element.get_shader_type() == ElementShader.ShaderType.DOMAIN_WARPING:
				_shader_material.set_shader_parameter("noise_color", element.get_domain_warping_color())
		ElementShader.SN_DOMAIN_WARPING_COLOR_MIX:
			if element.get_shader_type() == ElementShader.ShaderType.DOMAIN_WARPING:
				_shader_material.set_shader_parameter("color_mix", element.get_domain_warping_color_mix())
		ElementShader.SN_DOMAIN_WARPING_INVERT_COLORS:
			if element.get_shader_type() == ElementShader.ShaderType.DOMAIN_WARPING:
				_shader_material.set_shader_parameter(
					"invert_colors",
					element.get_domain_warping_invert_colors()
				)
		ElementShader.SN_DOMAIN_WARPING_HUE_SHIFT:
			if element.get_shader_type() == ElementShader.ShaderType.DOMAIN_WARPING:
				_shader_material.set_shader_parameter(
					"hue_shift",
					remap(element.get_domain_warping_hue_shift(), -1.0, 1.0, -PI, PI)
				)
		ElementShader.SN_DOMAIN_WARPING_OCTAVES:
			if element.get_shader_type() == ElementShader.ShaderType.DOMAIN_WARPING:
				_shader_material.set_shader_parameter("octaves", element.get_domain_warping_octaves())
		ElementShader.SN_DOMAIN_WARPING_FREQUENCY_FACTOR:
			if element.get_shader_type() == ElementShader.ShaderType.DOMAIN_WARPING:
				_shader_material.set_shader_parameter(
					"frequency_factor",
					element.get_domain_warping_frequency_factor()
				)
		ElementShader.SN_DOMAIN_WARPING_AMPLITUDE:
			if element.get_shader_type() == ElementShader.ShaderType.DOMAIN_WARPING:
				_shader_material.set_shader_parameter("amplitude", element.get_domain_warping_amplitude())
		ElementShader.SN_DOMAIN_WARPING_FREQUENCY_INCREMENT:
			if element.get_shader_type() == ElementShader.ShaderType.DOMAIN_WARPING:
				_shader_material.set_shader_parameter(
					"frequency_increment",
					element.get_domain_warping_frequency_increment()
				)
		ElementShader.SN_DOMAIN_WARPING_AMPLITUDE_DECREMENT:
			if element.get_shader_type() == ElementShader.ShaderType.DOMAIN_WARPING:
				_shader_material.set_shader_parameter(
					"amplitude_decrement",
					element.get_domain_warping_amplitude_decrement()
				)
		ElementShader.SN_ECHOES_PULSE_COLOR:
			if element.get_shader_type() == ElementShader.ShaderType.ECHOES:
				_shader_material.set_shader_parameter("pulse_color", element.get_echoes_pulse_color())
		ElementShader.SN_ECHOES_BACKGROUND_COLOR:
			if element.get_shader_type() == ElementShader.ShaderType.ECHOES:
				_shader_material.set_shader_parameter(
					"background_color",
					element.get_echoes_background_color()
				)
		ElementShader.SN_ECHOES_ITERATIONS:
			if element.get_shader_type() == ElementShader.ShaderType.ECHOES:
				_shader_material.set_shader_parameter("iterations", element.get_echoes_iterations())
		ElementShader.SN_ECHOES_UV_SCALE:
			if element.get_shader_type() == ElementShader.ShaderType.ECHOES:
				_shader_material.set_shader_parameter("uv_scale", element.get_echoes_uv_scale() * 10.0)
		ElementShader.SN_ECHOES_FRACTIONAL_UV:
			if element.get_shader_type() == ElementShader.ShaderType.ECHOES:
				_shader_material.set_shader_parameter("fractional_uv", element.get_echoes_fractional_uv())
		ElementShader.SN_ECHOES_SPLIT:
			if element.get_shader_type() == ElementShader.ShaderType.ECHOES:
				_shader_material.set_shader_parameter("split", element.get_echoes_split())
		ElementShader.SN_ECHOES_ITERATOR_FACTOR:
			if element.get_shader_type() == ElementShader.ShaderType.ECHOES:
				_shader_material.set_shader_parameter(
					"iterator_factor",
					element.get_echoes_iterator_factor()
				)
		ElementShader.SN_ECHOES_PULSE_DURATION:
			if element.get_shader_type() == ElementShader.ShaderType.ECHOES:
				_shader_material.set_shader_parameter(
					"pulse_duration",
					remap(element.get_echoes_pulse_duration(), 0.1, 1.0, 1.0, 16.0)
				)
		ElementShader.SN_ECHOES_PULSE_OSCILLATION:
			if element.get_shader_type() == ElementShader.ShaderType.ECHOES:
				_shader_material.set_shader_parameter(
					"pulse_oscillation",
					remap(element.get_echoes_pulse_oscillation(), 0.05, 1.0, 0.01, 2.0)
				)
		ElementShader.SN_ECHOES_PULSE_THICKNESS:
			if element.get_shader_type() == ElementShader.ShaderType.ECHOES:
				_shader_material.set_shader_parameter(
					"pulse_thickness",
					element.get_echoes_pulse_thickness() * 0.1
				)
		ElementShader.SN_ECHOES_PULSE_MODE:
			if element.get_shader_type() == ElementShader.ShaderType.ECHOES:
				_shader_material.set_shader_parameter("pulse_mode", element.get_echoes_pulse_mode())
		ElementShader.SN_ISOLINES_LINE_COLOR:
			if element.get_shader_type() == ElementShader.ShaderType.ISOLINES:
				_shader_material.set_shader_parameter("line_color", element.get_isolines_line_color())
		ElementShader.SN_ISOLINES_BACKGROUND_COLOR:
			if element.get_shader_type() == ElementShader.ShaderType.ISOLINES:
				_shader_material.set_shader_parameter(
					"background_color",
					element.get_isolines_background_color()
				)
		ElementShader.SN_ISOLINES_UV_SCALE:
			if element.get_shader_type() == ElementShader.ShaderType.ISOLINES:
				_shader_material.set_shader_parameter("uv_scale", element.get_isolines_uv_scale() * 20.0)
		ElementShader.SN_ISOLINES_FILLED:
			if element.get_shader_type() == ElementShader.ShaderType.ISOLINES:
				_shader_material.set_shader_parameter("filled", element.get_isolines_filled())
		ElementShader.SN_ISOLINES_LINE_THICKNESS:
			if element.get_shader_type() == ElementShader.ShaderType.ISOLINES:
				_shader_material.set_shader_parameter(
					"line_thickness",
					element.get_isolines_line_thickness() * 20.0
				)
		ElementShader.SN_ISOLINES_THICKNESS_VARIATION:
			if element.get_shader_type() == ElementShader.ShaderType.ISOLINES:
				_shader_material.set_shader_parameter(
					"thickness_variation",
					# TEST: Either use shader range, or UI range.
					lerp(0.5, 1.2, 1.0 - pow(2.0, -10.0 * element.get_isolines_thickness_variation()))
				)
		ElementShader.SN_ISOLINES_LINE_AMOUNT:
			if element.get_shader_type() == ElementShader.ShaderType.ISOLINES:
				_shader_material.set_shader_parameter(
					"line_amount",
					remap(element.get_isolines_line_amount(), 0.05, 1.0, 1.0, 50.0)
				)
		ElementShader.SN_SIMPLE_GRADIENT_COLOR_1:
			if element.get_shader_type() == ElementShader.ShaderType.SIMPLE_GRADIENT:
				_shader_material.set_shader_parameter("color_1", element.get_simple_gradient_color_1())
		ElementShader.SN_SIMPLE_GRADIENT_COLOR_2:
			if element.get_shader_type() == ElementShader.ShaderType.SIMPLE_GRADIENT:
				_shader_material.set_shader_parameter("color_2", element.get_simple_gradient_color_2())
		ElementShader.SN_SIMPLE_GRADIENT_DIRECTION:
			if element.get_shader_type() == ElementShader.ShaderType.SIMPLE_GRADIENT:
				_shader_material.set_shader_parameter("direction", element.get_simple_gradient_direction())
		ElementShader.SN_TIDES_COLOR:
			if element.get_shader_type() == ElementShader.ShaderType.TIDES:
				_shader_material.set_shader_parameter("wave_color", element.get_tides_color())
		ElementShader.SN_TIDES_TINT:
			if element.get_shader_type() == ElementShader.ShaderType.TIDES:
				_shader_material.set_shader_parameter("tint", element.get_tides_tint())
		ElementShader.SN_TIDES_COLOR_MIX:
			if element.get_shader_type() == ElementShader.ShaderType.TIDES:
				_shader_material.set_shader_parameter("color_mix", element.get_tides_color_mix())
		ElementShader.SN_TIDES_INVERT_COLORS:
			if element.get_shader_type() == ElementShader.ShaderType.TIDES:
				_shader_material.set_shader_parameter("invert_colors", element.get_tides_invert_colors())
		ElementShader.SN_TIDES_HUE_SHIFT:
			if element.get_shader_type() == ElementShader.ShaderType.TIDES:
				_shader_material.set_shader_parameter(
					"hue_shift",
					remap(element.get_tides_hue_shift(), -1.0, 1.0, -PI, PI)
				)
		ElementShader.SN_TIDES_ITERATIONS:
			if element.get_shader_type() == ElementShader.ShaderType.TIDES:
				_shader_material.set_shader_parameter("iterations", element.get_tides_iterations())
		ElementShader.SN_SHADER_SPEED:
			pass
		ElementShader.SN_SHADER_X_POSITION, ElementShader.SN_SHADER_Y_POSITION:
			pass
		ElementShader.SN_SHADER_ROTATION:
			pass
		ElementShader.SN_SHADER_SCALE:
			pass
		ElementShader.SN_SHADER_BLUR:
			_blur_color_rect.set_visible(element.get_shader_blur() > 0.0)
			_blur_shader_material.set_shader_parameter("blur_amount", element.get_shader_blur() * 5.0)
		ElementShader.SN_SHADER_BRIGHTNESS:
			if element.get_shader_brightness() > 0.0:
				_brightness_color_rect.set_visible(true)
				_brightness_color_rect.set_color(Color(1.0, 1.0, 1.0, element.get_shader_brightness()))
			elif element.get_shader_brightness() < 0.0:
				_brightness_color_rect.set_visible(true)
				_brightness_color_rect.set_color(Color(0.0, 0.0, 0.0, absf(element.get_shader_brightness())))
			else:
				_brightness_color_rect.set_visible(false)
		ElementShader.SN_SHAKE_AMPLITUDE:
			_color_rect.set_scale(Vector2.ONE * element.get_shader_scale() + _get_scale_for_amplitude())
		ElementShader.SN_SHAKE_AMPLITUDE_COMPENSATION:
			_color_rect.set_pivot_offset(WindowUtilities.get_subviewport_size() * 0.5)
			_color_rect.set_scale(Vector2.ONE * element.get_shader_scale() + _get_scale_for_amplitude())
		ElementShader.SN_SHAKE_FREQUENCY:
			pass
		ElementShader.SN_SHAKE_SEED:
			_noise_utilities.set_seed(element.get_shake_seed())
			_noise_utilities.reset_noise_scroll()
		ElementShader.SN_AUDIO_SOURCE:
			_on_stream_list_updated()
		ElementShader.SN_BEGIN_FREQUENCY:
			_audio_data.set_begin_frequency(element.get_begin_frequency())
		ElementShader.SN_END_FREQUENCY:
			_audio_data.set_end_frequency(element.get_end_frequency())
		ElementShader.SN_MINIMUM_DECIBELS:
			_audio_data.set_minimum_decibels(element.get_minimum_decibels())
		ElementShader.SN_SMOOTHING_TYPE:
			_audio_data.set_smoothing_type(element.get_smoothing_type())
		ElementShader.SN_SMOOTHING_AMOUNT:
			_audio_data.set_smoothing_amount(element.get_smoothing_amount())
		ElementShader.SN_SHADER_ROTATION_REACTION:
			pass
		ElementShader.SN_SHADER_SCALE_REACTION:
			pass
		ElementShader.SN_SHAKE_AMPLITUDE_REACTION:
			_color_rect.set_scale(Vector2.ONE * element.get_shader_scale() + _get_scale_for_amplitude())
		ElementShader.SN_SHAKE_FREQUENCY_REACTION:
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
	
	_element_ui_configurations.set_reaction_visibility(not element.get_audio_source().is_empty())

func _on_sync_element_shake() -> void:
	_noise_utilities.reset_noise_scroll()

func _on_subviewport_size_changed() -> void:
	_color_rect.set_pivot_offset(WindowUtilities.get_subviewport_size() * 0.5)
	
	_color_rect.set_position(_get_fixed_position())
