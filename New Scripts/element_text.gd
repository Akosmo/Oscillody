# Oscillody
# Copyright (C) 2025-present Akosmo

# element_text.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ElementText
extends ElementShakable

#enum HorizontalAlignment {
	#LEFT,
	#CENTER,
	#RIGHT
#}

const HORIZONTAL_ALIGNMENTS: Array[StringName] = [
	&"(Text)_Left",
	&"(Text)_Center",
	&"(Text)_Right"
]

const SN_TEXT: StringName = &"(Text)_Text"
const SN_TEXT_FONT: StringName = &"(Text)_Font"
const SN_TEXT_BOLD: StringName = &"(Text)_Bold"
const SN_TEXT_ITALIC: StringName = &"(Text)_Italic"
const SN_TEXT_SIZE: StringName = &"(Text)_Size"
const SN_TEXT_X_POSITION: StringName = &"(Text)_X_Position"
const SN_TEXT_Y_POSITION: StringName = &"(Text)_Y_Position"
const SN_TEXT_ROTATION: StringName = &"(Text)_Rotation"
const SN_TEXT_COLOR: StringName = &"(Text)_Color"
const SN_TEXT_SHADOW_X_POSITION: StringName = &"(Text)_Shadow_X_Position"
const SN_TEXT_SHADOW_Y_POSITION: StringName = &"(Text)_Shadow_Y_Position"
const SN_TEXT_SHADOW_SIZE: StringName = &"(Text)_Shadow_Size"
const SN_TEXT_SHADOW_COLOR: StringName = &"(Text)_Shadow_Color"
const SN_TEXT_OUTLINE_SIZE: StringName = &"(Text)_Outline_Size"
const SN_TEXT_OUTLINE_COLOR: StringName = &"(Text)_Outline_Color"
const SN_TEXT_LINE_SPACING: StringName = &"(Text)_Line_Spacing"
const SN_TEXT_HORIZONTAL_ALIGNMENT: StringName = &"(Text)_Horizontal_Alignment"
const SN_TEXT_ROTATION_REACTION: StringName = &"(Text)_Rotation_Reaction"
const SN_TEXT_SCALE_REACTION: StringName = &"(Text)_Scale_Reaction"

var _text: String = ""
var _text_font: String = "Calibri" # TODO: Change?
var _text_bold: bool = false
var _text_italic: bool = false
var _text_size: int = 32
var _text_x_position: float = 0.5
var _text_y_position: float = 0.5
var _text_rotation: float = 0.0
var _text_color: Color = Color.WHITE
var _text_shadow_x_position: int = 0
var _text_shadow_y_position: int = 0
var _text_shadow_size: int = 0
var _text_shadow_color: Color = Color(0.0, 0.0, 0.0, 0.0)
var _text_outline_size: int = 0
var _text_outline_color: Color = Color.GRAY
var _text_line_spacing: float = 3.0
var _text_horizontal_alignment: HorizontalAlignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
var _text_rotation_reaction: float = 0.0
var _text_scale_reaction: float = 0.0

func set_text(p_value: String) -> void:
	_text = p_value
	property_changed.emit(SN_TEXT)

func get_text() -> String:
	return _text

func set_text_font(p_value: String) -> void:
	_text_font = p_value
	property_changed.emit(SN_TEXT_FONT)

func get_text_font() -> String:
	return _text_font

func set_text_bold(p_value: bool) -> void:
	_text_bold = p_value
	property_changed.emit(SN_TEXT_BOLD)

func get_text_bold() -> bool:
	return _text_bold

func set_text_italic(p_value: bool) -> void:
	_text_italic = p_value
	property_changed.emit(SN_TEXT_ITALIC)

func get_text_italic() -> bool:
	return _text_italic

func set_text_size(p_value: int) -> void:
	_text_size = p_value
	property_changed.emit(SN_TEXT_SIZE)

func get_text_size() -> int:
	return _text_size

func set_text_x_position(p_value: float) -> void:
	_text_x_position = p_value
	property_changed.emit(SN_TEXT_X_POSITION)

func get_text_x_position() -> float:
	return _text_x_position

func set_text_y_position(p_value: float) -> void:
	_text_y_position = p_value
	property_changed.emit(SN_TEXT_Y_POSITION)

func get_text_y_position() -> float:
	return _text_y_position

func set_text_rotation(p_value: float) -> void:
	_text_rotation = p_value
	property_changed.emit(SN_TEXT_ROTATION)

func get_text_rotation() -> float:
	return _text_rotation

func set_text_color(p_value: Color) -> void:
	_text_color = p_value
	property_changed.emit(SN_TEXT_COLOR)

func get_text_color() -> Color:
	return _text_color

func set_text_shadow_x_position(p_value: int) -> void:
	_text_shadow_x_position = p_value
	property_changed.emit(SN_TEXT_SHADOW_X_POSITION)

func get_text_shadow_x_position() -> int:
	return _text_shadow_x_position

func set_text_shadow_y_position(p_value: int) -> void:
	_text_shadow_y_position = p_value
	property_changed.emit(SN_TEXT_SHADOW_Y_POSITION)

func get_text_shadow_y_position() -> int:
	return _text_shadow_y_position

func set_text_shadow_size(p_value: int) -> void:
	_text_shadow_size = p_value
	property_changed.emit(SN_TEXT_SHADOW_SIZE)

func get_text_shadow_size() -> int:
	return _text_shadow_size

func set_text_shadow_color(p_value: Color) -> void:
	_text_shadow_color = p_value
	property_changed.emit(SN_TEXT_SHADOW_COLOR)

