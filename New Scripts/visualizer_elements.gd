# Oscillody
# Copyright (C) 2025-present Akosmo

# visualizer_elements.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

# TODO: Refactor this class once the element system is fully figured out and functional.

class_name VisualizerElements
extends Node
## Base class for elements.
##
## Elements are the parts of a visualizer. This class can be used to create, modify,
## and delete elements and properties.[br]
## Most methods in this class interact with [member _elements], and triggers [signal elements_updated].[br]
## UI controls and preset files set values. Elements get values from this class.

## Emitted whenever [member _elements] is modified, and triggers relevant changes to the visualizer.
signal elements_updated

## Base type for elements.
enum ElementType {
	## An empty element. Only contains [constant NAME],
	## [constant TYPE], and [constant LAYER] as properties.
	## Used when an element is created.
	EMPTY = -1,
	## An audio analyzer element, such as a waveform. Must be linked to an audio track to work.
	ANALYZER,
	## A 2-point gradient element.
	GRADIENT,
	## An image element.
	IMAGE,
	## A post-processing element.
	POST_PROCESSING,
	## A shader element.
	SHADER,
	## A shape element.
	SHAPE,
	## A solid color element.
	SOLID_COLOR,
	## A text element.
	TEXT
}

const NAME: StringName = &"Name"
const TYPE: StringName = &"Type"
const LAYER: StringName = &"Layer"
const VISIBILITY: StringName = &"Visibility" # Use this.

# TODO: Also make a public method to return a ControlNode value to be used by PropertyContainer.
# This method should check a given property's key and type of the value.
enum ControlNode {
	BUTTON,
	CHECK_BUTTON,
	COLOR_PICKER_BUTTON,
	LINE_EDIT,
	NONE,
	NUMERICAL,
	OPTION_BUTTON,
	TEXT_EDIT
}

## Holds all elements of the visualizer, along with their properties.
## Whenever modified, [signal elements_updated] is emitted.[br]
## [b]Note:[/b] This member should [b]NOT[/b] be accessed directly.
static var _elements: Dictionary[int, Dictionary]

## The unique ID (UID) for the last created element during run-time.
## Initializes at [code]-1[/code], but first created element will have an UID of [code]0[/code].
static var _element_uid: int = -1

## The UID of the element currently selected to show its properties in the UI.
## This will be used if instances of properties won't be created and deleted every time and element is selected.
## @experimental
static var _selected_element: int = _element_uid

func _init() -> void:
	var err_updated_elements: Error = elements_updated.connect(_updated_elements) as Error
	if err_updated_elements:
		printerr("Could not connect \"_updated_elements\" signal.")

## Returns a deep copy of [member _elements].
func get_elements() -> Dictionary[int, Dictionary]:
	return _elements.duplicate_deep(Resource.DeepDuplicateMode.DEEP_DUPLICATE_ALL)

## Alias for [method set_element_properties],
## internally creates a property dictionary with
## [code]"Empty_"[/code] appended with the next available UID,
## [constant ElementType.EMPTY], and the next available layer,
## for [constant NAME], [constant TYPE], and [constant LAYER], respectively.[br]
## Returns the unique ID for the created element. If element could not be created, returns [code]-1[/code].
func create_element() -> int:
	var err: Error = set_element_properties(
		_get_available_uid(),
		{
			NAME: _get_available_name(),
			TYPE: ElementType.EMPTY,
			LAYER: _get_available_layer(),
			VISIBILITY: true
		} as Dictionary[StringName, Variant]
	)
	if err:
		return -1
	
	return _element_uid

## Alias for [method set_element_properties],
## internally uses an empty property dictionary for deletion.
func delete_element(p_uid: int) -> Error:
	var empty_dict: Dictionary[StringName, Variant] = {}
	if not element_exists(p_uid):
		return FAILED
	
	return set_element_properties(p_uid, empty_dict)

## Checks if the element [param p_uid] exists.
func element_exists(p_uid: int) -> bool:
	if not _is_valid_uid(p_uid):
		return false
	
	if not _elements.has(p_uid):
		return false
	
	return true

