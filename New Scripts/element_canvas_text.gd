# Oscillody
# Copyright (C) 2025-present Akosmo

# element_canvas_text.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ElementCanvasText
extends ElementCanvas

var element: ElementText
var _element_ui_configurations: ElementTextUIConfigurations

var _label: Label
var _label_settings: LabelSettings
var _system_font: SystemFont

var _noise_utilities: NoiseUtilities
var _audio_data: RealTimeAudioData

# TEST: Setting reaction controls to non-zero, then removing the audio source, to see if things break.
# TODO: Maybe use an internal scale value based on max resolution: title_control.gd#L89

func _ready() -> void:
	_element_ui_configurations = ElementManager.get_configurations_for_element(element)
	_label = Label.new()
	_label_settings = LabelSettings.new()
	_system_font = SystemFont.new()
	_label_settings.set_font(_system_font)
	_label.set_label_settings(_label_settings)
	add_child(_label)
	
	_noise_utilities = NoiseUtilities.new()
	
	_audio_data = RealTimeAudioData.new()
	
	for property_key: StringName in element.get_properties().keys():
		await _on_element_property_changed(property_key)
	
	if element.property_changed.connect(_on_element_property_changed):
		printerr("Could not connect signal.")
	
	if AudioManager.stream_list_updated.connect(_on_stream_list_updated):
		printerr("Could not connect signal.")
	if SettingsManager.sync_element_shake_requested.connect(_on_sync_element_shake):
		printerr("Could not connect signal.")
	if WindowUtilities.subviewport_size_changed.connect(_on_subviewport_size_changed):
		printerr("Could not connect signal.")

func _process(_delta: float) -> void:
	if not is_equal_approx(element.get_text_rotation_reaction(), 0.0):
		_label.set_rotation_degrees(
			element.get_text_rotation() + \
			(_get_reaction_magnitude(element.get_text_rotation_reaction() * 50.0) - 1.0)
		)
	else:
		_label.set_rotation_degrees(element.get_text_rotation())
	
	if element.get_text_scale_reaction() > 0.0:
		_label.set_scale(
			Vector2.ONE * \
			_get_fixed_scale() * \
			_get_reaction_magnitude(element.get_text_scale_reaction()) + \
			_get_scale_for_amplitude()
		)
	else:
		_label.set_scale(Vector2.ONE * _get_fixed_scale() + _get_scale_for_amplitude())
	
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
			_label.set_position(
				_get_fixed_position() + \
				_noise_utilities.get_noise_vector() * \
				element.get_shake_amplitude() * \
				200.0 * \
				_get_reaction_magnitude(element.get_shake_amplitude_reaction())
			)
			_label.set_scale(Vector2.ONE * _get_fixed_scale() + _get_scale_for_amplitude())
		elif element.get_shake_amplitude_reaction() > 0.0:
			_label.set_position(
				_get_fixed_position() + \
				_noise_utilities.get_noise_vector() * \
				element.get_shake_amplitude_reaction() * \
				200.0 * \
				(_get_reaction_magnitude(element.get_shake_amplitude_reaction()) - 1.0)
			)
			_label.set_scale(Vector2.ONE * _get_fixed_scale() + _get_scale_for_amplitude())
		else:
			_label.set_position(_get_fixed_position())
	else:
		_label.set_position(_get_fixed_position())
		#print(
			#_get_fixed_position(),
			#_label.get_position(),
			#WindowUtilities.get_subviewport_size(),
			#_label.get_pivot_offset()
		#)

func get_element() -> Element:
	return element

func _get_fixed_position() -> Vector2:
	return Vector2(element.get_text_x_position(), element.get_text_y_position()) * \
	Vector2(WindowUtilities.get_subviewport_size()) - _label.get_pivot_offset()

# TEST: Check if this works properly during render.
func _get_fixed_scale() -> Vector2:
	if (
		is_equal_approx(WindowUtilities.get_subviewport_size().x, DisplayServer.screen_get_size().x) and
		is_equal_approx(WindowUtilities.get_subviewport_size().y, DisplayServer.screen_get_size().y)
	):
		return Vector2.ONE
	
	var subviewport_ratio: Vector2 = \
	Vector2(WindowUtilities.get_subviewport_size()) / Vector2(DisplayServer.screen_get_size())
	
	var subviewport_min: float = minf(subviewport_ratio.x, subviewport_ratio.y)
	
	return Vector2(subviewport_min, subviewport_min)

func _fix_transform() -> void:
	await RenderingServer.frame_post_draw
	_label.set_size(Vector2.ZERO)
	_label.set_pivot_offset(_label.get_size() * 0.5)

func _get_scale_for_amplitude() -> Vector2:
	var ret: Vector2 = Vector2.ZERO
	if element.get_shake_amplitude_compensation():
		if element.get_shake_amplitude() > 0.0:
			ret = Vector2.ONE * \
			element.get_shake_amplitude() * \
			_get_reaction_magnitude(element.get_shake_amplitude_reaction()) * \
			400.0 / \
			minf(_label.get_size().x, _label.get_size().y)
		elif element.get_shake_amplitude_reaction() > 0.0:
			ret = Vector2.ONE * \
			element.get_shake_amplitude_reaction() * \
			400.0 / \
			minf(_label.get_size().x, _label.get_size().y)
			ret *= _get_reaction_magnitude(element.get_shake_amplitude_reaction()) - 1.0
	
	return ret

