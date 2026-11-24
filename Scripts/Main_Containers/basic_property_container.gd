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
	## Uses [SpinBox], or a custom slider if ever implemented.
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
@onready var reset_button: Button

@onready var h_box_container: HBoxContainer = %HBoxContainer
@onready var control_node_box_container: HBoxContainer = %ControlNodeBoxContainer

@onready var button: Button
@onready var file_dialog: FileDialog
@onready var check_button: CheckButton
@onready var color_picker_button: ColorPickerButton
@onready var line_edit: LineEdit
@onready var spin_box: SpinBox
@onready var option_button: OptionButton
@onready var text_edit: TextEdit

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func set_control_node(p_control_node: ControlNode) -> void:
	_control_node = p_control_node
	
	if control_node_box_container.get_child_count():
		CustomLogger.log_warning("A ControlNode is already set.")
		return
	
	match _control_node:
		ControlNode.BUTTON:
			button = Button.new()
			control_node_box_container.add_child(button)
			button.pressed.connect(_on_button_pressed)
		ControlNode.CHECK_BUTTON:
			check_button = CheckButton.new()
			control_node_box_container.add_child(check_button)
			check_button.toggled.connect(_on_check_toggled)
		ControlNode.COLOR_PICKER_BUTTON:
			color_picker_button = ColorPickerButton.new()
			color_picker_button.set_pick_color(Color.WHITE)
			color_picker_button.set_custom_minimum_size(Vector2(32.0, 0.0))
			control_node_box_container.add_child(color_picker_button)
			color_picker_button.color_changed.connect(_on_color_changed)
		ControlNode.LINE_EDIT:
			line_edit = LineEdit.new()
			line_edit.set_custom_minimum_size(Vector2(128.0, 0.0))
			control_node_box_container.add_child(line_edit)
			line_edit.text_changed.connect(_on_line_edit_text_changed)
		ControlNode.NUMERICAL:
			spin_box = SpinBox.new()
			control_node_box_container.add_child(spin_box)
			spin_box.value_changed.connect(_on_spin_box_value_changed)
		ControlNode.OPTION_BUTTON:
			option_button = OptionButton.new()
			option_button.set_fit_to_longest_item(false)
			option_button.set_clip_text(true)
			option_button.set_custom_minimum_size(Vector2(120.0, 0.0))
			control_node_box_container.add_child(option_button)
			option_button.item_selected.connect(_on_option_item_selected)
		ControlNode.TEXT_EDIT:
			text_edit = TextEdit.new()
			text_edit.set_custom_minimum_size(Vector2(200.0, 100.0))
			control_node_box_container.add_child(text_edit)
			text_edit.text_changed.connect(_on_text_edit_text_changed)
	
	if reset_button != null:
		h_box_container.move_child(reset_button, 1)

func get_control_node() -> ControlNode:
	return _control_node

func set_property_key(p_key: StringName) -> void:
	_property_key = p_key
	
	var property_str: String = String(_property_key)
	property_label.set_text(property_str.get_slice(")_", 1).replace("_", " "))
	set_name(property_str.replace(" ", ""))

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
			check_button.set_pressed_no_signal(p_value as bool)
		ControlNode.COLOR_PICKER_BUTTON:
			color_picker_button.set_pick_color(p_value as Color)
		ControlNode.LINE_EDIT:
			line_edit.set_text(p_value as String)
		ControlNode.NUMERICAL:
			spin_box.set_value_no_signal(p_value as float)
		ControlNode.OPTION_BUTTON:
			option_button.select(-1)
			if option_button.get_item_count() > 0:
				if typeof(p_value) == TYPE_INT:
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
					CustomLogger.log_warning("Wrong type for OptionButton.")
		ControlNode.TEXT_EDIT:
			text_edit.set_text(p_value as String)

