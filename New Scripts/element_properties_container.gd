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

const _PROPERTY_CONTAINER: PackedScene = preload("uid://bfv2ne33xxlso")

var element: Element

var _ui_configurations: ElementUIConfigurations

func _ready() -> void:
	ElementManager.element_created.connect(_on_number_of_layers_changed)
	ElementManager.element_deleted.connect(_on_number_of_layers_changed)
	ElementManager.element_layers_updated.connect(_on_layers_updated)
	ElementManager.property_node_visibility_changed.connect(_on_property_visibility_changed)
	
	AudioManager.stream_list_updated.connect(_on_stream_list_updated)
	
	_ui_configurations = ElementManager.get_configurations_for_element(element)
	
	var element_ui_configs: Dictionary[StringName, Dictionary] = _ui_configurations.get_configurations()
	
	for property_key: StringName in element_ui_configs.keys():
		var property_configs: Dictionary = element_ui_configs.get(property_key)
		if not property_configs.has(ElementUIConfigurations.CONTROL_NODE):
			CustomLogger.log_warning(
				"{property_key} does not have the Control Node key.".format({"property_key": property_key})
			)
			continue
		
		var property_container_node: BasicPropertyContainer = _PROPERTY_CONTAINER.instantiate()
		add_child(property_container_node)
		
		property_container_node.set_property_key(property_key)
		
		if property_configs.has(ElementUIConfigurations.VISIBLE):
			property_container_node.set_visible(property_configs.get(ElementUIConfigurations.VISIBLE) as bool)
		
		match property_configs.get(ElementUIConfigurations.CONTROL_NODE):
			ElementUIConfigurations.ControlNode.BUTTON:
				property_container_node.set_control_node(BasicPropertyContainer.ControlNode.BUTTON)
				property_container_node.use_file_dialog()
				property_container_node.button.set_text("Select Path")
				if property_key == ElementImage.SN_IMAGE_PATH:
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
			ElementUIConfigurations.ControlNode.OPTION_BUTTON:
				property_container_node.set_control_node(BasicPropertyContainer.ControlNode.OPTION_BUTTON)
				for item: StringName in property_configs.get(ElementUIConfigurations.OPTIONS):
					if property_key == ElementWithAudio.SN_AUDIO_SOURCE:
						property_container_node.option_button.add_item(item)
					else:
						property_container_node.option_button.add_item(item.get_slice(")_", 1).replace("_", " "))
			ElementUIConfigurations.ControlNode.TEXT_EDIT:
				property_container_node.set_control_node(BasicPropertyContainer.ControlNode.TEXT_EDIT)
		
		property_container_node.property_value_changed.connect(_on_property_value_changed)
		
		if element == null:
			continue
		
		var element_properties: Dictionary[StringName, Variant] = element.get_properties()
		var property_value: Variant = element_properties.get(property_key)
		property_container_node.set_property_value_with_node(property_value)
		
		var reset_value: Variant
		if property_configs.has(ElementUIConfigurations.DEFAULT_VALUE):
			reset_value = property_configs.get(ElementUIConfigurations.DEFAULT_VALUE)
			property_container_node.set_reset_value(reset_value)
	
	set_name(element.get_element_name() + "_" + str(element.get_element_unique_id()))

func get_element() -> Element:
	return element

func _on_number_of_layers_changed(_p_element: Element) -> void:
	if is_queued_for_deletion():
		return
	
	# The PropertyContainer for LAYER is always on this index.
	var node: BasicPropertyContainer = get_child(2)
	
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
	
	var element_properties: Dictionary[StringName, Variant] = element.get_properties()
	var property_value: int = element_properties.get(Element.SN_ELEMENT_LAYER)
	node.set_property_value_with_node(property_value)

func _on_layers_updated() -> void:
	if is_queued_for_deletion():
		return
	
	# The PropertyContainer for LAYER is always on this index.
	var node: BasicPropertyContainer = get_child(2)
	var element_properties: Dictionary[StringName, Variant] = element.get_properties()
	var property_value: int = element_properties.get(Element.SN_ELEMENT_LAYER)
	node.set_property_value_with_node(property_value)

func _on_property_visibility_changed(p_element: Element) -> void:
	if p_element != element:
		return
	
	var element_ui_configs: Dictionary[StringName, Dictionary] = _ui_configurations.get_configurations()
	for node: BasicPropertyContainer in get_children():
		var property_configs: Dictionary = element_ui_configs.get(node.get_property_key())
		if property_configs.has(ElementUIConfigurations.VISIBLE):
			node.set_visible(property_configs.get(ElementUIConfigurations.VISIBLE) as bool)

func _on_stream_list_updated() -> void:
	var element_ui_configs: Dictionary[StringName, Dictionary] = _ui_configurations.get_configurations()
	if not element_ui_configs.has(ElementWithAudio.SN_AUDIO_SOURCE):
		return
	
	var property_configs: Dictionary = element_ui_configs.get(ElementWithAudio.SN_AUDIO_SOURCE)
	for node: BasicPropertyContainer in get_children():
		if node.get_property_key() == ElementWithAudio.SN_AUDIO_SOURCE:
			node.option_button.clear()
			for item: StringName in property_configs.get(ElementUIConfigurations.OPTIONS):
				node.option_button.add_item(item)
			node.set_property_value_with_node(element.get_audio_source())

func _on_property_value_changed(p_property_key: StringName, p_property_value: Variant) -> void:
	if is_queued_for_deletion():
		return
	
	if element == null:
		return
	
	if not FileManager.get_unsaved_changes():
		FileManager.set_unsaved_changed(true)
	
	var setters_dict: Dictionary[StringName, StringName] = element.get_setters()
	if not setters_dict.has(p_property_key):
		return
	
	element.call(setters_dict.get(p_property_key) as StringName, p_property_value)
