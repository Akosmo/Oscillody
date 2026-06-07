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

@export var min_value: float = 0.0
@export var max_value: float = 100.0
@export var step: float = 1.0
@export var value: float = 0.0
@export var rounded: bool = false

@onready var h_slider: HSlider = $HSlider
@onready var label: Label = $Label

func _ready() -> void:
	var err_config: Error = configure_slider(min_value, max_value, step, rounded)
	if err_config:
		printerr("Wrong slider configuration.")
	var err_init_val: Error = set_value(value)
	if err_init_val:
		printerr("Wrong value given the slider's configurations.")
	
	_set_value_to_label()
	
	var err: Error = h_slider.connect("value_changed", _on_value_changed)
	if err:
		printerr("Could not connect \"_on_value_changed\".")

func configure_slider(p_min: float, p_max: float, p_step: float, p_rounded: bool) -> Error:
	if p_min > p_max or (p_rounded and fmod(p_step, 1.0) != 0):
		return FAILED
	
	h_slider.set_min(min_value)
	h_slider.set_max(max_value)
	h_slider.set_step(step)
	h_slider.set_use_rounded_values(rounded)
	
	return OK

func set_value(p_value: float) -> Error:
	if (
		p_value < min_value or
		p_value > max_value or
		fmod(p_value, step) != 0 or
		(rounded and fmod(p_value, step))
	):
		return FAILED
	
	h_slider.set_value(value)
	
	return OK

func _on_value_changed(p_value: float) -> void:
	_set_value_to_label()
	value_changed.emit(p_value)

func _set_value_to_label() -> void:
	if h_slider.rounded:
		label.set_text(str(value).rstrip(".0"))
	else:
		label.set_text(str(value))