func set_reset_value(p_value: Variant) -> void:
	if _property_value == null:
		CustomLogger.log_warning("Set a property value first.")
		return
	
	_reset_value = p_value
	
	if reset_button == null:
		reset_button = Button.new()
		reset_button.set_text("R")
		reset_button.set_h_size_flags(Control.SizeFlags.SIZE_SHRINK_END)
		h_box_container.add_child(reset_button)
		reset_button.pressed.connect(_on_reset_pressed)
		if reset_button.get_index() != 1:
			h_box_container.move_child(reset_button, 1)
	
	_set_reset_button_visibility()

func get_reset_value() -> Variant:
	return _reset_value

func use_file_dialog(p_enable: bool = true) -> void:
	_use_file_dialog = p_enable
	
	if file_dialog != null:
		file_dialog.free()
	
	if p_enable:
		file_dialog = FileDialog.new()
		file_dialog.set_file_mode(FileDialog.FileMode.FILE_MODE_OPEN_FILE)
		file_dialog.set_access(FileDialog.Access.ACCESS_FILESYSTEM)
		file_dialog.set_use_native_dialog(true)
		file_dialog.set_hide_on_ok(true)
		button.add_child(file_dialog)
		file_dialog.file_selected.connect(_on_file_selected)

func _set_reset_button_visibility() -> void:
	if _reset_value != null and reset_button != null:
		if _reset_value != _property_value:
			reset_button.show()
		else:
			reset_button.hide()

func _on_mouse_entered() -> void:
	TooltipManager.notify_tooltip(true, self)

func _on_mouse_exited() -> void:
	TooltipManager.notify_tooltip(false, self)

func _on_reset_pressed() -> void:
	set_property_value(_reset_value)
	match _control_node:
		ControlNode.BUTTON:
			pass
		ControlNode.CHECK_BUTTON:
			check_button.set_pressed_no_signal(_reset_value as bool)
		ControlNode.COLOR_PICKER_BUTTON:
			color_picker_button.set_pick_color(_reset_value as Color)
		ControlNode.LINE_EDIT:
			line_edit.set_text(_reset_value)
		ControlNode.NUMERICAL:
			spin_box.set_value_no_signal(_reset_value)
		ControlNode.OPTION_BUTTON:
			if typeof(_reset_value) == TYPE_INT:
				option_button.select(_reset_value as int)
			elif typeof(_reset_value) == TYPE_STRING_NAME:
				var found_item: bool = false
				for idx: int in option_button.get_item_count():
					if option_button.get_item_text(idx) == String(_reset_value):
						option_button.select(idx)
						found_item = true
						break
				if not found_item:
					option_button.select(-1)
			elif typeof(_reset_value) == TYPE_STRING:
				var found_item: bool = false
				for idx: int in option_button.get_item_count():
					if option_button.get_item_text(idx) == _reset_value:
						option_button.select(idx)
						found_item = true
						break
				if not found_item:
					option_button.select(-1)
			else:
				CustomLogger.log_warning("Wrong type for OptionButton.")
		ControlNode.TEXT_EDIT:
			line_edit.set_text(String(_reset_value))
	property_value_changed.emit(_property_key, _property_value)
	property_reset_pressed.emit(_property_key)

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

func _on_option_item_selected(p_index: int) -> void:
	if typeof(_property_value) == TYPE_INT:
		set_property_value(p_index)
		property_value_changed.emit(_property_key, p_index)
	elif typeof(_property_value) == TYPE_STRING_NAME:
		set_property_value(StringName(option_button.get_item_text(p_index)))
		property_value_changed.emit(_property_key, StringName(option_button.get_item_text(p_index)))
	elif typeof(_property_value) == TYPE_STRING:
		set_property_value(option_button.get_item_text(p_index))
		property_value_changed.emit(_property_key, option_button.get_item_text(p_index))
	else:
		CustomLogger.log_warning("Wrong type for OptionButton.")

func _on_text_edit_text_changed() -> void:
	set_property_value(text_edit.get_text())
	property_value_changed.emit(_property_key, _property_value)
