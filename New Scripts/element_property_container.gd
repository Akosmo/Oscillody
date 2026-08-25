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

var element_uid: int = ElementManager.INVALID_UID
var property_key: StringName

var _property_configurations: Dictionary[StringName, Variant]
var _control_node: ElementUIHelper.ControlNode
var _property_value: Variant
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

func _ready() -> void:
	if _connect_all_signals():
		printerr("Could not connect all property signals.")
		return
	
	if ElementManager.property_exists(element_uid, property_key):
		_value_label.set_text(String(property_key))
		
		_property_configurations = ElementUIHelper.get_property_configurations(element_uid, property_key)
		
		if not _property_configurations.is_empty():
			_control_node = _property_configurations.get(ElementUIHelper.CONTROL_NODE)
			_reset_value = _property_configurations.get(ElementUIHelper.DEFAULT_VALUE)
		
		_property_value = ElementManager.get_element_property(element_uid, property_key)
		if _reset_value != null and _property_value != _reset_value:
			_reset_button.show()
		
		_set_property_value_to_control()

func _connect_all_signals() -> Error:
	if SettingsManager.slider_preference_changed.connect(_on_slider_preference_changed):
		return ERR_INVALID_PARAMETER
	
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

func _set_value_to_property(p_value: Variant) -> void:
	if ElementManager.property_exists(element_uid, property_key):
		if ElementManager.set_element_property(element_uid, property_key, p_value):
			printerr(
				"Could not set {property} to {value} in {UID}.".format(
					{"property": property_key,
					"value": p_value,
					"UID": element_uid
					}
				)
			)
		_property_value = p_value

# TEST: Check if this trigger signals. Depending on the result, optimize to avoid unnecessary calls.
func _set_property_value_to_control() -> void:
	match _control_node:
		ElementUIHelper.ControlNode.BUTTON:
			_button.show()
		ElementUIHelper.ControlNode.CHECK_BUTTON:
			_check_button.show()
			@warning_ignore("unsafe_cast")
			_check_button.set_pressed(_property_value as bool)
		ElementUIHelper.ControlNode.COLOR_PICKER_BUTTON:
			_color_picker_button.show()
			@warning_ignore("unsafe_cast")
			_color_picker_button.set_pick_color(_property_value as Color)
		ElementUIHelper.ControlNode.LINE_EDIT:
			_line_edit.show()
			_line_edit.set_text(str(_property_value))
		ElementUIHelper.ControlNode.NUMERICAL:
			if SettingsManager.are_sliders_enabled(): # TODO: Make a signal for this.
				_custom_h_slider.show()
				if property_key == ElementManager.LAYER:
					var _max_from_size: float = float(ElementManager.get_elements().size() - 1)
					if _custom_h_slider.configure_slider(0.0, _max_from_size, 1.0, true):
						printerr("Could not configure slider.")
				else:
					@warning_ignore("unsafe_cast")
					var _min: float = _property_configurations.get(ElementUIHelper.MINIMUM) as float
					@warning_ignore("unsafe_cast")
					var _max: float = _property_configurations.get(ElementUIHelper.MAXIUMUM) as float
					@warning_ignore("unsafe_cast")
					var _step: float = _property_configurations.get(ElementUIHelper.STEP) as float
					@warning_ignore("unsafe_cast")
					var _rounded: bool = _property_configurations.get(ElementUIHelper.ROUNDED) as bool
					if _custom_h_slider.configure_slider(_min, _max, _step, _rounded):
						printerr("Could not configure slider.")
				@warning_ignore("unsafe_call_argument")
				if _custom_h_slider.set_value(_property_value):
					printerr("Wrong value given the slider's configurations.")
			else:
				_spin_box.show()
				if property_key == ElementManager.LAYER:
					var _max_from_size: float = float(ElementManager.get_elements().size() - 1)
					_spin_box.set_min(0.0)
					_spin_box.set_max(_max_from_size)
					_spin_box.set_step(1.0)
					_spin_box.set_use_rounded_values(true)
				else:
					@warning_ignore("unsafe_cast")
					var _min: float = _property_configurations.get(ElementUIHelper.MINIMUM) as float
					@warning_ignore("unsafe_cast")
					var _max: float = _property_configurations.get(ElementUIHelper.MAXIUMUM) as float
					@warning_ignore("unsafe_cast")
					var _step: float = _property_configurations.get(ElementUIHelper.STEP) as float
					@warning_ignore("unsafe_cast")
					var _rounded: bool = _property_configurations.get(ElementUIHelper.ROUNDED) as bool
					_spin_box.set_min(_min)
					_spin_box.set_max(_max)
					_spin_box.set_step(_step)
					_spin_box.set_use_rounded_values(_rounded)
				@warning_ignore("unsafe_call_argument")
				_spin_box.set_value(_property_value)
		ElementUIHelper.ControlNode.OPTION_BUTTON:
			_option_button.show()
			if property_key == ElementManager.TYPE:
				for item: StringName in ElementUIHelper.ELEMENT_TYPES:
					_option_button.add_item(item)
			else:
				@warning_ignore("unsafe_method_access")
				for item: StringName in _property_configurations.get(ElementUIHelper.OPTIONS).values():
					_option_button.add_item(item)
			@warning_ignore("unsafe_cast")
			_option_button.select(_property_value as int)
		ElementUIHelper.ControlNode.TEXT_EDIT:
			_text_edit.show()
			_text_edit.set_text(str(_property_value))

func _on_slider_preference_changed() -> void:
	_set_property_value_to_control()

func _on_reset_pressed() -> void:
	_property_value = _reset_value
	_set_value_to_property(_reset_value)
	_set_property_value_to_control()

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
