# Oscillody
# Copyright (C) 2025-present Akosmo

# element_properties_container.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ElementPropertiesContainer
extends VBoxContainer

var element: Element

var _ui_configurations: ElementUIConfigurations
var _property_container: PackedScene = preload("uid://bfv2ne33xxlso")

func _ready() -> void:
	#SettingsManager.slider_preference_changed.connect(_on_slider_preference_changed)
	
	ElementManager.element_created.connect(_on_number_of_layers_changed)
	ElementManager.element_deleted.connect(_on_number_of_layers_changed)
	ElementManager.property_node_visibility_changed.connect(_on_property_visibility_changed)
	
	AudioManager.stream_list_updated.connect(_on_stream_list_updated)
	
	#for property_key: StringName in _ui_configurations.get_property_configurations().keys():
		#var property_node: PanelContainer = _property_container.instantiate()
		#property_node.set_script(_element_property_container_script)
		#@warning_ignore("unsafe_property_access")
		#property_node.element = element
		#@warning_ignore("unsafe_property_access")
		#property_node.property_key = property_key
		#add_child(property_node)
	
	#match _ui_configurations:
		#preload("uid://c5noed3x5ibew"): # ElementEmptyUIConfigurations
			#for property_key: StringName in _ui_configurations.get_property_configurations().keys():
				#var property_node: PanelContainer = _property_container.instantiate()
				#add_child(property_node)
				
				#var open_parenthesis_idx: int = property_key.findn("(")
				#var property_key_substr: String
				#var _property_key_no_substr: String
				#if open_parenthesis_idx >= 0:
					#var close_parenthesis_idx: int = property_key.findn(")")
					## Also remove close parenthesis and the space afterwards.
					#property_key_substr = property_key.substr(open_parenthesis_idx, close_parenthesis_idx + 2)
					#@warning_ignore("unsafe_property_access")
					#_property_key_no_substr = property_key.replacen(property_key_substr, "")
				#else:
					#_property_key_no_substr = property_key
				#property_node.set_text(_property_key_no_substr)
		#preload("uid://blysgijw0k6ah"): # ElementAnalyzerUIConfigurations
			#pass
		#preload("uid://d22vhxv5sqx2t"): # ElementImageUIConfigurations
			#pass
		#preload("uid://ccdqa8ifs0fso"): # ElementShaderUIConfigurations
			#pass
	
	_ui_configurations = ElementManager.get_element_ui_configurations(element.get_element_type())
	
	var element_ui_configs: Dictionary[StringName, Dictionary] = _ui_configurations.get_configurations()
	
	for property_key: StringName in element_ui_configs.keys():
		
		var property_container_node: BasicPropertyContainer = _property_container.instantiate()
		#var start_time: int = Time.get_ticks_msec()
		add_child(property_container_node)
		#print(Time.get_ticks_msec() - start_time)
		# 15 ms.
		
		#var property_str: String = String(property_key)
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
		#property_container_node.property_label.set_text(property_key_no_substr)
		#property_container_node.set_name(property_key_no_substr.replacen(" ", ""))
		
		property_container_node.set_property_key(property_key)
		
		var property_configs: Dictionary = element_ui_configs.get(property_key)
		
		if property_configs.has(ElementUIConfigurations.VISIBLE):
			@warning_ignore("unsafe_cast")
			property_container_node.set_visible(property_configs.get(ElementUIConfigurations.VISIBLE) as bool)
		
		match property_configs.get(ElementUIConfigurations.CONTROL_NODE):
			ElementUIConfigurations.ControlNode.BUTTON:
				property_container_node.set_control_node(BasicPropertyContainer.ControlNode.BUTTON)
				property_container_node.use_file_dialog()
				property_container_node.button.set_text("Select Path")
				property_container_node.file_dialog.set_filters(
					PackedStringArray(["*.png, *.jpg, *.jpeg ; Supported Formats"])
				)
			ElementUIConfigurations.ControlNode.CHECK_BUTTON:
				property_container_node.set_control_node(BasicPropertyContainer.ControlNode.CHECK_BUTTON)
			ElementUIConfigurations.ControlNode.COLOR_PICKER_BUTTON:
				property_container_node.set_control_node(
					property_container_node.ControlNode.COLOR_PICKER_BUTTON
				)
			ElementUIConfigurations.ControlNode.LINE_EDIT:
				property_container_node.set_control_node(BasicPropertyContainer.ControlNode.LINE_EDIT)
			ElementUIConfigurations.ControlNode.NUMERICAL:
				property_container_node.set_control_node(BasicPropertyContainer.ControlNode.NUMERICAL)
				var _min: float = property_configs.get(ElementUIConfigurations.MINIMUM)
				var _max: float = property_configs.get(ElementUIConfigurations.MAXIMUM)
				var _step: float = property_configs.get(ElementUIConfigurations.STEP)
				var _rounded: bool = property_configs.get(ElementUIConfigurations.ROUNDED)
				property_container_node.spin_box.set_min(_min)
				property_container_node.spin_box.set_max(_max)
				property_container_node.spin_box.set_step(_step)
				property_container_node.spin_box.set_use_rounded_values(_rounded)
				@warning_ignore("return_value_discarded")
				property_container_node.custom_h_slider.configure_slider(_min, _max, _step, _rounded)
			ElementUIConfigurations.ControlNode.OPTION_BUTTON:
				property_container_node.set_control_node(BasicPropertyContainer.ControlNode.OPTION_BUTTON)
				for item: StringName in property_configs.get(ElementUIConfigurations.OPTIONS):
					property_container_node.option_button.add_item(item)
			ElementUIConfigurations.ControlNode.TEXT_EDIT:
				property_container_node.set_control_node(BasicPropertyContainer.ControlNode.TEXT_EDIT)
		
		property_container_node.property_value_changed.connect(_on_property_value_changed)
		
		if element == null:
			continue
		
		var element_properties: Dictionary[StringName, Variant] = element.get_properties()
		var property_value: Variant = element_properties.get(property_key)
		property_container_node.set_property_value_with_node(property_value)
		
		#match property_configs.get(ElementUIConfigurations.CONTROL_NODE):
			#ElementUIConfigurations.ControlNode.BUTTON:
				#pass
			#ElementUIConfigurations.ControlNode.CHECK_BUTTON:
				#@warning_ignore("unsafe_cast")
				#property_container_node.check_button.set_pressed_no_signal(property_value as bool)
			#ElementUIConfigurations.ControlNode.COLOR_PICKER_BUTTON:
				## TEST: Make sure this doesn't emit a signal.
				#property_container_node.color_picker_button.set_pick_color(property_value as Color)
			#ElementUIConfigurations.ControlNode.LINE_EDIT:
				#property_container_node.line_edit.set_text(property_value as String)
			#ElementUIConfigurations.ControlNode.NUMERICAL:
				#property_container_node.spin_box.set_value_no_signal(property_value as float)
				#property_container_node.custom_h_slider.set_value_no_signal(property_value as float)
			#ElementUIConfigurations.ControlNode.OPTION_BUTTON:
				## TEST: Make sure this doesn't emit a signal.
				#if property_container_node.option_button.get_item_count() > 0:
					#if typeof(property_value) == TYPE_INT:
						#@warning_ignore("unsafe_cast")
						#property_container_node.option_button.select(property_value as int)
					#elif typeof(property_value) == TYPE_STRING_NAME or typeof(property_value) == TYPE_STRING:
						#var options: Array = property_configs.get(ElementUIConfigurations.OPTIONS)
						#var idx: int = options.find(property_value)
						#property_container_node.option_button.select(idx)
					#else:
						#printerr("Wrong type for OptionButton.")
			#ElementUIConfigurations.ControlNode.TEXT_EDIT:
				#property_container_node.text_edit.set_text(property_value as String)
		
		var reset_value: Variant
		if property_configs.has(ElementUIConfigurations.DEFAULT_VALUE):
			reset_value = property_configs.get(ElementUIConfigurations.DEFAULT_VALUE)
			property_container_node.set_reset_value(reset_value)
	
	set_name(element.get_element_name() + "_" + str(element.get_element_unique_id()))

