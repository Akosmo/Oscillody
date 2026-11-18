# Oscillody
# Copyright (C) 2025-present Akosmo

# element_manager.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

extends Node
## Manager class that handles [Element]s.
##
## This class handles Element creation, deletion, and other things aside from their unique properties.
## It is also used by UI objects.

## Emitted when an [Element] is created.
signal element_created(p_element: Element)
## Emitted when an [Element] is deleted.
signal element_deleted(p_element: Element)
#signal elements_cleared
## Emitted when an [Element] changes type.
signal element_type_changed(p_old_element: Element, p_new_element: Element)
## Emitted when [member Element._layer] is updated in all Elements.
signal element_layers_updated
## Emitted when one or multiple property nodes change visibility. See [ElementPropertyContainer].
signal property_node_visibility_changed(p_element: Element)

var _elements: Array[Element] # This array is sorted by layer order.
#var _element_ui_configurations: Dictionary[Element, ElementUIConfigurations]
var _element_ui_configurations_array: Array[ElementUIConfigurations]

var _element_unique_id: int

var _element_empty_ui_configurations: ElementEmptyUIConfigurations
var _element_analyzer_ui_configurations: ElementAnalyzerUIConfigurations
var _element_image_ui_configurations: ElementImageUIConfigurations
var _element_shader_ui_configurations: ElementShaderUIConfigurations
var _element_text_ui_configurations: ElementTextUIConfigurations
var _element_visual_effect_ui_configurations: ElementVisualEffectUIConfigurations

func _init() -> void:
	_element_unique_id = -1
	
	if AudioManager.stream_list_updated.connect(_on_stream_list_updated):
		push_error("Could not connect signal in ElementManager.")
	
	_element_empty_ui_configurations = preload("uid://c5noed3x5ibew")
	_element_analyzer_ui_configurations = preload("uid://blysgijw0k6ah")
	_element_image_ui_configurations = preload("uid://d22vhxv5sqx2t")
	_element_shader_ui_configurations = preload("uid://ccdqa8ifs0fso")
	_element_text_ui_configurations = preload("uid://c4nnun8qgukty")
	_element_visual_effect_ui_configurations = preload("uid://0sc0lp6palt8")

func get_elements(p_duplicate: bool) -> Array[Element]:
	if p_duplicate:
		return _elements.duplicate_deep(Resource.DeepDuplicateMode.DEEP_DUPLICATE_ALL)
	
	return _elements

## Returns the number of existing Elements.
func get_element_count() -> int:
	return _elements.size()

## Creates a new [ElementEmpty] and returns it.[br]
## The default [member Element._element_name] is [code]"Element_"[/code]
## appended to the given [member Element._unique_id].[br]
## The [member Element._layer] is set to the return value of [method get_element_count].[br]
## This should only be done by instantiating a new [ElementContainer].
func create_element() -> Element:
	var element: ElementEmpty = ElementEmpty.new()
	element.set_element_unique_id(_get_next_available_uid())
	element.set_element_name("Element_" + str(element.get_element_unique_id()))
	element.set_element_type(element.ElementType.EMPTY, true)
	element.set_element_layer(_elements.size(), false)
	element.set_element_visibility(true)
	
	_elements.append(element)
	var configs: ElementUIConfigurations = _get_configurations_basic(Element.ElementType.EMPTY)
	configs.set_element(element)
	_element_ui_configurations_array.append(configs)
	#if not _element_ui_configurations.set(element, configs):
	#	CustomLogger.log_critical_error("Could not add config to dictionary.")
	#	delete_element(element)
	#	return null
	
	CustomLogger.log_normal("Created Element with ID: " + str(element.get_element_unique_id()))
	
	element_created.emit(element)
	
	if not FileManager.get_unsaved_changes():
		FileManager.set_unsaved_changed(true)
	
	return element