## Sets a property dictionary to element [param p_uid]. Deletes the element if [param p_properties] is empty.
## If that's the purpose, consider using [method delete_element]. See also [method create_element].[br]
## [b]Note:[/b] [param p_properties] should have the correct type, even if it's empty.
func set_element_properties(p_uid: int, p_properties: Dictionary[StringName, Variant]) -> Error:
	if not _is_element_property_dict_valid(p_properties, false):
		return FAILED
	
	if element_exists(p_uid) and _is_null_or_empty(_elements.get(p_uid)):
		print("Warning: Element already has properties. Setting anyway.")
	
	if _is_null_or_empty(p_properties):
		var err_bool: bool = _elements.erase(p_uid)
		if not err_bool:
			printerr("Could not delete \"{UID}\" element".format({"UID": p_uid}))
			return FAILED
		var err: Error = _ensure_gapless_layers()
		if err:
			printerr("Could not ensure gapless layers.")
			return FAILED
	else:
		if not _is_element_property_dict_valid(p_properties):
			return FAILED
		var err_bool: bool = _elements.set(p_uid, p_properties)
		if not err_bool:
			printerr("Could not set to \"{UID}\" element".format({"UID": p_uid}))
			return FAILED
	
	elements_updated.emit()
	
	return OK

## Returns the property dictionary for element [param p_uid].[br]
## [b]Note:[/b] If [param p_uid] does not exist, returns an empty dictionary.
func get_element_properties(p_uid: int) -> Dictionary[StringName, Variant]:
	var r_dict: Dictionary[StringName, Variant] = {}
	
	if not element_exists(p_uid):
		return r_dict
	
	return _elements.get(p_uid, r_dict)

## Sets the [param p_property] of [param p_element] to [param p_value].
## See also [method get_element_properties].
func set_element_property(p_element: int, p_property: StringName, p_value: Variant) -> Error:
	#if not property_exists(p_element, p_property):
		#return FAILED
	#if p_property == NAME and _is_null_or_empty(p_value):
		#printerr("Name can not be empty.")
		#return FAILED
	
	var element: Dictionary[StringName, Variant] = _elements.get(p_element)
	var err_bool: bool = element.set(p_property, p_value)
	if not err_bool:
		printerr(
			"Can't set property {property} with value {value} in {element}.".format(
				{"property": p_property, "value": p_value, "element": p_element}
			)
		)
		return FAILED
	
	elements_updated.emit()
	
	return OK

## Returns the value of [param p_property] of [param  p_element]. See also [method property_exists].[br]
## [b]Note:[/b] if property does not exist, returns [code]null[/code].
func get_element_property(p_element: int, p_property: StringName) -> Variant:
	if not property_exists(p_element, p_property):
		return null
	
	var element: Dictionary[StringName, Variant] = _elements.get(p_element)
	
	return element.get(p_property)

# TODO: Might be incorrect?
## Checks if the property [param p_name] exists in [param p_element].
func property_exists(p_element: int, p_name: StringName) -> bool:
	if not element_exists(p_element):
		return false
	if not _is_valid_name(p_name):
		return false
	var element: Dictionary[StringName, Variant] = _elements.get(p_element)
	if not element.has(p_name):
		printerr("\"{name}\" does not exist in \"{element}\".".format({"name": p_name, "element": p_element}))
		return false
	
	return true

func get_control_node_for_property(p_element_uid: int, p_property: StringName) -> ControlNode:
	match typeof(get_element_property(p_element_uid, p_property)):
		TYPE_BOOL:
			return ControlNode.CHECK_BUTTON
		TYPE_INT:
			if p_property == TYPE:
				return ControlNode.OPTION_BUTTON
			else:
				return ControlNode.NUMERICAL
		TYPE_FLOAT:
			return ControlNode.NUMERICAL
		TYPE_STRING:
			if p_property == NAME:
				return ControlNode.LINE_EDIT
			else:
				return ControlNode.TEXT_EDIT
		TYPE_COLOR:
			return ControlNode.COLOR_PICKER_BUTTON
		_:
			return ControlNode.NONE

# TODO: Sort all these private helper methods, based on the order they appear,
# or alphabetical (easier to maintain).

## Returns the next available unique ID for [member _elements].
func _get_available_uid() -> int:
	_element_uid += 1
	return _element_uid

## Returns the next available default name. [b]Must[/b] be used after [method _get_available_uid] is called.
func _get_available_name() -> String:
	return "Empty_" + str(_element_uid)

