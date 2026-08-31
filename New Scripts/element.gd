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
## An Element is a part of a visualizer. Every Element contains: [member _unique_id],
## [member _element_name], [member _type], [member _layer], and [member _visibility].[br]
## This class is mostly a collection of data for each Element, and each Element
## is managed by [ElementManager].[br]
## [b]Note:[/b] The properties of this class are private and should not be accessed directly.
## Prefer using their setters and getters.

## Emitted whenever a property changes.
@warning_ignore("unused_signal")
signal property_changed(p_property: StringName)

## All possible Element types, used by [member _type].
enum ElementType {
	## An empty type, containing no unique data. Used whenever a new Element Resource is created.
	EMPTY,
	## An analyzer type, containing data for the display of audio analyzers, such as a waveform.
	ANALYZER,
	## An image type, containing data for the display of images.
	IMAGE,
	## A post-processing type, containing data for the display of post-processing effects.
	POST_PROCESSING,
	## A shader type, containing data for the display of shaders.
	SHADER,
	## A shape type, containing data for the display of shapes.
	SHAPE,
	## A text type, containing data for the display of text.
	TEXT
}

## [StringName]s for each Element type.
const ELEMENT_TYPES: Array[StringName] = [
	&"Empty",
	&"Analyzer",
	&"Image",
	&"Post-Processing",
	&"Shader",
	&"Shape",
	&"Text"
]

## The [StringName] for [member _unique_id].
const SN_UNIQUE_ID: StringName = &"_unique_id"
## The [StringName] for [member _element_name].
const SN_NAME: StringName = &"_element_name"
## The [StringName] for [member _type].
const SN_TYPE: StringName = &"_type"
## The [StringName] for [member _layer].
const SN_LAYER: StringName = &"_layer"
## The [StringName] for [member _visibility].
const SN_VISIBILITY: StringName = &"_visibility"

## The Element's unique identifier. Once set, it cannot be changed via the setter.[br]
## [b]Note:[/b] Use setters and getters in inheriting classes to access this property.
var _unique_id: int
## The Element's name, not relevant for the visualizer.[br]
## [b]Note:[/b] Use [method set_element_name] and [method get_element_name] to access this property.
@warning_ignore("unused_private_class_variable")
var _element_name: String
## The Element's type. See [enum ElementType].[br]
## [b]Note:[/b] Use [method set_type] and [method get_type] to access this property.
@warning_ignore("unused_private_class_variable")
var _type: ElementType
## The Element's layer, used to adjust [member CanvasLayer.layer].[br]
## [b]Note:[/b] Use [method set_layer] and [method get_layer] to access this property.
@warning_ignore("unused_private_class_variable")
var _layer: int
## The Element's visibility.[br]
## [b]Note:[/b] Use [method set_visibility] and [method get_visibility] to access this property.
@warning_ignore("unused_private_class_variable")
var _visibility: bool

var _unique_id_locked: bool = false

## Sets the unique identifier of the Element. Can only be set during initialization.
## See [method ElementManager.create_element].
func set_unique_id(p_value: int) -> void:
	if not _unique_id_locked:
		_unique_id = p_value
		_unique_id_locked = true

## Returns the unique identifier of the Element.
func get_unique_id() -> int:
	return _unique_id

## Sets the name of the Element.
func set_element_name(p_value: String) -> void:
	_element_name = p_value
	#_update_property_dictionary()
	property_changed.emit(SN_NAME)

## Returns the name of the Element.
func get_element_name() -> String:
	return _element_name

## Sets the type of the Element. If [param p_initializing] is [code]false[/code], this specific Element
## is deleted, and a new one is created in its place, with the same basic values.
## See [method ElementManager.change_element_type].
func set_type(p_value: ElementType, p_initializing: bool = false) -> void:
	_type = p_value
	#_update_property_dictionary()
	property_changed.emit(SN_TYPE)
	if not p_initializing:
		ElementManager.change_element_type(self)

## Returns the type of the Element.
func get_type() -> ElementType:
	return _type

## Sets the layer of the Element. This is called internally by [method ElementManager._update_layers]
## every time the layers of the Elements have to change. If [param p_reindex] is [code]true[/code],
## the Element is removed from [member ElementManager._elements] and inserted back at the given index
## with [param p_value].
func set_layer(p_value: int, p_reindex: bool = true) -> void:
	_layer = p_value
	#_update_property_dictionary()
	if p_reindex:
		ElementManager.reindex_layer(self, p_value)
	property_changed.emit(SN_LAYER)

## Returns the layer of the Element.
func get_layer() -> int:
	return _layer

## Sets the visibility of the Element.
func set_visibility(p_value: bool) -> void:
	_visibility = p_value
	#_update_property_dictionary()
	property_changed.emit(SN_VISIBILITY)

## Returns the visibility of the Element.
func get_visibility() -> bool:
	return _visibility

## Abstract method which returns a dictionary of all the Element's properties.
@abstract func get_property_dictionary() -> Dictionary[StringName, Variant]

## Abstract method which returns a dictionary of all the Element's methods,
## with each method being a [StringName], which can be called with [method Object.call].
@abstract func get_method_dictionary() -> Dictionary[StringName, StringName]

#func get_property_configurations() -> Dictionary[StringName, PropertyConfigurations]:
	#return _property_configurations
#
#func get_element_name_configurations() -> PropertyConfigurations:
	#var configs: PropertyConfigurations = PropertyConfigurations.new()
	#configs.set_control_node(PropertyConfigurations.ControlNode.LINE_EDIT)
	#configs.set_default_value("Element_" + str(get_unique_id()))
	#
	#return configs
#
#func get_type_configurations() -> PropertyConfigurationsOptions:
	#var configs: PropertyConfigurationsOptions = PropertyConfigurationsOptions.new()
	#configs.set_control_node(PropertyConfigurations.ControlNode.OPTION_BUTTON)
	#configs.set_default_value(ElementType.EMPTY)
	#configs.set_options(ELEMENT_TYPES)
	#
	#return configs
#
#func get_layer_configurations() -> PropertyConfigurationsNumerical:
	#var configs: PropertyConfigurationsNumerical = PropertyConfigurationsNumerical.new()
	#configs.set_control_node(PropertyConfigurations.ControlNode.NUMERICAL)
	#configs.set_minimum(0.0)
	#configs.set_maximum(ElementManager.get_element_count() - 1)
	#configs.set_step(1.0)
	#configs.set_rounded(true)
	#
	#return configs
#
#func get_visibility_configurations() -> PropertyConfigurations:
	#var configs: PropertyConfigurations = PropertyConfigurations.new()
	#configs.set_control_node(PropertyConfigurations.ControlNode.CHECK_BUTTON)
	#configs.set_default_value(true)
	#
	#return configs
