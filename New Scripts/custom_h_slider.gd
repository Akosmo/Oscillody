# Oscillody
# Copyright (C) 2025-present Akosmo

# custom_h_slider.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name CustomHSlider
extends HBoxContainer

signal value_changed(p_value: float)

@export var _min_value: float = 0.0
@export var _max_value: float = 100.0
@export var _step: float = 1.0
@export var _value: float = 0.0
@export var _rounded: bool = false

@onready var _h_slider: HSlider = $HSlider
@onready var _label: Label = $Label

func _ready() -> void:
	if configure_slider(_min_value, _max_value, _step, _rounded):
		printerr("Wrong slider configuration.")
	if set_value(_value):
		printerr("Wrong value given the slider's configurations.")
	
	_set_value_to_label()
	
	if _h_slider.value_changed.connect(_on_value_changed):
		printerr("Could not connect \"_on_value_changed\".")

func configure_slider(p_min: float, p_max: float, p_step: float, p_rounded: bool) -> Error:
	if p_min > p_max or (p_rounded and fmod(p_step, 1.0) != 0):
		return FAILED
	
	_h_slider.set_min(_min_value)
	_h_slider.set_max(_max_value)
	_h_slider.set_step(_step)
	_h_slider.set_use_rounded_values(_rounded)
	
	return OK

func set_value(p_value: float) -> Error:
	if (
		p_value < _min_value or
		p_value > _max_value or
		fmod(p_value, _step) != 0 or
		(_rounded and fmod(p_value, _step))
	):
		return FAILED
	
	_h_slider.set_value(_value)
	
	return OK

func _on_value_changed(p_value: float) -> void:
	_set_value_to_label()
	value_changed.emit(p_value)

func _set_value_to_label() -> void:
	if _h_slider.rounded:
		_label.set_text(str(_value).rstrip(".0"))
	else:
		_label.set_text(str(_value))
