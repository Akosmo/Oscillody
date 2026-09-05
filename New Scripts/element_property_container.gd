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

# FIXME: Signal methods are called when properties are instantiated. Maybe this shouldn't happen.

class_name ElementPropertyContainer
extends PanelContainer
## UI class representing an [Element]'s property.

## The Element linked to this class, assigned at instantiation.
var element: Element
## The Element property linked to this class, assigned at instantiation.
var property_key: StringName

var _property_key_no_substr: String
# Contains all property configurations of any Element type. The relevant one can be obtained by
# using `property_key` as a key.
var _property_configurations: Dictionary
var _control_node: ElementUIConfigurations.ControlNode
var _property_value: Variant
var _reset_value: Variant

var _stop_signal: bool = false

@onready var _property_label: Label = %PropertyLabel
@onready var _reset_button: Button = %ResetButton
@onready var _button: Button = %Button
@onready var _file_dialog: FileDialog = %FileDialog
@onready var _check_button: CheckButton = %CheckButton
@onready var _color_picker_button: ColorPickerButton = %ColorPickerButton
@onready var _line_edit: LineEdit = %LineEdit
@onready var _spin_box: SpinBox = %SpinBox
@onready var _custom_h_slider: CustomHSlider = %CustomHSlider
@onready var _option_button: OptionButton = %OptionButton
@onready var _text_edit: TextEdit = %TextEdit

func _ready() -> void:
	if _connect_signals():
		printerr("Could not connect signals.")
		return
	
	var open_parenthesis_idx: int = property_key.findn("(")
	var property_key_substr: String
	if open_parenthesis_idx >= 0:
		var close_parenthesis_idx: int = property_key.findn(")")
		# Also remove close parenthesis and the space afterwards.
		property_key_substr = property_key.substr(open_parenthesis_idx, close_parenthesis_idx + 2)
		@warning_ignore("unsafe_property_access")
		_property_key_no_substr = property_key.replacen(property_key_substr, "")
	else:
		_property_key_no_substr = property_key
	_property_label.set_text(_property_key_no_substr.capitalize())
	
	set_name(_property_label.get_text().replacen(" ", ""))
	
	_update_property_configuration_dictionary()
	
	_control_node = _property_configurations.get(ElementUIConfigurations.CONTROL_NODE)
	if _property_configurations.has(ElementUIConfigurations.DEFAULT_VALUE):
		_reset_value = _property_configurations.get(ElementUIConfigurations.DEFAULT_VALUE)
	_property_value = element.get_property_dictionary().get(property_key)
	
	if _reset_value != null and _property_value != _reset_value:
		_reset_button.show()
	
	_set_property_value_to_control()

func _connect_signals() -> Error:
	if SettingsManager.slider_preference_changed.connect(_on_slider_preference_changed):
		return ERR_INVALID_PARAMETER
	
	if ElementManager.element_created.connect(_on_external_options_changed):
		return ERR_INVALID_PARAMETER
	if ElementManager.element_deleted.connect(_on_external_options_changed):
		return ERR_INVALID_PARAMETER
	if AudioManager.stream_list_updated.connect(_on_external_options_changed_no_parameter):
		return ERR_INVALID_PARAMETER
	
	if _reset_button.pressed.connect(_on_reset_pressed):
		return ERR_INVALID_PARAMETER
	
	if _button.pressed.connect(_on_button_pressed):
		return ERR_INVALID_PARAMETER
	if _file_dialog.file_selected.connect(_on_file_selected):
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
	# If I want to avoid a long `match` statement, and I also can't set properties directly,
	# this is the only way I've found to modify the property.
	@warning_ignore("unsafe_cast")
	element.call(element.get_method_dictionary().get(property_key) as StringName, p_value)
	_property_value = p_value
	
	if _reset_value != null:
		if _property_value != _reset_value:
			_reset_button.show()
		else:
			_reset_button.hide()

