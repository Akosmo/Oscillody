# Oscillody
# Copyright (C) 2025-present Akosmo

# basic_property_container.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name BasicPropertyContainer
extends PanelContainer

signal property_value_changed(p_property_key: StringName, p_property_value: Variant)
signal property_reset_pressed(p_property_key: StringName)

## The possible [Control] nodes that can be used to control property values.
enum ControlNode {
	## Uses [Button].
	BUTTON,
	## Uses [CheckButton].
	CHECK_BUTTON,
	## Uses [ColorPicketButton].
	COLOR_PICKER_BUTTON,
	## Uses [LineEdit].
	LINE_EDIT,
	## Uses [SpinBox], or [CustomHSlider] if
	## [method SettingsManager.are_sliders_enabled] is [code]true[/code].
	NUMERICAL,
	## Uses [OptionButton].
	OPTION_BUTTON,
	## Uses [TextEdit].
	TEXT_EDIT
}

var _control_node: ControlNode

var _property_key: StringName
var _property_value: Variant
var _reset_value: Variant

var _use_file_dialog: bool

@onready var property_label: Label = %PropertyLabel
@onready var reset_button: Button = %ResetButton

#@onready var h_box_container: HBoxContainer = %HBoxContainer

@onready var button: Button = %Button
@onready var file_dialog: FileDialog = %FileDialog
@onready var check_button: CheckButton = %CheckButton
@onready var color_picker_button: ColorPickerButton = %ColorPickerButton
@onready var line_edit: LineEdit = %LineEdit
@onready var spin_box: SpinBox = %SpinBox
@onready var custom_h_slider: CustomHSlider = %CustomHSlider
@onready var option_button: OptionButton = %OptionButton
@onready var text_edit: TextEdit = %TextEdit

func _ready() -> void:
	SettingsManager.slider_preference_changed.connect(_on_slider_preference_changed)
	
	reset_button.pressed.connect(_on_reset_pressed)
	button.pressed.connect(_on_button_pressed)
	file_dialog.file_selected.connect(_on_file_selected)
	check_button.toggled.connect(_on_check_toggled)
	color_picker_button.color_changed.connect(_on_color_changed)
	line_edit.text_changed.connect(_on_line_edit_text_changed)
	spin_box.value_changed.connect(_on_spin_box_value_changed)
	custom_h_slider.value_changed.connect(_on_slider_value_changed)
	option_button.item_selected.connect(_on_option_item_selected)
	text_edit.text_changed.connect(_on_text_edit_text_changed)
	
	# TODO: Handle slider switch here.

func set_control_node(p_control_node: ControlNode) -> void:
	_control_node = p_control_node
	
	match _control_node:
		ControlNode.BUTTON:
			button.show()
		ControlNode.CHECK_BUTTON:
			check_button.show()
		ControlNode.COLOR_PICKER_BUTTON:
			color_picker_button.show()
		ControlNode.LINE_EDIT:
			line_edit.show()
		ControlNode.NUMERICAL:
			if not SettingsManager.are_sliders_enabled():
				spin_box.show()
			else:
				custom_h_slider.show()
		ControlNode.OPTION_BUTTON:
			option_button.show()
		ControlNode.TEXT_EDIT:
			text_edit.show()

#func get_control_node() -> ControlNode:
	#return _control_node

func set_property_key(p_key: StringName) -> void:
	_property_key = p_key
	
	var property_str: String = String(_property_key)
	#var close_parenthesis_idx: int = property_str.find(")")
	property_label.set_text(property_str.get_slice(")_", 1).replace("_", " "))
	set_name(property_str.replace(" ", ""))
	#var property_str: String = String(_property_key)
	#var open_parenthesis_idx: int = property_str.findn("(")
	#var property_key_substr: String
	#var property_key_no_substr: String
	#if open_parenthesis_idx >= 0:
		#var close_parenthesis_idx: int = property_str.findn(")")
		## Also remove close parenthesis and the space afterwards.
		#property_key_substr = property_str.substr(open_parenthesis_idx, close_parenthesis_idx + 2)
		#@warning_ignore("unsafe_property_access")
		#property_key_no_substr = property_str.replacen(property_key_substr, "")
	#else:
		#property_key_no_substr = property_str
	#property_label.set_text(property_key_no_substr)
	#set_name(property_key_no_substr.replacen(" ", ""))

