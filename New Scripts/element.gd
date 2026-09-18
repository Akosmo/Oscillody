# Oscillody
# Copyright (C) 2025-present Akosmo

# element.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

@abstract
class_name Element
extends Resource
## Abstract base class for Element resources.
##
## An Element is a part of a visualizer. Every Element contains: [member _element_unique_id],
## [member _element_name], [member _element_type], [member _element_layer],
## and [member _element_visibility].[br]
## This class is mostly a collection of data for each Element, and each Element
## is managed by [ElementManager].[br]
## [b]Note:[/b] The properties of this class are private and should not be accessed directly.
## Prefer using their setters and getters.

## Emitted whenever a property changes.
@warning_ignore("unused_signal")
signal property_changed(p_property: StringName)

## All possible Element types, used by [member _element_type].
enum ElementType {
	## An empty type, containing no unique data. Used whenever a new Element Resource is created.
	EMPTY,
	## An analyzer type, containing data for the display of audio analyzers, such as a waveform.
	ANALYZER,
	## An image type, containing data for the display of images.
	IMAGE,
	## A shader type, containing data for the display of shaders.
	SHADER,
	## A text type, containing data for the display of text.
	TEXT,
	## A visual effect type, containing data for the display of visual effect effects.
	VISUAL_EFFECT
}

## [StringName]s for each Element type.
const ELEMENT_TYPES: Array[StringName] = [
	&"Empty",
	&"Analyzer",
	&"Image",
	&"Shader",
	&"Text",
	&"Visual Effect"
]

## The [StringName] for [member _element_unique_id].
const SN_ELEMENT_UNIQUE_ID: StringName = &"(Element)_Unique_ID"
## The [StringName] for [member _element_name].
const SN_ELEMENT_NAME: StringName = &"(Element)_Name"
## The [StringName] for [member _element_type].
const SN_ELEMENT_TYPE: StringName = &"(Element)_Type"
## The [StringName] for [member _element_layer].
const SN_ELEMENT_LAYER: StringName = &"(Element)_Layer"
## The [StringName] for [member _element_visibility].
const SN_ELEMENT_VISIBILITY: StringName = &"(Element)_Visibility"

## The Element's unique identifier. Once set, it cannot be changed via the setter.[br]
## [b]Note:[/b] Use setters and getters in inheriting classes to access this property.
var _element_unique_id: int
## The Element's name, not relevant for the visualizer.[br]
## [b]Note:[/b] Use [method set_element_name] and [method get_element_name] to access this property.
@warning_ignore("unused_private_class_variable")
var _element_name: String
## The Element's type. See [enum ElementType].[br]
## [b]Note:[/b] Use [method set_element_type] and [method get_element_type] to access this property.
@warning_ignore("unused_private_class_variable")
var _element_type: ElementType
## The Element's layer, used to adjust [member CanvasLayer.layer].[br]
## [b]Note:[/b] Use [method set_element_layer] and [method get_element_layer] to access this property.
@warning_ignore("unused_private_class_variable")
var _element_layer: int
## The Element's visibility.[br]
## [b]Note:[/b] Use [method set_element_visibility] and
## [method get_element_visibility] to access this property.
@warning_ignore("unused_private_class_variable")
var _element_visibility: bool

var _unique_id_locked: bool = false

## Sets the unique identifier of the Element. Can only be set during initialization.
## See [method ElementManager.create_element].
func set_element_unique_id(p_value: int) -> void:
	if not _unique_id_locked:
		_element_unique_id = p_value
		_unique_id_locked = true

## Returns the unique identifier of the Element.
func get_element_unique_id() -> int:
	return _element_unique_id

## Sets the name of the Element.
func set_element_name(p_value: String) -> void:
	_element_name = p_value
	property_changed.emit(SN_ELEMENT_NAME)

## Returns the name of the Element.
func get_element_name() -> String:
	return _element_name

## Sets the type of the Element. If [param p_initializing] is [code]false[/code], this specific Element
## is deleted, and a new one is created in its place, with the same basic values.
## See [method ElementManager.change_element_type].
func set_element_type(p_value: ElementType, p_initializing: bool = false) -> void:
	_element_type = p_value
	property_changed.emit(SN_ELEMENT_TYPE)
	if not p_initializing:
		ElementManager.change_element_type(self)

## Returns the type of the Element.
func get_element_type() -> ElementType:
	return _element_type

## Sets the layer of the Element. This is called internally by [method ElementManager._update_layers]
## every time the layers of the Elements have to change. If [param p_reindex] is [code]true[/code],
## the Element is removed from [member ElementManager._elements] and inserted back at the given index
## with [param p_value].
func set_element_layer(p_value: int, p_reindex: bool = true) -> void:
	_element_layer = p_value
	if p_reindex:
		ElementManager.reindex_layer(self, p_value)
	property_changed.emit(SN_ELEMENT_LAYER)

## Returns the layer of the Element.
func get_element_layer() -> int:
	return _element_layer

## Sets the visibility of the Element.
func set_element_visibility(p_value: bool) -> void:
	_element_visibility = p_value
	property_changed.emit(SN_ELEMENT_VISIBILITY)

## Returns the visibility of the Element.
func get_element_visibility() -> bool:
	return _element_visibility

## Abstract method which returns a dictionary of all the Element's properties.
## [b]Note:[/b] This does not include [member _unique_id].
@abstract func get_properties() -> Dictionary[StringName, Variant]

## Abstract method which returns a dictionary of all the Element's setter methods,
## with each method being a [StringName], which can be called with [method Object.call].
## [b]Note:[/b] This does not include [method set_unique_id].
@abstract func get_setters() -> Dictionary[StringName, StringName]
