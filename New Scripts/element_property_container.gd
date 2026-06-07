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

var elements: VisualizerElements
var element_uid: int = -1
var property_key: StringName
var reset_value: Variant

@onready var value_label: Label = $MarginContainer/HBoxContainer/Label
@onready var reset_button: Button = $MarginContainer/HBoxContainer/Button

#@onready var _h_box_container: HBoxContainer = $MarginContainer/HBoxContainer/HBoxContainer

@onready var button: Button = $MarginContainer/HBoxContainer/HBoxContainer/Button
@onready var check_button: CheckButton = $MarginContainer/HBoxContainer/HBoxContainer/CheckButton
@onready var color_picker_button: ColorPickerButton = $MarginContainer/HBoxContainer/HBoxContainer/ColorPickerButton
@onready var line_edit: LineEdit = $MarginContainer/HBoxContainer/HBoxContainer/LineEdit
@onready var spin_box: SpinBox = $MarginContainer/HBoxContainer/HBoxContainer/SpinBox
@onready var custom_h_slider: CustomHSlider = $MarginContainer/HBoxContainer/HBoxContainer/CustomHSlider
@onready var option_button: OptionButton = $MarginContainer/HBoxContainer/HBoxContainer/OptionButton
@onready var text_edit: TextEdit = $MarginContainer/HBoxContainer/HBoxContainer/TextEdit

# TODO: Split inside sections into different functions,
# and also configure slider (and spinbox) before setting value.
func _ready() -> void:
	var err_signals: Error = _connect_all_signals()
	if err_signals:
		printerr("Could not connect all property signals.")
	
	if _is_for_element() and elements.property_exists(element_uid, property_key):
		value_label.set_text(String(property_key))
		
		if property_key == elements.TYPE:
			option_button.add_item("Analyzer")
			option_button.add_item("Gradient")
			option_button.add_item("Image")
			option_button.add_item("Post-Processing")
			option_button.add_item("Shader")
			option_button.add_item("Shape")
			option_button.add_item("Solid Color")
			option_button.add_item("Text")
		
		_set_property_value_to_control(elements.get_element_property(element_uid, property_key))

func _connect_all_signals() -> Error:
	var err_on_reset_pressed: Error = reset_button.connect("pressed", _on_reset_pressed)
	if err_on_reset_pressed:
		return FAILED
	
	var err_on_button_pressed: Error = button.connect("pressed", _on_button_pressed)
	if err_on_button_pressed:
		return FAILED
	var err_on_check_toggled: Error = check_button.connect("toggled", _on_check_toggled)
	if err_on_check_toggled:
		return FAILED
	var err_on_color_changed: Error = color_picker_button.connect("color_changed", _on_color_changed)
	if err_on_color_changed:
		return FAILED
	var err_on_line_edit_text_changed: Error = line_edit.connect("text_changed", _on_line_edit_text_changed)
	if err_on_line_edit_text_changed:
		return FAILED
	var err_on_spin_box_value_changed: Error = spin_box.connect("value_changed", _on_spin_box_value_changed)
	if err_on_spin_box_value_changed:
		return FAILED
	var err_on_slider_value: Error = custom_h_slider.connect("value_changed", _on_slider_value_changed)
	if err_on_slider_value:
		return FAILED
	var err_on_option_item_selected: Error = option_button.connect("item_selected", _on_option_item_selected)
	if err_on_option_item_selected:
		return FAILED
	var err_on_text_edit_text_changed: Error = text_edit.connect("text_changed", _on_text_edit_text_changed)
	if err_on_text_edit_text_changed:
		return FAILED
	
	return OK

func _is_for_element() -> bool:
	if elements != null and element_uid >= 0 and not property_key.is_empty():
		return true
	else:
		return false

func _set_value_to_property(p_value: Variant) -> void:
	if _is_for_element() and elements.property_exists(element_uid, property_key):
		var err: Error = elements.set_element_property(element_uid, property_key, p_value)
		if err:
			printerr(
				"Could not set {property} to {value} in {UID}.".format(
					{"property": property_key,
					"value": p_value,
					"UID": element_uid
					}
				)
			)

# Figure this out without a hard-coded approach. May need changed in VisualizerElements.
func _set_property_value_to_control(p_value: Variant) -> void:
	match elements.get_control_node_for_property(element_uid, property_key):
		elements.ControlNode.BUTTON:
			button.show()
		elements.ControlNode.CHECK_BUTTON:
			check_button.show()
			@warning_ignore("unsafe_cast")
			check_button.set_pressed(p_value as bool)
		elements.ControlNode.COLOR_PICKER_BUTTON:
			color_picker_button.show()
			@warning_ignore("unsafe_cast")
			color_picker_button.set_pick_color(p_value as Color)
		elements.ControlNode.LINE_EDIT:
			line_edit.show()
			line_edit.set_text(str(p_value))
		elements.ControlNode.NUMERICAL:
			# TODO: Check if user prefer sliders. Have an instance of a Settings class.
			spin_box.show()
			@warning_ignore("unsafe_call_argument")
			spin_box.set_value(p_value)
			@warning_ignore("unsafe_call_argument")
			var err: Error = custom_h_slider.set_value(p_value)
			if err:
				printerr("Wrong value given the slider's configurations.")
		elements.ControlNode.OPTION_BUTTON:
			option_button.show()
			@warning_ignore("unsafe_cast")
			option_button.select(p_value as int)
		elements.ControlNode.TEXT_EDIT:
			text_edit.show()
			text_edit.set_text(str(p_value))

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