## Returns the next available layer number.
func _get_available_layer() -> int:
	var max_layer: int = -1
	for dict: Dictionary[StringName, Variant] in _elements.values():
		if dict.has(LAYER) and dict.get(LAYER) > max_layer:
			max_layer = dict.get(LAYER)
		else:
			printerr("Property dictionary has no LAYER key.")
			return -1
	
	if _elements.keys().size() - 1 < max_layer:
		var err: Error = _ensure_gapless_layers()
		if err:
			printerr("Could not ensure gapless layers.")
			return -1
	
	return _elements.size()

## Ensures the element dictionary has no gaps in regards to layers.
func _ensure_gapless_layers() -> Error:
	var all_layers: Array[int]
	for dict: Dictionary[StringName, Variant] in _elements.values():
		if dict.has(LAYER):
			all_layers.append(dict.get(LAYER))
	
	var all_layers_sorted: Array[int] = all_layers.duplicate()
	all_layers_sorted.sort()
	
	for dict: Dictionary[StringName, Variant] in _elements.values():
		if dict.has(LAYER):
			var err_bool: bool = dict.set(LAYER, all_layers_sorted.find(dict.get(LAYER)))
			if not err_bool:
				return FAILED
	
	return OK

## Checks if a property dictionary is valid, by checking its type.
## If [param full_check] is [code]true[/code], keys are also checked, to an extent.
func _is_element_property_dict_valid(
	p_properties: Dictionary[StringName, Variant], full_check: bool = true
) -> bool:
	if p_properties is not Dictionary[StringName, Variant]:
		printerr("Given dictionary is not the correct type.")
		return false
	if full_check:
		if not p_properties.has(NAME):
			printerr("NAME key does not exist.")
			return false
		else:
			if not _is_valid_builtin_type(p_properties.get(NAME), TYPE_STRING):
				printerr("NAME key is not a String.")
				return false
			else:
				@warning_ignore("unsafe_method_access")
				if p_properties.get(NAME).is_empty():
					printerr("NAME key is empty.")
					return false
		if not p_properties.has(TYPE):
			printerr("TYPE key does not exist.")
			return false
		else:
			if p_properties.get(TYPE) is not ElementType:
				printerr("TYPE key is not an ElementType.")
				return false
		if not p_properties.has(LAYER):
			printerr("LAYER key does not exist.")
			return false
		else:
			if not _is_valid_builtin_type(p_properties.get(LAYER), TYPE_INT):
				printerr("LAYER key is not an int.")
				return false
			else:
				if p_properties.get(LAYER) < 0:
					printerr("LAYER key is invalid.")
					return false
		
		for key: StringName in p_properties.keys():
			if _is_null_or_empty(key):
				printerr("A property key is null.")
				return false
			if p_properties.get(key) == null:
				printerr("A property ")
				return false
	
	return true

## Checks if [param p_uid] is valid for elements.
func _is_valid_uid(p_uid: int) -> bool:
	if not _is_valid_builtin_type(p_uid, TYPE_INT):
		return false
	
	if _is_null_or_empty(p_uid):
		printerr("{UID} is empty.".format({"uid": p_uid}))
		return false
	
	return true

## Checks if [param p_name] is valid for properties.
func _is_valid_name(p_name: StringName) -> bool:
	if not _is_valid_builtin_type(p_name, TYPE_STRING_NAME):
		return false
	
	if _is_null_or_empty(p_name):
		printerr("{name} is empty.".format({"name": p_name}))
		return false
	
	return true

#TODO: Eventually put this in some utility file.
#TODO: Try `if p_value is not p_expect:`
## Checks if a value is of the expected built-in type.
func _is_valid_builtin_type(p_value: Variant, p_expect: Variant.Type) -> bool:
	if typeof(p_value) != p_expect:
		printerr("\"{value}\" is not {type}.".format({"value": p_value, "type": type_string(p_expect)}))
		return false
	
	return true

#TODO: Eventually put this in some utility file.
#TODO: With this one and similar methods, consider moving the error messages out of it.
## Checks if a value is null or empty.
func _is_null_or_empty(p_var: Variant) -> bool:
	match typeof(p_var):
		TYPE_DICTIONARY, TYPE_STRING, TYPE_STRING_NAME, TYPE_ARRAY:
			@warning_ignore("unsafe_method_access")
			if p_var.is_empty():
				return true
	if p_var == null:
		return true
	
	return false

## Prints [member _elements].
## @experimental: Debug only.
func _updated_elements() -> void:
	print(get_elements())
