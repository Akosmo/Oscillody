# Oscillody
# Copyright (C) 2025-present Akosmo

# element_canvas_image.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ElementCanvasImage
extends ElementCanvas

var element: ElementImage
var _element_ui_configurations: ElementImageUIConfigurations

var _texture_rect: TextureRect
var _color_rect: ColorRect
var _shader_material: ShaderMaterial

var _native_image: Image
var _image_texture: ImageTexture

var _noise_utilities: NoiseUtilities
var _audio_data: RealTimeAudioData
#var _spectrum_analyzer_effect: AudioEffectSpectrumAnalyzer

# TEST: Setting reaction controls to non-zero, then removing the audio source, to see if things break.

func _ready() -> void:
	set_name(element.get_element_name() + "_" + str(element.get_unique_id()))
	set_layer(element.get_layer())
	
	_element_ui_configurations = preload("uid://d22vhxv5sqx2t")
	_element_ui_configurations.set_reaction_visibility(not element.get_audio_source().is_empty())
	
	_texture_rect = TextureRect.new()
	_texture_rect.set_expand_mode(TextureRect.EXPAND_IGNORE_SIZE)
	_texture_rect.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
	_texture_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_texture_rect)
	_color_rect = ColorRect.new()
	_color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_shader_material = ShaderMaterial.new()
	_shader_material.set_shader(preload("uid://nddyss8tny8y"))
	_color_rect.set_material(_shader_material)
	add_child(_color_rect)
	
	_noise_utilities = NoiseUtilities.new()
	_noise_utilities.set_seed(element.get_shake_seed())
	_noise_utilities.reset_noise_scroll()
	
	_audio_data = RealTimeAudioData.new()
	if not element.get_audio_source().is_empty():
		var spectrum_analyzer_effect_instance: AudioEffectSpectrumAnalyzerInstance
		spectrum_analyzer_effect_instance = AudioServer.get_bus_effect_instance(
			AudioServer.get_bus_index(element.get_audio_source()),
			0,
			0
		)
		_audio_data.set_spectrum_analyzer_effect_instance(spectrum_analyzer_effect_instance)
	else:
		_audio_data.set_spectrum_analyzer_effect_instance(null)
	_audio_data.set_begin_frequency(element.get_begin_frequency())
	_audio_data.set_end_frequency(element.get_end_frequency())
	_audio_data.set_minimum_decibels(element.get_minimum_decibels())
	_audio_data.set_smoothing_type(element.get_smoothing_type())
	_audio_data.set_smoothing_amount(element.get_smoothing_amount())
	
	if element.property_changed.connect(_on_element_property_changed):
		printerr("Could not connect signal.")
	
	if AudioManager.stream_list_updated.connect(_on_stream_list_updated):
		printerr("Could not connect signal.")
	if SettingsManager.sync_element_shake_requested.connect(_on_sync_element_shake):
		printerr("Could not connect signal.")
	if WindowUtilities.subviewport_size_changed.connect(_on_subviewport_size_changed):
		printerr("Could not connect signal.")

func _process(_delta: float) -> void:
	if not is_equal_approx(element.get_rotation_reaction(), 0.0):
		_texture_rect.set_rotation_degrees(
			element.get_image_rotation() + \
			(_get_reaction_magnitude(element.get_rotation_reaction() * 50.0) - 1.0)
		)
	else:
		_texture_rect.set_rotation_degrees(element.get_image_rotation())
	
	if element.get_scale_reaction() > 0.0:
		#_texture_rect.set_pivot_offset(WindowUtilities.get_subviewport_size() * 0.5)
		_texture_rect.set_scale(
			Vector2.ONE * \
			element.get_image_scale() * \
			_get_reaction_magnitude(element.get_scale_reaction()) + \
			_get_scale_for_amplitude()
		)
	else:
		_texture_rect.set_scale(Vector2.ONE * element.get_image_scale() + _get_scale_for_amplitude())
	
	if element.get_shake_frequency() > 0.0:
		_noise_utilities.increment_noise_scroll(
			element.get_shake_frequency() * \
			100.0 * \
			_get_reaction_magnitude(element.get_shake_frequency_reaction() * 10.0)
		)
	elif element.get_shake_frequency_reaction() > 0.0:
		_noise_utilities.increment_noise_scroll(
			#element.get_shake_frequency_reaction() * \
			100.0 * \
			(_get_reaction_magnitude(element.get_shake_frequency_reaction()) - 1.0)
		)
	if element.get_shake_frequency() > 0.0 or element.get_shake_frequency_reaction() > 0.0:
		if element.get_shake_amplitude() > 0.0:
			_texture_rect.set_position(
				_get_fixed_position() + \
				_noise_utilities.get_noise_vector() * \
				element.get_shake_amplitude() * \
				200.0 * \
				_get_reaction_magnitude(element.get_shake_amplitude_reaction())
				#(_get_reaction_magnitude(element.get_shake_amplitude_reaction()) - 1.0)
			)
			_texture_rect.set_scale(Vector2.ONE * element.get_image_scale() + _get_scale_for_amplitude())
		elif element.get_shake_amplitude_reaction() > 0.0:
			_texture_rect.set_position(
				_get_fixed_position() + \
				_noise_utilities.get_noise_vector() * \
				element.get_shake_amplitude_reaction() * \
				200.0 * \
				(_get_reaction_magnitude(element.get_shake_amplitude_reaction()) - 1.0)
			)
			_texture_rect.set_scale(Vector2.ONE * element.get_image_scale() + _get_scale_for_amplitude())
		else:
			_texture_rect.set_position(_get_fixed_position())
	else:
		_texture_rect.set_position(_get_fixed_position())