func get_text_shadow_color() -> Color:
	return _text_shadow_color

func set_text_outline_size(p_value: int) -> void:
	_text_outline_size = p_value
	property_changed.emit(SN_TEXT_OUTLINE_SIZE)

func get_text_outline_size() -> int:
	return _text_outline_size

func set_text_outline_color(p_value: Color) -> void:
	_text_outline_color = p_value
	property_changed.emit(SN_TEXT_OUTLINE_COLOR)

func get_text_outline_color() -> Color:
	return _text_outline_color

func set_text_line_spacing(p_value: float) -> void:
	_text_line_spacing = p_value
	property_changed.emit(SN_TEXT_LINE_SPACING)

func get_text_line_spacing() -> float:
	return _text_line_spacing

func set_text_horizontal_alignment(p_value: HorizontalAlignment) -> void:
	_text_horizontal_alignment = p_value
	property_changed.emit(SN_TEXT_HORIZONTAL_ALIGNMENT)

func get_text_horizontal_alignment() -> HorizontalAlignment:
	return _text_horizontal_alignment

func set_text_rotation_reaction(p_value: float) -> void:
	_text_rotation_reaction = p_value
	property_changed.emit(SN_TEXT_ROTATION_REACTION)

func get_text_rotation_reaction() -> float:
	return _text_rotation_reaction

func set_text_scale_reaction(p_value: float) -> void:
	_text_scale_reaction = p_value
	property_changed.emit(SN_TEXT_SCALE_REACTION)

func get_text_scale_reaction() -> float:
	return _text_scale_reaction

func get_properties() -> Dictionary[StringName, Variant]:
	var _property_dictionary: Dictionary[StringName, Variant] = {
		SN_ELEMENT_NAME: _element_name,
		SN_ELEMENT_TYPE: _element_type,
		SN_ELEMENT_LAYER: _element_layer,
		SN_ELEMENT_VISIBILITY: _element_visibility,
		SN_TEXT: _text,
		SN_TEXT_FONT: _text_font,
		SN_TEXT_BOLD: _text_bold,
		SN_TEXT_ITALIC: _text_italic,
		SN_TEXT_SIZE: _text_size,
		SN_TEXT_X_POSITION: _text_x_position,
		SN_TEXT_Y_POSITION: _text_y_position,
		SN_TEXT_ROTATION: _text_rotation,
		SN_TEXT_COLOR: _text_color,
		SN_TEXT_SHADOW_X_POSITION: _text_shadow_x_position,
		SN_TEXT_SHADOW_Y_POSITION: _text_shadow_y_position,
		SN_TEXT_SHADOW_SIZE: _text_shadow_size,
		SN_TEXT_SHADOW_COLOR: _text_shadow_color,
		SN_TEXT_OUTLINE_SIZE: _text_outline_size,
		SN_TEXT_OUTLINE_COLOR: _text_outline_color,
		SN_TEXT_LINE_SPACING: _text_line_spacing,
		SN_TEXT_HORIZONTAL_ALIGNMENT: _text_horizontal_alignment,
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
		SN_TEXT_ROTATION_REACTION: _text_rotation_reaction,
		SN_TEXT_SCALE_REACTION: _text_scale_reaction,
		SN_SHAKE_AMPLITUDE_REACTION: _shake_amplitude_reaction,
		SN_SHAKE_FREQUENCY_REACTION: _shake_frequency_reaction
	}
	
	return _property_dictionary

func get_setters() -> Dictionary[StringName, StringName]:
	var _setter_dictionary: Dictionary[StringName, StringName] = {
		SN_ELEMENT_NAME: set_element_name.get_method(),
		SN_ELEMENT_TYPE: set_element_type.get_method(),
		SN_ELEMENT_LAYER: set_element_layer.get_method(),
		SN_ELEMENT_VISIBILITY: set_element_visibility.get_method(),
		SN_TEXT: set_text.get_method(),
		SN_TEXT_FONT: set_text_font.get_method(),
		SN_TEXT_BOLD: set_text_bold.get_method(),
		SN_TEXT_ITALIC: set_text_italic.get_method(),
		SN_TEXT_SIZE: set_text_size.get_method(),
		SN_TEXT_X_POSITION: set_text_x_position.get_method(),
		SN_TEXT_Y_POSITION: set_text_y_position.get_method(),
		SN_TEXT_ROTATION: set_text_rotation.get_method(),
		SN_TEXT_COLOR: set_text_color.get_method(),
		SN_TEXT_SHADOW_X_POSITION: set_text_shadow_x_position.get_method(),
		SN_TEXT_SHADOW_Y_POSITION: set_text_shadow_y_position.get_method(),
		SN_TEXT_SHADOW_SIZE: set_text_shadow_size.get_method(),
		SN_TEXT_SHADOW_COLOR: set_text_shadow_color.get_method(),
		SN_TEXT_OUTLINE_SIZE: set_text_outline_size.get_method(),
		SN_TEXT_OUTLINE_COLOR: set_text_outline_color.get_method(),
		SN_TEXT_LINE_SPACING: set_text_line_spacing.get_method(),
		SN_TEXT_HORIZONTAL_ALIGNMENT: set_text_horizontal_alignment.get_method(),
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
		SN_TEXT_ROTATION_REACTION: set_text_rotation_reaction.get_method(),
		SN_TEXT_SCALE_REACTION: set_text_scale_reaction.get_method(),
		SN_SHAKE_AMPLITUDE_REACTION: set_shake_amplitude_reaction.get_method(),
		SN_SHAKE_FREQUENCY_REACTION: set_shake_frequency_reaction.get_method()
	}
	
	return _setter_dictionary