func get_property_key() -> StringName:
	return _property_key

func set_property_value(p_value: Variant) -> void:
	_property_value = p_value
	_set_reset_button_visibility()

func get_property_value() -> Variant:
	return _property_value

func set_property_value_with_node(p_value: Variant) -> void:
	set_property_value(p_value)
	
	match _control_node:
		ControlNode.BUTTON:
			pass
		ControlNode.CHECK_BUTTON:
			@warning_ignore("unsafe_cast")
			check_button.set_pressed_no_signal(p_value as bool)
		ControlNode.COLOR_PICKER_BUTTON:
			# TEST: Make sure this doesn't emit a signal.
			color_picker_button.set_pick_color(p_value as Color)
		ControlNode.LINE_EDIT:
			line_edit.set_text(p_value as String)
		ControlNode.NUMERICAL:
			spin_box.set_value_no_signal(p_value as float)
			custom_h_slider.set_value_no_signal(p_value as float)
		ControlNode.OPTION_BUTTON:
			# TEST: Make sure this doesn't emit a signal.
			if option_button.get_item_count() > 0:
				if typeof(p_value) == TYPE_INT:
					@warning_ignore("unsafe_cast")
					option_button.select(p_value as int)
				elif typeof(p_value) == TYPE_STRING_NAME:
					for idx: int in option_button.get_item_count():
						if option_button.get_item_text(idx) == String(p_value):
							option_button.select(idx)
							break
				elif typeof(p_value) == TYPE_STRING:
					for idx: int in option_button.get_item_count():
						if option_button.get_item_text(idx) == p_value:
							option_button.select(idx)
							break
				else:
					printerr("Wrong type for OptionButton.")
		ControlNode.TEXT_EDIT:
			text_edit.set_text(p_value as String)

func set_reset_value(p_value: Variant) -> void:
	_reset_value = p_value
	_set_reset_button_visibility()

func use_file_dialog(p_enable: bool = true) -> void:
	_use_file_dialog = p_enable

func _set_reset_button_visibility() -> void:
	if _reset_value != null:
		if _reset_value != _property_value:
			reset_button.show()
		else:
			reset_button.hide()

#func set_property_label(p_property: StringName) -> void:
	#var property_str: String = String(p_property)
	#var open_parenthesis_idx: int = property_str.findn("(")
	#var property_key_substr: String
	#var property_key_no_substr: String
	#if open_parenthesis_idx >= 0:
		#var close_parenthesis_idx: int = property_str.findn(")")
		## Also remove close parenthesis and the space afterwards.
		#property_key_substr = property_str.substr(open_parenthesis_idx, close_parenthesis_idx + 2)
		#@warning_ignore("unsafe_property_access")
		#property_key_no_substr = property_str.replacen(property_key_substr, "")
	#else:
		#property_key_no_substr = property_str
	#_property_label.set_text(property_key_no_substr)
	#
	#set_name(_property_label.get_text().replacen(" ", ""))
#
#func set_property_label_basic(p_property: String) -> void:
	#pass
#
#func set_reset_button_visibility(p_visible: bool) -> void:
	#pass
#
#func set_control_node_visibility(p_control_node: ControlNode) -> void:
	#match p_control_node:
		#ControlNode.BUTTON:
			#_button.show()
		#ControlNode.CHECK_BUTTON:
			#_check_button.show()
		#ControlNode.COLOR_PICKER_BUTTON:
			#_color_picker_button.show()
		#ControlNode.LINE_EDIT:
			#_line_edit.show()
		#ControlNode.NUMERICAL:
			#if SettingsManager.are_sliders_enabled():
				#_spin_box.hide()
				#_custom_h_slider.show()
			#else:
				#_spin_box.show()
				#_custom_h_slider.hide()
		#ControlNode.OPTION_BUTTON:
			#_option_button.show()
		#ControlNode.TEXT_EDIT:
			#_text_edit.show()
#
#func set_button_text(p_text: String) -> void:
	#pass
#
#func set_file_dialog_filters(p_filters: PackedStringArray) -> void:
	#_file_dialog.set_filters(p_filters)
#
#func set_numerical_range(p_min: float, p_max: float, p_step: float, p_rounded: bool) -> void:
	#pass
#
#func set_options(p_options: Array) -> void:
	#pass