func get_element() -> Element:
	return element

#func _on_slider_preference_changed() -> void:
	#var element_ui_configs: Dictionary[StringName, Dictionary] = _ui_configurations.get_configurations()
	#for node: BasicPropertyContainer in get_children():
		#var property_configs: Dictionary = element_ui_configs.get(node.get_property_key())
		#if property_configs.get(ElementUIConfigurations.CONTROL_NODE) == \
		#ElementUIConfigurations.ControlNode.NUMERICAL:
			#node.spin_box.set_visible(node.custom_h_slider.is_visible())
			#node.custom_h_slider.set_visible(not node.spin_box.is_visible())

func _on_number_of_layers_changed(_p_element: Element) -> void:
	var node: BasicPropertyContainer = get_child(2) # The PropertyContainer for LAYER is always on this index.
	
	var element_ui_configs: Dictionary[StringName, Dictionary] = _ui_configurations.get_configurations()
	var property_configs: Dictionary = element_ui_configs.get(node.get_property_key())
	
	var _min: float = property_configs.get(ElementUIConfigurations.MINIMUM)
	var _max: float = property_configs.get(ElementUIConfigurations.MAXIMUM)
	var _step: float = property_configs.get(ElementUIConfigurations.STEP)
	var _rounded: bool = property_configs.get(ElementUIConfigurations.ROUNDED)
	node.spin_box.set_min(_min)
	node.spin_box.set_max(_max)
	node.spin_box.set_step(_step)
	node.spin_box.set_use_rounded_values(_rounded)
	@warning_ignore("return_value_discarded")
	node.custom_h_slider.configure_slider(_min, _max, _step, _rounded)

