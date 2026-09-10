# Oscillody
# Copyright (C) 2025-present Akosmo

# element_image.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ElementImage
extends ElementShakable

const SN_IMAGE_PATH: StringName = &"_image_path"
const SN_IMAGE_X_POSITION: StringName = &"_image_x_position"
const SN_IMAGE_Y_POSITION: StringName = &"_image_y_position"
const SN_IMAGE_ROTATION: StringName = &"_image_rotation"
const SN_IMAGE_SCALE: StringName = &"_image_scale"
const SN_IMAGE_COLOR: StringName = &"_image_color"
const SN_BLUR: StringName = &"_blur"
#const SN_POSITION_REACTION: StringName = &"_position_reaction"
const SN_ROTATION_REACTION: StringName = &"_rotation_reaction"
const SN_SCALE_REACTION: StringName = &"_scale_reaction"

var _image_path: String = ""
var _image_x_position: float = 0.5
var _image_y_position: float = 0.5
var _image_rotation: float = 0.0
var _image_scale: float = 1.0
var _image_color: Color = Color.WHITE
var _blur: float = 0.0
#var _position_reaction: float = 0.0
var _rotation_reaction: float = 0.0
var _scale_reaction: float = 0.0

func set_image_path(p_value: String) -> void:
	_image_path = p_value
	property_changed.emit(SN_IMAGE_PATH)

func get_image_path() -> String:
	return _image_path

func set_image_x_position(p_value: float) -> void:
	_image_x_position = p_value
	property_changed.emit(SN_IMAGE_X_POSITION)

func get_image_x_position() -> float:
	return _image_x_position

func set_image_y_position(p_value: float) -> void:
	_image_y_position = p_value
	property_changed.emit(SN_IMAGE_Y_POSITION)

func get_image_y_position() -> float:
	return _image_y_position

func set_image_rotation(p_value: float) -> void:
	_image_rotation = p_value
	property_changed.emit(SN_IMAGE_ROTATION)

func get_image_rotation() -> float:
	return _image_rotation

func set_image_scale(p_value: float) -> void:
	_image_scale = p_value
	property_changed.emit(SN_IMAGE_SCALE)

func get_image_scale() -> float:
	return _image_scale

func set_image_color(p_value: Color) -> void:
	_image_color = p_value
	property_changed.emit(SN_IMAGE_COLOR)

func get_image_color() -> Color:
	return _image_color

func set_blur(p_value: float) -> void:
	_blur = p_value
	property_changed.emit(SN_BLUR)

func get_blur() -> float:
	return _blur

#func set_position_reaction(p_value: float) -> void:
	#_position_reaction = p_value
	#property_changed.emit(SN_POSITION_REACTION)
#
#func get_position_reaction() -> float:
	#return _position_reaction

func set_rotation_reaction(p_value: float) -> void:
	_rotation_reaction = p_value
	property_changed.emit(SN_ROTATION_REACTION)

func get_rotation_reaction() -> float:
	return _rotation_reaction

func set_scale_reaction(p_value: float) -> void:
	_scale_reaction = p_value
	property_changed.emit(SN_SCALE_REACTION)

func get_scale_reaction() -> float:
	return _scale_reaction

func get_property_dictionary() -> Dictionary[StringName, Variant]:
	var _property_dictionary: Dictionary[StringName, Variant] = {
		SN_NAME: _element_name,
		SN_TYPE: _type,
		SN_LAYER: _layer,
		SN_VISIBILITY: _visibility,
		SN_IMAGE_PATH: _image_path,
		SN_IMAGE_X_POSITION: _image_x_position,
		SN_IMAGE_Y_POSITION: _image_y_position,
		SN_IMAGE_ROTATION: _image_rotation,
		SN_IMAGE_SCALE: _image_scale,
		SN_IMAGE_COLOR: _image_color,
		SN_BLUR: _blur,
		SN_SHAKE_AMPLITUDE: _shake_amplitude,
		SN_SHAKE_AMPLITUDE_COMPENSATION: _shake_amplitude_compensation,
		SN_SHAKE_FREQUENCY: _shake_frequency,
		SN_SHAKE_SEED: _shake_seed,
		SN_AUDIO_SOURCE: _audio_source,
		SN_BEGIN_FREQUENCY: _begin_frequency,
		SN_END_FREQUENCY: _end_frequency,
		SN_MINIMUM_DECIBELS: _minimum_decibels,
		SN_SMOOTHING_TYPE: _smoothing_type,
		SN_SMOOTHING_AMOUNT: _smoothing_amount,
		#SN_POSITION_REACTION: _position_reaction,
		SN_ROTATION_REACTION: _rotation_reaction,
		SN_SCALE_REACTION: _scale_reaction,
		SN_SHAKE_AMPLITUDE_REACTION: _shake_amplitude_reaction,
		SN_SHAKE_FREQUENCY_REACTION: _shake_frequency_reaction
	}
	
	return _property_dictionary

func get_method_dictionary() -> Dictionary[StringName, StringName]:
	var _method_dictionary: Dictionary[StringName, StringName] = {
		SN_NAME: set_element_name.get_method(),
		SN_TYPE: set_type.get_method(),
		SN_LAYER: set_layer.get_method(),
		SN_VISIBILITY: set_visibility.get_method(),
		SN_IMAGE_PATH: set_image_path.get_method(),
		SN_IMAGE_X_POSITION: set_image_x_position.get_method(),
		SN_IMAGE_Y_POSITION: set_image_y_position.get_method(),
		SN_IMAGE_ROTATION: set_image_rotation.get_method(),
		SN_IMAGE_SCALE: set_image_scale.get_method(),
		SN_IMAGE_COLOR: set_image_color.get_method(),
		SN_BLUR: set_blur.get_method(),
		SN_SHAKE_AMPLITUDE: set_shake_amplitude.get_method(),
		SN_SHAKE_AMPLITUDE_COMPENSATION: set_shake_amplitude_compensation.get_method(),
		SN_SHAKE_FREQUENCY: set_shake_frequency.get_method(),
		SN_SHAKE_SEED: set_shake_seed.get_method(),
		SN_AUDIO_SOURCE: set_audio_source.get_method(),
		SN_BEGIN_FREQUENCY: set_begin_frequency.get_method(),
		SN_END_FREQUENCY: set_end_frequency.get_method(),
		SN_MINIMUM_DECIBELS: set_minimum_decibels.get_method(),
		SN_SMOOTHING_TYPE: set_smoothing_type.get_method(),
		SN_SMOOTHING_AMOUNT: set_smoothing_amount.get_method(),
		#SN_POSITION_REACTION: set_position_reaction.get_method(),
		SN_ROTATION_REACTION: set_rotation_reaction.get_method(),
		SN_SCALE_REACTION: set_scale_reaction.get_method(),
		SN_SHAKE_AMPLITUDE_REACTION: set_shake_amplitude_reaction.get_method(),
		SN_SHAKE_FREQUENCY_REACTION: set_shake_frequency_reaction.get_method()
	}
	
	return _method_dictionary