#
#func set_check_button_toggled(p_toggled_on: bool) -> void:
	#pass
#
#func set_color_picker_color(p_color: Color) -> void:
	#pass
#
#func set_line_edit_text(p_text: String) -> void:
	#pass
#
#func set_numerical_value(p_value: float) -> void:
	#pass
#
#func set_option_button_index(p_index: int) -> void:
	#pass
#
#func set_option_button_index_by_text(p_text: String) -> void:
	#pass
#
#func set_text_edit_text(p_text: String) -> void:
	#pass
#

func _on_slider_preference_changed() -> void:
	if _control_node == ControlNode.NUMERICAL:
		spin_box.set_visible(custom_h_slider.is_visible())
		custom_h_slider.set_visible(not spin_box.is_visible())

func _on_reset_pressed() -> void:
	set_property_value(_reset_value)
	match _control_node:
		ControlNode.BUTTON:
			pass
		ControlNode.CHECK_BUTTON:
			check_button.set_pressed_no_signal(_reset_value)
		ControlNode.COLOR_PICKER_BUTTON:
			color_picker_button.set_pick_color(_reset_value)
		ControlNode.LINE_EDIT:
			line_edit.set_text(_reset_value)
		ControlNode.NUMERICAL:
			spin_box.set_value_no_signal(_reset_value)
			custom_h_slider.set_value_no_signal(_reset_value)
		ControlNode.OPTION_BUTTON:
			if typeof(_reset_value) == TYPE_INT:
				@warning_ignore("unsafe_cast")
				option_button.select(_reset_value as int)
			elif typeof(_reset_value) == TYPE_STRING_NAME:
				for idx: int in option_button.get_item_count():
					if option_button.get_item_text(idx) == String(_reset_value):
						option_button.select(idx)
						break
			elif typeof(_reset_value) == TYPE_STRING:
				for idx: int in option_button.get_item_count():
					if option_button.get_item_text(idx) == _reset_value:
						option_button.select(idx)
						break
			else:
				printerr("Wrong type for OptionButton.")
		ControlNode.TEXT_EDIT:
			line_edit.set_text(_reset_value)
	property_value_changed.emit(_property_key, _property_value)
	property_reset_pressed.emit(_property_key, _property_value)

func _on_button_pressed() -> void:
	if _use_file_dialog:
		file_dialog.show()
	else:
		property_value_changed.emit(_property_key, _property_value)

func _on_file_selected(p_path: String) -> void:
	set_property_value(p_path)
	property_value_changed.emit(_property_key, p_path)

func _on_check_toggled(p_toggled_on: bool) -> void:
	set_property_value(p_toggled_on)
	property_value_changed.emit(_property_key, p_toggled_on)

func _on_color_changed(p_color: Color) -> void:
	set_property_value(p_color)
	property_value_changed.emit(_property_key, p_color)

func _on_line_edit_text_changed(p_text: String) -> void:
	set_property_value(p_text)
	property_value_changed.emit(_property_key, p_text)

func _on_spin_box_value_changed(p_value: float) -> void:
	set_property_value(p_value)
	property_value_changed.emit(_property_key, p_value)

func _on_slider_value_changed(p_value: float) -> void:
	set_property_value(p_value)
	property_value_changed.emit(_property_key, p_value)

func _on_option_item_selected(p_index: int) -> void:
	if typeof(_property_value) == TYPE_INT:
		set_property_value(p_index)
		property_value_changed.emit(_property_key, p_index)
	elif typeof(_property_value) == TYPE_STRING_NAME:
		#var options: Array = _property_configurations.get(ElementUIConfigurations.OPTIONS)
		#var new_value: StringName = options[p_index]
		set_property_value(StringName(option_button.get_item_text(p_index)))
		property_value_changed.emit(_property_key, StringName(option_button.get_item_text(p_index)))
	elif typeof(_property_value) == TYPE_STRING:
		#var options: Array = _property_configurations.get(ElementUIConfigurations.OPTIONS)
		#var new_value: StringName = options[p_index]
		set_property_value(option_button.get_item_text(p_index))
		property_value_changed.emit(_property_key, option_button.get_item_text(p_index))
	else:
		printerr("Wrong type for OptionButton.")

func _on_text_edit_text_changed() -> void:
	set_property_value(text_edit.get_text())
	property_value_changed.emit(_property_key, _property_value)