func _set_property_value_to_control() -> void:
	_stop_signal = true
	
	match _control_node:
		ElementUIConfigurations.ControlNode.BUTTON:
			_button.show()
			_button.set_text("Select Image")
		ElementUIConfigurations.ControlNode.CHECK_BUTTON:
			_check_button.show()
			@warning_ignore("unsafe_cast")
			_check_button.set_pressed(_property_value as bool)
		ElementUIConfigurations.ControlNode.COLOR_PICKER_BUTTON:
			_color_picker_button.show()
			@warning_ignore("unsafe_cast")
			_color_picker_button.set_pick_color(_property_value as Color)
		ElementUIConfigurations.ControlNode.LINE_EDIT:
			_line_edit.show()
			_line_edit.set_text(str(_property_value))
		ElementUIConfigurations.ControlNode.NUMERICAL:
			if SettingsManager.are_sliders_enabled():
				_spin_box.hide()
				_custom_h_slider.show()
				@warning_ignore("unsafe_cast")
				var _min: float = _property_configurations.get(ElementUIConfigurations.MINIMUM) as float
				@warning_ignore("unsafe_cast")
				var _max: float = _property_configurations.get(ElementUIConfigurations.MAXIMUM) as float
				@warning_ignore("unsafe_cast")
				var _step: float = _property_configurations.get(ElementUIConfigurations.STEP) as float
				@warning_ignore("unsafe_cast")
				var _rounded: bool = _property_configurations.get(ElementUIConfigurations.ROUNDED) as bool
				if _custom_h_slider.configure_slider(_min, _max, _step, _rounded):
					printerr("Could not configure slider.")
				@warning_ignore("unsafe_call_argument")
				if _custom_h_slider.set_value(_property_value):
					printerr("Wrong value given the slider's configurations.")
			else:
				_spin_box.show()
				_custom_h_slider.hide()
				@warning_ignore("unsafe_cast")
				var _min: float = _property_configurations.get(ElementUIConfigurations.MINIMUM) as float
				@warning_ignore("unsafe_cast")
				var _max: float = _property_configurations.get(ElementUIConfigurations.MAXIMUM) as float
				@warning_ignore("unsafe_cast")
				var _step: float = _property_configurations.get(ElementUIConfigurations.STEP) as float
				@warning_ignore("unsafe_cast")
				var _rounded: bool = _property_configurations.get(ElementUIConfigurations.ROUNDED) as bool
				_spin_box.set_min(_min)
				_spin_box.set_max(_max)
				_spin_box.set_step(_step)
				_spin_box.set_use_rounded_values(_rounded)
				@warning_ignore("unsafe_call_argument")
				_spin_box.set_value(_property_value)
		ElementUIConfigurations.ControlNode.OPTION_BUTTON:
			_option_button.show()
			_option_button.clear()
			@warning_ignore("unsafe_method_access")
			for item: StringName in _property_configurations.get(ElementUIConfigurations.OPTIONS):
				_option_button.add_item(item)
			if _option_button.get_item_count() > 0:
				if typeof(_property_value) == TYPE_INT:
					@warning_ignore("unsafe_cast")
					_option_button.select(_property_value as int)
				elif typeof(_property_value) == TYPE_STRING_NAME or typeof(_property_value) == TYPE_STRING:
					var options: Array = _property_configurations.get(ElementUIConfigurations.OPTIONS)
					var idx: int = options.find(_property_value)
					_option_button.select(idx)
				else:
					printerr("Wrong type for OptionButton.")
		ElementUIConfigurations.ControlNode.TEXT_EDIT:
			_text_edit.show()
			_text_edit.set_text(str(_property_value))
	
	_stop_signal = false

func _update_property_configuration_dictionary() -> void:
	match element.get_type():
		element.ElementType.EMPTY:
			var config_resource: ElementEmptyUIConfigurations = preload("uid://c5noed3x5ibew")
			var all_configs: Dictionary[StringName, Dictionary] = config_resource.get_property_configurations()
			var property_dict: Dictionary = all_configs.get(property_key)
			_property_configurations = property_dict
		element.ElementType.ANALYZER:
			var config_resource: ElementAnalyzerUIConfigurations = preload("uid://blysgijw0k6ah")
			var all_configs: Dictionary[StringName, Dictionary] = config_resource.get_property_configurations()
			var property_dict: Dictionary = all_configs.get(property_key)
			_property_configurations = property_dict
		element.ElementType.IMAGE:
			var config_resource: ElementImageUIConfigurations = preload("uid://d22vhxv5sqx2t")
			var all_configs: Dictionary[StringName, Dictionary] = config_resource.get_property_configurations()
			var property_dict: Dictionary = all_configs.get(property_key)
			_property_configurations = property_dict
		element.ElementType.POST_PROCESSING:
			pass
		element.ElementType.SHADER:
			pass
		element.ElementType.SHAPE:
			pass
		element.ElementType.TEXT:
			pass

func _on_slider_preference_changed() -> void:
	_set_property_value_to_control()

# Update layer controls and dynamic lists.
func _on_external_options_changed(_p_element: Element) -> void:
	_on_external_options_changed_no_parameter()

func _on_external_options_changed_no_parameter() -> void:
	_update_property_configuration_dictionary()
	var property_dict: Dictionary[StringName, Variant] = element.get_property_dictionary()
	if property_dict.get(property_key) != _property_value:
		_property_value = property_dict.get(property_key)
	_set_property_value_to_control()

func _on_reset_pressed() -> void:
	_property_value = _reset_value
	_set_value_to_property(_reset_value)
	_set_property_value_to_control()
	_reset_button.hide()

func _on_button_pressed() -> void:
	_file_dialog.show()

func _on_file_selected(p_path: String) -> void:
	_set_value_to_property(p_path)

func _on_check_toggled(p_toggled_on: bool) -> void:
	if not _stop_signal:
		_set_value_to_property(p_toggled_on)

func _on_color_changed(p_color: Color) -> void:
	if not _stop_signal:
		_set_value_to_property(p_color)

func _on_line_edit_text_changed(p_text: String) -> void:
	if not _stop_signal:
		_set_value_to_property(p_text)

func _on_spin_box_value_changed(p_value: float) -> void:
	if not _stop_signal:
		_set_value_to_property(p_value)

func _on_slider_value_changed(p_value: float) -> void:
	if not _stop_signal:
		_set_value_to_property(p_value)

func _on_option_item_selected(p_index: int) -> void:
	if not _stop_signal:
		if typeof(_property_value) == TYPE_INT:
			_set_value_to_property(p_index)
		elif typeof(_property_value) == TYPE_STRING_NAME:
			var options: Array = _property_configurations.get(ElementUIConfigurations.OPTIONS)
			var new_value: StringName = options[p_index]
			_set_value_to_property(new_value)
		elif typeof(_property_value) == TYPE_STRING:
			var options: Array = _property_configurations.get(ElementUIConfigurations.OPTIONS)
			var new_value: StringName = options[p_index]
			_set_value_to_property(new_value)
		else:
			printerr("Wrong type for OptionButton.")

func _on_text_edit_text_changed(p_text: String) -> void:
	if not _stop_signal:
		_set_value_to_property(p_text)