func get_element() -> Element:
	return element

func _get_fixed_position() -> Vector2:
	return Vector2(element.get_image_x_position(), element.get_image_y_position()) * \
	Vector2(WindowUtilities.get_subviewport_size()) - _texture_rect.get_pivot_offset()

func _get_scale_for_amplitude() -> Vector2:
	var ret: Vector2 = Vector2.ZERO
	if element.get_shake_amplitude_compensation():
		if element.get_shake_amplitude() > 0.0:
			ret = Vector2.ONE * \
			element.get_shake_amplitude() * \
			_get_reaction_magnitude(element.get_shake_amplitude_reaction()) * \
			400.0 / \
			minf(_texture_rect.get_size().x, _texture_rect.get_size().y)
		elif element.get_shake_amplitude_reaction() > 0.0:
			ret = Vector2.ONE * \
			element.get_shake_amplitude_reaction() * \
			400.0 / \
			minf(_texture_rect.get_size().x, _texture_rect.get_size().y)
			ret *= _get_reaction_magnitude(element.get_shake_amplitude_reaction()) - 1.0
	
	return ret

func _get_reaction_magnitude(p_amount: float) -> float:
	return 1.0 + _audio_data.get_current_magnitude() * p_amount

func _on_element_property_changed(p_property: StringName) -> void:
	match p_property:
		ElementImage.SN_NAME:
			set_name(element.get_element_name() + "_" + str(element.get_unique_id()))
		ElementImage.SN_TYPE:
			queue_free()
		ElementImage.SN_LAYER:
			set_layer(element.get_layer())
		ElementImage.SN_VISIBILITY:
			set_visible(element.get_visibility())
			set_process(element.get_visibility())
		ElementImage.SN_IMAGE_PATH:
			if not element.get_image_path().is_empty():
				_native_image = Image.load_from_file(element.get_image_path())
				_image_texture = ImageTexture.create_from_image(_native_image)
				_texture_rect.set_texture(_image_texture)
				_texture_rect.set_pivot_offset(WindowUtilities.get_subviewport_size() * 0.5)
			else:
				_texture_rect.set_texture(null)
			
			_texture_rect.set_position(_get_fixed_position())
		ElementImage.SN_IMAGE_X_POSITION, ElementImage.SN_IMAGE_Y_POSITION:
			#_texture_rect.set_position(_get_fixed_position())
			pass
		ElementImage.SN_IMAGE_ROTATION:
			#_texture_rect.set_pivot_offset(WindowUtilities.get_subviewport_size() * 0.5)
			#_texture_rect.set_rotation_degrees(element.get_image_rotation())
			pass
		ElementImage.SN_IMAGE_SCALE:
			#_texture_rect.set_pivot_offset(WindowUtilities.get_subviewport_size() * 0.5)
			#_texture_rect.set_scale(Vector2.ONE * element.get_image_scale() + _get_scale_for_amplitude())
			pass
		ElementImage.SN_IMAGE_COLOR:
			_texture_rect.set_self_modulate(element.get_image_color())
		ElementImage.SN_BLUR:
			_shader_material.set_shader_parameter("blur_amount", element.get_blur() * 5.0)
		ElementImage.SN_SHAKE_AMPLITUDE:
			_texture_rect.set_scale(Vector2.ONE * element.get_image_scale() + _get_scale_for_amplitude())
		ElementImage.SN_SHAKE_AMPLITUDE_COMPENSATION:
			_texture_rect.set_pivot_offset(WindowUtilities.get_subviewport_size() * 0.5)
			_texture_rect.set_scale(Vector2.ONE * element.get_image_scale() + _get_scale_for_amplitude())
		ElementImage.SN_SHAKE_FREQUENCY:
			pass
		ElementImage.SN_SHAKE_SEED:
			_noise_utilities.set_seed(element.get_shake_seed())
		ElementImage.SN_AUDIO_SOURCE:
			_on_stream_list_updated()
		ElementImage.SN_BEGIN_FREQUENCY:
			_audio_data.set_begin_frequency(element.get_begin_frequency())
		ElementImage.SN_END_FREQUENCY:
			_audio_data.set_end_frequency(element.get_end_frequency())
		ElementImage.SN_MINIMUM_DECIBELS:
			_audio_data.set_minimum_decibels(element.get_minimum_decibels())
		ElementImage.SN_SMOOTHING_TYPE:
			_audio_data.set_smoothing_type(element.get_smoothing_type())
		ElementImage.SN_SMOOTHING_AMOUNT:
			_audio_data.set_smoothing_amount(element.get_smoothing_amount())
		#ElementImage.SN_POSITION_REACTION:
			#pass
		ElementImage.SN_ROTATION_REACTION:
			pass
		ElementImage.SN_SCALE_REACTION:
			pass
		ElementImage.SN_SHAKE_AMPLITUDE_REACTION:
			_texture_rect.set_scale(Vector2.ONE * element.get_image_scale() + _get_scale_for_amplitude())
		ElementImage.SN_SHAKE_FREQUENCY_REACTION:
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
	_texture_rect.set_pivot_offset(WindowUtilities.get_subviewport_size() * 0.5)
	
	_texture_rect.set_position(_get_fixed_position())