func _get_reaction_magnitude(p_amount: float) -> float:
	return 1.0 + _audio_data.get_current_magnitude() * p_amount

func _on_element_property_changed(p_property: StringName) -> void:
	match p_property:
		ElementText.SN_ELEMENT_NAME:
			set_name(element.get_element_name() + "_" + str(element.get_element_unique_id()))
		ElementText.SN_ELEMENT_TYPE:
			if element.get_element_type() != Element.ElementType.TEXT:
				queue_free()
		ElementText.SN_ELEMENT_LAYER:
			set_layer(element.get_element_layer())
		ElementText.SN_ELEMENT_VISIBILITY:
			set_visible(element.get_element_visibility())
			set_process(element.get_element_visibility())
		ElementText.SN_TEXT:
			_label.set_text(element.get_text())
			await _fix_transform()
		ElementText.SN_TEXT_FONT:
			_system_font.set_font_names(PackedStringArray([element.get_text_font()]))
			await _fix_transform()
		ElementText.SN_TEXT_BOLD:
			if element.get_text_bold():
				_system_font.set_font_weight(700)
			else:
				_system_font.set_font_weight(400)
			await _fix_transform()
		ElementText.SN_TEXT_ITALIC:
			_system_font.set_font_italic(element.get_text_italic())
		ElementText.SN_TEXT_SIZE:
			_label_settings.set_font_size(element.get_text_size())
			await _fix_transform()
		ElementText.SN_TEXT_X_POSITION, ElementText.SN_TEXT_Y_POSITION:
			_label.set_position(Vector2(element.get_text_x_position(), element.get_text_y_position()))
		ElementText.SN_TEXT_ROTATION:
			_label.set_rotation_degrees(element.get_text_rotation())
		ElementText.SN_TEXT_COLOR:
			_label_settings.set_font_color(element.get_text_color())
		ElementText.SN_TEXT_SHADOW_X_POSITION, ElementText.SN_TEXT_SHADOW_Y_POSITION:
			_label_settings.set_shadow_offset(
				Vector2(element.get_text_shadow_x_position(), element.get_text_shadow_y_position())
			)
		ElementText.SN_TEXT_SHADOW_SIZE:
			_label_settings.set_shadow_size(element.get_text_shadow_size())
		ElementText.SN_TEXT_SHADOW_COLOR:
			_label_settings.set_shadow_color(element.get_text_shadow_color())
		ElementText.SN_TEXT_OUTLINE_SIZE:
			_label_settings.set_outline_size(element.get_text_outline_size())
		ElementText.SN_TEXT_OUTLINE_COLOR:
			_label_settings.set_outline_color(element.get_text_outline_color())
		ElementText.SN_TEXT_LINE_SPACING:
			_label_settings.set_line_spacing(element.get_text_line_spacing())
			await _fix_transform()
		ElementText.SN_TEXT_HORIZONTAL_ALIGNMENT:
			_label.set_horizontal_alignment(element.get_text_horizontal_alignment())
			await _fix_transform()
		ElementText.SN_SHAKE_AMPLITUDE:
			_label.set_scale(Vector2.ONE * _get_fixed_scale() + _get_scale_for_amplitude())
		ElementText.SN_SHAKE_AMPLITUDE_COMPENSATION:
			_label.set_pivot_offset(_label.get_size() * 0.5)
			_label.set_scale(Vector2.ONE * _get_fixed_scale() + _get_scale_for_amplitude())
		ElementText.SN_SHAKE_FREQUENCY:
			pass
		ElementText.SN_SHAKE_SEED:
			_noise_utilities.set_seed(element.get_shake_seed())
			_noise_utilities.reset_noise_scroll()
		ElementText.SN_AUDIO_SOURCE:
			_on_stream_list_updated()
		ElementText.SN_BEGIN_FREQUENCY:
			_audio_data.set_begin_frequency(element.get_begin_frequency())
		ElementText.SN_END_FREQUENCY:
			_audio_data.set_end_frequency(element.get_end_frequency())
		ElementText.SN_MINIMUM_DECIBELS:
			_audio_data.set_minimum_decibels(element.get_minimum_decibels())
		ElementText.SN_SMOOTHING_TYPE:
			_audio_data.set_smoothing_type(element.get_smoothing_type())
		ElementText.SN_SMOOTHING_AMOUNT:
			_audio_data.set_smoothing_amount(element.get_smoothing_amount())
		ElementText.SN_TEXT_ROTATION_REACTION:
			pass
		ElementText.SN_TEXT_SCALE_REACTION:
			pass
		ElementText.SN_SHAKE_AMPLITUDE_REACTION:
			_label.set_scale(Vector2.ONE * _get_fixed_scale() + _get_scale_for_amplitude())
		ElementText.SN_SHAKE_FREQUENCY_REACTION:
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
	#_label.set_pivot_offset(WindowUtilities.get_subviewport_size() * 0.5)
	
	_label.set_position(_get_fixed_position())