func load_element(p_properties: Dictionary[StringName, Variant]) -> void:
	var old_element_array_size: int = _elements.size()
	#var old_element_ui_configs_size: int = _element_ui_configurations.size()
	var old_element_ui_configs_size: int = _element_ui_configurations_array.size()
	
	var element: Element
	match p_properties.get(Element.SN_ELEMENT_TYPE):
		Element.ElementType.EMPTY:
			element = ElementEmpty.new() as ElementEmpty
		Element.ElementType.ANALYZER:
			element = ElementAnalyzer.new() as ElementAnalyzer
		Element.ElementType.IMAGE:
			element = ElementImage.new() as ElementImage
		Element.ElementType.SHADER:
			element = ElementShader.new() as ElementShader
		Element.ElementType.TEXT:
			element = ElementText.new() as ElementText
		Element.ElementType.VISUAL_EFFECT:
			element = ElementVisualEffect.new() as ElementVisualEffect
		_:
			CustomLogger.log_warning("Unrecognized Element type. Using Empty type instead.")
			element = ElementEmpty.new() as ElementEmpty
	
	element.set_element_unique_id(_get_next_available_uid())
	element.set_element_type(p_properties.get(Element.SN_ELEMENT_TYPE as StringName), true)
	element.set_element_layer(p_properties.get(Element.SN_ELEMENT_LAYER as StringName), false)
	
	var element_properties: Dictionary[StringName, Variant] = element.get_properties()
	for property_key: StringName in element_properties.keys():
		# If file has missing information.
		if not p_properties.has(property_key):
			CustomLogger.log_warning(
				"{property} is not available in the property dictionary. Keeping its default value.".format(
					{"property": property_key}
				)
			)
	
	for property_key: StringName in p_properties.keys():
		if property_key == Element.SN_ELEMENT_TYPE or property_key == Element.SN_ELEMENT_LAYER:
			continue
		
		var element_setters: Dictionary[StringName, StringName] = element.get_setters()
		# If Element has missing information.
		if not element_setters.has(property_key):
			CustomLogger.log_warning(
				"{property} does not exist in the Element. Skipping.".format({"property": property_key})
			)
			continue
		
		#var property_str: StringName = property_key.get_slice(")_", 1).replace("_", " ").to_lower()
		#element.get_property_list()
		element.call(element_setters.get(property_key) as StringName, p_properties.get(property_key))
	
	_elements.append(element)
	var configs: ElementUIConfigurations = _get_configurations_basic(element.get_element_type())
	configs.set_element(element)
	#if not _element_ui_configurations.set(element, configs):
	#	CustomLogger.log_warning("Could not add config to dictionary.")
	_element_ui_configurations_array.append(configs)
	
	if (
		not _elements.size() == old_element_array_size + 1 or
		#not _element_ui_configurations.size() == old_element_ui_configs_size + 1
		not _element_ui_configurations_array.size() == old_element_ui_configs_size + 1
	):
		CustomLogger.log_warning(
			"Incorrect sizes for Element lists. Sizes: {1}, {2}, {3}, {4}".format(
				{
					"1": str(_elements.size()),
					"2": str(old_element_array_size + 1),
					#"3": str(_element_ui_configurations.size()),
					"3": str(_element_ui_configurations_array.size()),
					"4": str(old_element_ui_configs_size + 1)
				}
			)
		)
	
	CustomLogger.log_normal("Loaded Element with ID: " + str(element.get_element_unique_id()))
	
	element_created.emit(element)

## Deletes the given [Element].
## This automatically sets the correct [member Element._layer] of all remaining Elements.[br]
## This should only be called by pressing the delete button in an [ElementContainer].
func delete_element(p_element: Element) -> void:
	CustomLogger.log_normal("Deleting Element with ID: " + str(p_element.get_element_unique_id()))
	
	#if not _element_ui_configurations.erase(p_element):
	#	CustomLogger.log_warning("Could not find Element in config dictionary.")
	_element_ui_configurations_array.erase(get_configurations_for_element(p_element))
	_elements.erase(p_element)
	
	_update_layers()
	
	element_deleted.emit(p_element)
	
	if not FileManager.get_unsaved_changes():
		FileManager.set_unsaved_changed(true)

func clear_elements() -> void:
	CustomLogger.log_normal("Clearing Elements.")
	
	#_element_ui_configurations.clear()
	_element_ui_configurations_array.clear()
	
	for element: Element in _elements:
		element_deleted.emit(element)
	
	_elements.clear()
	
	#if not _elements.is_empty() or not _element_ui_configurations.is_empty():
	if not _elements.is_empty() or not _element_ui_configurations_array.is_empty():
		CustomLogger.log_critical_error("Could not clear Element lists properly.")
	
	#elements_cleared.emit()

