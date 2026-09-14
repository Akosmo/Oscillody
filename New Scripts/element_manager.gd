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
## Emitted when an [Element] changes type.
signal element_type_changed(p_element: Element)
## Emitted when [member Element._layer] is updated in all Elements.
signal element_layers_updated
## Emitted when one or multiple property nodes change visibility. See [ElementPropertyContainer].
signal property_node_visibility_changed

var _elements: Array[Element] # This array is sorted by layer order.

var _element_unique_id: int = -1

var _element_empty_ui_configurations: ElementEmptyUIConfigurations
var _element_analyzer_ui_configurations: ElementAnalyzerUIConfigurations
var _element_image_ui_configurations: ElementImageUIConfigurations
var _element_shader_ui_configurations: ElementShaderUIConfigurations
#var _element_text_ui_configurations: ElementTextUIConfigurations
#var _element_visual_effect_ui_configurations: ElementVisualEffectUIConfigurations

func _init() -> void:
	if AudioManager.stream_list_updated.connect(_on_stream_list_updated):
		printerr("Could not connect signal.")
	
	_element_empty_ui_configurations = preload("uid://c5noed3x5ibew")
	_element_analyzer_ui_configurations = preload("uid://blysgijw0k6ah")
	_element_image_ui_configurations = preload("uid://d22vhxv5sqx2t")
	_element_shader_ui_configurations = preload("uid://ccdqa8ifs0fso")

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
	element.set_unique_id(_get_next_available_uid())
	element.set_element_name("Element_" + str(element.get_unique_id()))
	element.set_type(element.ElementType.EMPTY, true)
	element.set_layer(_elements.size(), false)
	element.set_visibility(true)
	
	_elements.append(element)
	
	element_created.emit(element)
	
	return element

## Deletes the given [Element].
## This automatically sets the correct [member Element._layer] of all remaining Elements.[br]
## This should only be called by pressing the delete button in an [ElementContainer].
func delete_element(p_element: Element) -> void:
	_elements.erase(p_element)
	
	_update_layers()
	
	element_deleted.emit(p_element)

## Changes the type of an [Element]. Should only be used by calling [method Element.set_type].[br]
## [b]Note:[/b] The [Element] Resource doesn't remain the same, as this method makes a new [Element]
## with the same basic property values as the given [param p_element], and deletes the old Element.
func change_element_type(p_element: Element) -> void:
	var new_element: Element
	match p_element.get_type():
		p_element.ElementType.EMPTY:
			new_element = ElementEmpty.new() as ElementEmpty
		p_element.ElementType.ANALYZER:
			new_element = ElementAnalyzer.new() as ElementAnalyzer
		p_element.ElementType.IMAGE:
			new_element = ElementImage.new() as ElementImage
		p_element.ElementType.SHADER:
			new_element = ElementShader.new() as ElementShader
		p_element.ElementType.TEXT:
			pass
			#new_element = ElementText.new() as ElementText
		p_element.ElementType.VISUAL_EFFECT:
			pass
			#new_element = ElementVisualEffect.new() as ElementVisualEffect
	
	new_element.set_unique_id(p_element.get_unique_id())
	new_element.set_element_name(p_element.get_element_name())
	new_element.set_type(p_element.get_type(), true)
	new_element.set_layer(p_element.get_layer(), false)
	new_element.set_visibility(p_element.get_visibility())
	
	_elements.erase(p_element)
	
	@warning_ignore("return_value_discarded")
	_elements.insert(new_element.get_layer(), new_element)
	element_type_changed.emit(new_element)

## Moves the given [param p_element] to the given [param p_to_index] in the internal Element array.[br]
## Should only be used by calling [method Element.set_layer].
func reindex_layer(p_element: Element, p_to_index: int) -> void:
	_elements.remove_at(_elements.find(p_element))
	@warning_ignore("return_value_discarded")
	_elements.insert(p_to_index, p_element)
	_update_layers()

func get_element_ui_configurations(p_type: Element.ElementType) -> ElementUIConfigurations:
	match p_type:
		Element.ElementType.EMPTY:
			return _element_empty_ui_configurations
		Element.ElementType.ANALYZER:
			return _element_analyzer_ui_configurations
		Element.ElementType.IMAGE:
			return _element_image_ui_configurations
		Element.ElementType.SHADER:
			return _element_shader_ui_configurations
		Element.ElementType.TEXT:
			pass
			#new_element = ElementText.new() as ElementText
		Element.ElementType.VISUAL_EFFECT:
			pass
			#new_element = ElementVisualEffect.new() as ElementVisualEffect
	
	printerr("Unknown type.")
	return _element_empty_ui_configurations

func notify_property_node_visibility_changed() -> void:
	property_node_visibility_changed.emit()

func _on_stream_list_updated() -> void:
	if not AudioManager.get_master_name().is_empty():
		return
	
	for element: Element in _elements:
		if element.has_method(&"set_audio_source"):
			@warning_ignore("unsafe_method_access")
			element.set_audio_source(&"")

func _get_next_available_uid() -> int:
	_element_unique_id += 1
	return _element_unique_id

func _update_layers() -> void:
	for element: Element in _elements:
		element.set_layer(_elements.find(element), false)
	
	element_layers_updated.emit()