func _on_property_visibility_changed() -> void:
	var element_ui_configs: Dictionary[StringName, Dictionary] = _ui_configurations.get_configurations()
	for node: BasicPropertyContainer in get_children():
		var property_configs: Dictionary = element_ui_configs.get(node.get_property_key())
		if property_configs.has(ElementUIConfigurations.VISIBLE):
			node.set_visible(property_configs.get(ElementUIConfigurations.VISIBLE) as bool)

func _on_stream_list_updated() -> void:
	var element_ui_configs: Dictionary[StringName, Dictionary] = _ui_configurations.get_configurations()
	for node: BasicPropertyContainer in get_children():
		if node.get_property_key() == ElementWithAudio.SN_AUDIO_SOURCE:
			var property_configs: Dictionary = element_ui_configs.get(node.get_property_key())
			node.option_button.clear()
			#var option_idx: int = 0
			for item: StringName in property_configs.get(ElementUIConfigurations.OPTIONS):
				node.option_button.add_item(item)
			node.option_button.select(-1)
			for idx: int in node.option_button.get_item_count():
				if node.option_button.get_item_text(idx) == String(node.get_property_value()):
					node.option_button.select(idx)
					break
				#if item == node.get_property_value():
					#node.option_button.select(option_idx)
				#option_idx += 1
			#node.option_button.select(node.get_property_value() as int)

func _on_property_value_changed(p_property_key: StringName, p_property_value: Variant) -> void:
	# If I want to avoid a long `match` statement, and I also can't set properties directly,
	# this is the only way I've found to modify the property.
	if element == null:
		return
	
	#for node: BasicPropertyContainer in get_children():
		#if (
			#node.get_property_key() == p_property_key and
			#node.get_control_node() == BasicPropertyContainer.ControlNode.BUTTON
		#):
			#node.file_dialog.show()
			#return
	
	@warning_ignore("unsafe_method_access", "unsafe_cast")
	element.call(element.get_setters().get(p_property_key) as StringName, p_property_value)
