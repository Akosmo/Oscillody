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
extends Element

const SN_IMAGE_PATH: StringName = &"_image_path"
const SN_IMAGE_X_POSITION: StringName = &"_image_x_position"
const SN_IMAGE_Y_POSITION: StringName = &"_image_y_position"
const SN_IMAGE_ROTATION: StringName = &"_image_rotation"
const SN_IMAGE_SCALE: StringName = &"_image_scale"
const SN_OPACITY: StringName = &"_opacity"
const SN_BLUR: StringName = &"_blur"
const SN_SHAKE_AMPLITUDE: StringName = &"_shake_amplitude"
const SN_SHAKE_FREQUENCY: StringName = &"_shake_frequency"
const SN_SHAKE_SEED: StringName = &"_shake_seed"

var _image_path: String = ""
var _image_x_position: float = 0.5
var _image_y_position: float = 0.5
var _image_rotation: float = 0.0
var _image_scale: float = 1.0
var _opacity: float = 1.0
var _blur: float = 0.0
var _shake_amplitude: float = 0.0
var _shake_frequency: float = 0.0
var _shake_seed: int = 0

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

func set_opacity(p_value: float) -> void:
	_opacity = p_value
	property_changed.emit(SN_OPACITY)

func get_opacity() -> float:
	return _opacity

func set_blur(p_value: float) -> void:
	_blur = p_value
	property_changed.emit(SN_BLUR)

func get_blur() -> float:
	return _blur

func set_shake_amplitude(p_value: float) -> void:
	_shake_amplitude = p_value
	property_changed.emit(SN_SHAKE_AMPLITUDE)

func get_shake_amplitude() -> float:
	return _shake_amplitude

func set_shake_frequency(p_value: float) -> void:
	_shake_frequency = p_value
	property_changed.emit(SN_SHAKE_FREQUENCY)

func get_shake_frequency() -> float:
	return _shake_frequency

func set_shake_seed(p_value: int) -> void:
	_shake_seed = p_value
	property_changed.emit(SN_SHAKE_SEED)

func get_shake_seed() -> int:
	return _shake_seed

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
		SN_OPACITY: _opacity,
		SN_BLUR: _blur,
		SN_SHAKE_AMPLITUDE: _shake_amplitude,
		SN_SHAKE_FREQUENCY: _shake_frequency,
		SN_SHAKE_SEED: _shake_seed
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
		SN_OPACITY: set_opacity.get_method(),
		SN_BLUR: set_blur.get_method(),
		SN_SHAKE_AMPLITUDE: set_shake_amplitude.get_method(),
		SN_SHAKE_FREQUENCY: set_shake_frequency.get_method(),
		SN_SHAKE_SEED: set_shake_seed.get_method()
	}
	
	return _method_dictionary