## Changes the type of an [Element]. Should only be used by calling [method Element.set_type].[br]
## [b]Note:[/b] The [Element] Resource doesn't remain the same, as this method makes a new [Element]
## with the same basic property values as the given [param p_element], and deletes the old Element.
func change_element_type(p_element: Element) -> void:
	CustomLogger.log_normal("Changing type of the Element with ID: " + str(p_element.get_element_unique_id()))
	
	var new_element: Element
	match p_element.get_element_type():
		Element.ElementType.EMPTY:
			new_element = ElementEmpty.new() as ElementEmpty
		Element.ElementType.ANALYZER:
			new_element = ElementAnalyzer.new() as ElementAnalyzer
		Element.ElementType.IMAGE:
			new_element = ElementImage.new() as ElementImage
		Element.ElementType.SHADER:
			new_element = ElementShader.new() as ElementShader
		Element.ElementType.TEXT:
			new_element = ElementText.new() as ElementText
		Element.ElementType.VISUAL_EFFECT:
			new_element = ElementVisualEffect.new() as ElementVisualEffect
		_:
			CustomLogger.log_warning("Unrecognized Element type. Using Empty type instead.")
			new_element = ElementEmpty.new() as ElementEmpty
	
	new_element.set_element_unique_id(p_element.get_element_unique_id())
	new_element.set_element_name(p_element.get_element_name())
	new_element.set_element_type(p_element.get_element_type(), true)
	new_element.set_element_layer(p_element.get_element_layer(), false)
	new_element.set_element_visibility(p_element.get_element_visibility())
	
	#if not _element_ui_configurations.erase(p_element):
	#	CustomLogger.log_critical_error("Could not find Element in config dictionary.")
	_element_ui_configurations_array.erase(get_configurations_for_element(p_element))
	_elements.erase(p_element)
	
	@warning_ignore("return_value_discarded")
	_elements.insert(new_element.get_element_layer(), new_element)
	var configs: ElementUIConfigurations = _get_configurations_basic(new_element.get_element_type())
	configs.set_element(new_element)
	#if not _element_ui_configurations.set(
	#	new_element, configs
	#):
	#	CustomLogger.log_critical_error("Could not add config to dictionary.")
	_element_ui_configurations_array.append(configs)
	
	element_type_changed.emit(p_element, new_element)

## Moves the given [param p_element] to the given [param p_to_index] in the internal Element array.[br]
## Should only be used by calling [method Element.set_layer].
func reindex_layer(p_element: Element, p_to_index: int) -> void:
	if _elements.has(p_element):
		_elements.remove_at(_elements.find(p_element))
		@warning_ignore("return_value_discarded")
		_elements.insert(p_to_index, p_element)
		_update_layers()

func reset_unique_id() -> Error:
	if _elements.size():
		CustomLogger.log_critical_error("Could not reset unique IDs, since Elements still exist.")
		return Error.FAILED
	
	_element_unique_id = -1
	return Error.OK

func get_configurations_for_element(p_element: Element) -> ElementUIConfigurations:
	#return _element_ui_configurations.get(p_element)
	for config: ElementUIConfigurations in _element_ui_configurations_array:
		if config.get_element() == p_element:
			return config
	
	return null

func notify_property_node_visibility_changed(p_element: Element) -> void:
	property_node_visibility_changed.emit(p_element)

func _get_configurations_basic(p_type: Element.ElementType) -> ElementUIConfigurations:
	match p_type:
		Element.ElementType.EMPTY:
			return _element_empty_ui_configurations.duplicate_deep(Resource.DeepDuplicateMode.DEEP_DUPLICATE_ALL)
		Element.ElementType.ANALYZER:
			return _element_analyzer_ui_configurations.duplicate_deep(
				Resource.DeepDuplicateMode.DEEP_DUPLICATE_ALL
			)
		Element.ElementType.IMAGE:
			return _element_image_ui_configurations.duplicate_deep(Resource.DeepDuplicateMode.DEEP_DUPLICATE_ALL)
		Element.ElementType.SHADER:
			return _element_shader_ui_configurations.duplicate_deep(Resource.DeepDuplicateMode.DEEP_DUPLICATE_ALL)
		Element.ElementType.TEXT:
			return _element_text_ui_configurations.duplicate_deep(Resource.DeepDuplicateMode.DEEP_DUPLICATE_ALL)
		Element.ElementType.VISUAL_EFFECT:
			return _element_visual_effect_ui_configurations.duplicate_deep(
				Resource.DeepDuplicateMode.DEEP_DUPLICATE_ALL
			)
	
	CustomLogger.log_critical_error("Unknown Element type for UI configurations.")
	return _element_empty_ui_configurations

func _get_next_available_uid() -> int:
	_element_unique_id += 1
	DebugUtilities.set_element_next_unique_id(_element_unique_id + 1)
	return _element_unique_id

func _update_layers() -> void:
	for element: Element in _elements:
		element.set_element_layer(_elements.find(element), false)
	
	element_layers_updated.emit()

func _on_stream_list_updated() -> void:
	if not AudioManager.get_master_name().is_empty():
		return
	
	for element: Element in _elements:
		if element.has_method(&"set_audio_source"):
			@warning_ignore("unsafe_method_access")
			element.set_audio_source(&"")
