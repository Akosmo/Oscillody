# Oscillody
# Copyright (C) 2025-present Akosmo

# element_property_container.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

# TODO: Make members private if not used outside the class. And document this class.
# TODO: Make `is_for_element()` that checks all element related variables.

class_name PropertyContainer
extends PanelContainer

#signal change_element_button(new_name: String)

var element_manager: ElementManager
var element_uid: int = -1
var property_key: StringName
var _reset_value: Variant

@onready var _value_label: Label = $MarginContainer/HBoxContainer/Label
@onready var _reset_button: Button = $MarginContainer/HBoxContainer/Button

@onready var _button: Button = $MarginContainer/HBoxContainer/HBoxContainer/Button
@onready var _check_button: CheckButton = $MarginContainer/HBoxContainer/HBoxContainer/CheckButton
@onready var _color_picker_button: ColorPickerButton = \
$MarginContainer/HBoxContainer/HBoxContainer/ColorPickerButton
@onready var _line_edit: LineEdit = $MarginContainer/HBoxContainer/HBoxContainer/LineEdit
@onready var _spin_box: SpinBox = $MarginContainer/HBoxContainer/HBoxContainer/SpinBox
@onready var _custom_h_slider: CustomHSlider = $MarginContainer/HBoxContainer/HBoxContainer/CustomHSlider
@onready var _option_button: OptionButton = $MarginContainer/HBoxContainer/HBoxContainer/OptionButton
@onready var _text_edit: TextEdit = $MarginContainer/HBoxContainer/HBoxContainer/TextEdit

# TODO: Split inside sections into different functions,
# and also configure slider (and spinbox) before setting value.
func _ready() -> void:
	if _connect_all_signals():
		printerr("Could not connect all property signals.")
		return
	
	if _is_for_element() and element_manager.property_exists(element_uid, property_key):
		_value_label.set_text(String(property_key))
		
		if property_key == element_manager.TYPE:
			_option_button.add_item("Analyzer")
			_option_button.add_item("Gradient")
			_option_button.add_item("Image")
			_option_button.add_item("Post-Processing")
			_option_button.add_item("Shader")
			_option_button.add_item("Shape")
			_option_button.add_item("Solid Color")
			_option_button.add_item("Text")
		
		_set_property_value_to_control(element_manager.get_element_property(element_uid, property_key))

func _connect_all_signals() -> Error:
	if _reset_button.pressed.connect(_on_reset_pressed):
		return ERR_INVALID_PARAMETER
	
	if _button.pressed.connect(_on_button_pressed):
		return ERR_INVALID_PARAMETER
	if _check_button.toggled.connect(_on_check_toggled):
		return ERR_INVALID_PARAMETER
	if _color_picker_button.color_changed.connect(_on_color_changed):
		return ERR_INVALID_PARAMETER
	if _line_edit.text_changed.connect(_on_line_edit_text_changed):
		return ERR_INVALID_PARAMETER
	if _spin_box.value_changed.connect(_on_spin_box_value_changed):
		return ERR_INVALID_PARAMETER
	if _custom_h_slider.value_changed.connect(_on_slider_value_changed):
		return ERR_INVALID_PARAMETER
	if _option_button.item_selected.connect(_on_option_item_selected):
		return ERR_INVALID_PARAMETER
	if _text_edit.text_changed.connect(_on_text_edit_text_changed):
		return ERR_INVALID_PARAMETER
	
	return OK

func _is_for_element() -> bool:
	if element_manager != null and element_uid >= 0 and not property_key.is_empty():
		return true
	else:
		return false

func _set_value_to_property(p_value: Variant) -> void:
	if _is_for_element() and element_manager.property_exists(element_uid, property_key):
		if element_manager.set_element_property(element_uid, property_key, p_value):
			printerr(
				"Could not set {property} to {value} in {UID}.".format(
					{"property": property_key,
					"value": p_value,
					"UID": element_uid
					}
				)
			)

func _set_property_value_to_control(p_value: Variant) -> void:
	match element_manager.get_control_node_for_property(element_uid, property_key):
		element_manager.ControlNode.BUTTON:
			_button.show()
		element_manager.ControlNode.CHECK_BUTTON:
			_check_button.show()
			@warning_ignore("unsafe_cast")
			_check_button.set_pressed(p_value as bool)
		element_manager.ControlNode.COLOR_PICKER_BUTTON:
			_color_picker_button.show()
			@warning_ignore("unsafe_cast")
			_color_picker_button.set_pick_color(p_value as Color)
		element_manager.ControlNode.LINE_EDIT:
			_line_edit.show()
			_line_edit.set_text(str(p_value))
		element_manager.ControlNode.NUMERICAL:
			# TODO: Check if user prefer sliders. Have an instance of a Settings class.
			_spin_box.show()
			@warning_ignore("unsafe_call_argument")
			_spin_box.set_value(p_value)
			@warning_ignore("unsafe_call_argument")
			if _custom_h_slider.set_value(p_value):
				printerr("Wrong value given the slider's configurations.")
		element_manager.ControlNode.OPTION_BUTTON:
			_option_button.show()
			@warning_ignore("unsafe_cast")
			_option_button.select(p_value as int)
		element_manager.ControlNode.TEXT_EDIT:
			_text_edit.show()
			_text_edit.set_text(str(p_value))

func _on_reset_pressed() -> void:
	pass

func _on_button_pressed() -> void:
	pass

func _on_check_toggled(p_toggled_on: bool) -> void:
	_set_value_to_property(p_toggled_on)

func _on_color_changed(p_color: Color) -> void:
	_set_value_to_property(p_color)

func _on_line_edit_text_changed(p_text: String) -> void:
	_set_value_to_property(p_text)

func _on_spin_box_value_changed(p_value: float) -> void:
	_set_value_to_property(p_value)

func _on_slider_value_changed(p_value: float) -> void:
	_set_value_to_property(p_value)

func _on_option_item_selected(p_index: int) -> void:
	_set_value_to_property(p_index)

func _on_text_edit_text_changed(p_text: String) -> void:
	_set_value_to_property(p_text)
