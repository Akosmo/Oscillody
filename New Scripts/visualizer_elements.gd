# Oscillody
# Copyright (C) 2025-present Akosmo

# visualizer_elements.gd is part of Oscillody. Unless specified otherwise, it is under the license below:

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
## Most methods in this class interact with [member _elements], and triggers [signal update_visualizer].[br]
## UI controls and preset files set values. Elements get values from this class.

## Emitted whenever [member _elements] is modified, and triggers relevant changes to the visualizer.
signal update_visualizer

## Holds all elements of the visualizer, along with their properties.
## Whenever modified, [signal update_visualizer] is emitted.[br]
## [b]Note:[/b] This member should [b]NOT[/b] be accessed directly.
static var _elements: Dictionary[StringName, Dictionary]

## Base type for elements.
enum ElementType {
	## An audio analyzer element, such as a waveform. Must be linked to [constant AUDIO] to work.
	ANALYZER,
	## An audio element. Used for analyzers, reaction, and most importantly, Making the visualizer work.
	AUDIO,
	## A background element, such as images, gradients, and shaders.
	BACKGROUND,
	## An empty element. Only contains [constant TYPE] and [constant LAYER] as part of its properties.
	## Used when an element is created.
	EMPTY = -1,
	## A foreground element, such as images, shapes, and post-processing effects.
	FOREGROUND = 3,
	## A text element.
	TEXT = 4
}

#TODO: Add more.
## Key name for the element's type.
const TYPE: StringName = &"Type"
## Key name for the element's layer.
const LAYER: StringName = &"Layer"
## Key name for the element's visibility.
const VISIBILITY: StringName = &"Visibility"
## Key name for the element's position.
const POSITION: StringName = &"Position"
## Key name for the element's size.
const SIZE: StringName = &"Size"
## Key name for the element's scale.
const SCALE: StringName = &"Scale"
## Key name for the element's color.
const COLOR: StringName = &"Color"
## Key name for the element's speed.
const SPEED: StringName = &"Speed"

func _init() -> void:
	var err_updated_elements: Error = update_visualizer.connect(_updated_elements) as Error
	if err_updated_elements:
		printerr("Could not connect \"_updated_elements\" signal.")

## Returns a deep copy of [member _elements].
func get_elements() -> Dictionary[StringName, Dictionary]:
	return _elements.duplicate_deep(Resource.DeepDuplicateMode.DEEP_DUPLICATE_ALL)

func get_element_keys_sorted() -> Array[StringName]:
	var r_dict: Array[StringName] = _elements.keys()
	# Better sorting. Array element `a` is compared to `b` and put behind if less than 0 (returns a `true`).
	# Behavior of `sort()`: "1, 10, 11, 12...19, 2, 20, 21...".
	r_dict.sort_custom(func(a: StringName, b: StringName) -> bool: return a.naturalnocasecmp_to(b) < 0)
	return r_dict

## Alias for [method set_element_properties],
## internally creates a property dictionary with [constant ElementType.EMPTY] and the next available layer.
func create_element() -> void:
	set_element_properties(
		_get_available_name(),
		{TYPE: ElementType.EMPTY, LAYER: _get_available_layer()} as Dictionary[StringName, Variant]
	)

## Alias for [method set_element_properties],
## internally uses an empty property dictionary for deletion.
func delete_element(p_name: StringName) -> void:
	var empty_dict: Dictionary[StringName, Variant] = {}
	if not element_exists(p_name):
		return
	set_element_properties(p_name, empty_dict)

# TODO: Account for layer prefix.
## Sets the name of element [param p_from] to [param p_to]. Can be used to rename an element.
func set_element_name(p_from: StringName, p_to: StringName) -> void:
	if not element_exists(p_from):
		return
	if not _is_valid_builtin_type(p_to, TYPE_STRING_NAME):
		return
	if _is_null_or_empty(p_to):
		return
	
	var err: Error = _rename_element(p_from, p_to)
	if err:
		printerr("Could not set element name.")
	
	update_visualizer.emit()

## Checks if the element [param p_name] exists.
func element_exists(p_name: StringName) -> bool:
	if not _is_valid_name(p_name):
		return false
	
	if not _elements.has(p_name):
		print("Warning: Element \"{name}\" does not exist.".format({"name": p_name}))
		return false
	
	return true

## Creates an element property dictionary. Must contain at least a valid [param p_type].
## This method should be used when creating a new element, or setting an existing element's value.[br]
## [b]Note:[/b] This method returns an empty dictionary if there is an error.
## @deprecated: Call [method create_element].
func create_property_dictionary(
	p_type: ElementType,
	p_other: Dictionary[StringName, Variant] = {}
) -> Dictionary[StringName, Variant]:
	var r_dict: Dictionary[StringName, Variant] = {}
	
	if p_type is not ElementType:
		printerr("Invalid type ({type}).".format({"type": p_type}))
		return r_dict
	
	if not _is_element_property_dict_valid(p_other, false):
		return r_dict
	
	r_dict = {TYPE: p_type, LAYER: _get_available_layer()}
	
	for key: StringName in p_other.keys():
		var err_bool: bool = r_dict.set(key, p_other.get(key))
		if err_bool:
			printerr(
				"Can't set property {property} with value {value}.".format(
					{"property": key, "value": p_other[key]}
				)
			)
			break
	
	if not _is_element_property_dict_valid(r_dict):
		r_dict.clear()
		return r_dict
	
	return r_dict

## Sets a property dictionary to element [param p_name]. Deletes the element if [param p_properties] is empty.
## If that's the purpose, consider using [method delete_element]. See also [method create_element].[br]
## [b]Note:[/b] [param p_properties] should have the correct type, even if it's empty.
func set_element_properties(p_name: StringName, p_properties: Dictionary[StringName, Variant]) -> void:
	if not _is_element_property_dict_valid(p_properties, false):
		return
	
	if _is_null_or_empty(_elements.get(p_name)):
		print("Warning: Element already has properties. Setting anyway.")
	
	if _is_null_or_empty(p_properties):
		var err_bool: bool = _elements.erase(p_name)
		if not err_bool:
			printerr("Could not delete \"{name}\" element".format({"name": p_name}))
			return
		_ensure_gapless_layers()
	else:
		if not _is_element_property_dict_valid(p_properties):
			return
		var err_bool: bool = _elements.set(p_name, p_properties)
		if not err_bool:
			printerr("Could not set to \"{name}\" element".format({"name": p_name}))
			return
	
	update_visualizer.emit()

## Returns the property dictionary for element [param p_name]. See also [method create_property_dictionary].[br]
## [b]Note:[/b] If [param p_name] does not exist, returns an empty dictionary.
func get_element_properties(p_name: StringName) -> Dictionary[StringName, Variant]:
	var r_dict: Dictionary[StringName, Variant] = {}
	
	if not element_exists(p_name):
		return r_dict
	
	return _elements.get(p_name, r_dict)

## Sets the [param p_property] of [param p_element] to [param p_value].
## See also [method get_element_properties].
func set_element_property(p_element: StringName, p_property: StringName, p_value: Variant) -> void:
	if not property_exists(p_element, p_property):
		return
	if _is_null_or_empty(p_value):
		return
	
	var element: Dictionary[StringName, Variant] = _elements.get(p_element)
	var err_bool: bool = element.set(p_property, p_value)
	if not err_bool:
		printerr(
			"Can't set property {property} with value {value}.".format(
				{"property": p_property, "value": p_value}
			)
		)
	
	update_visualizer.emit()

## Returns the value of [param p_property] of [param  p_element]. See also [method property_exists].[br]
## [b]Note:[/b] if property does not exist, returns [code]null[/code].
func get_element_property(p_element: StringName, p_property: StringName) -> Variant:
	if not property_exists(p_element, p_property):
		return null
	
	var element: Dictionary[StringName, Variant] = _elements.get(p_element)
	
	return element.get(p_property)

## Checks if the property [param p_name] exists in [param p_element].
func property_exists(p_element: StringName, p_name: StringName) -> bool:
	if not element_exists(p_element):
		return false
	if not _is_valid_name(p_name):
		return false
	var element: Dictionary[StringName, Variant] = _elements.get(p_element)
	if not element.has(p_name):
		printerr("\"{name}\" does not exist in \"{element}\".".format({"name": p_name, "element": p_element}))
		return false
	
	return true

# TODO: There's probably a better way to write this.
## Returns a name that's available for a newly created element.
func _get_available_name() -> StringName:
	#return StringName(str(_elements.keys().size())) + &"_Element"
	
	var element_name: StringName = &"0_Element"
	var inc: int = 0
	for key: StringName in _elements.keys():
		if key == element_name:
			inc += 1
			element_name = StringName(str(inc)) + &"_Element"
	
	return element_name

# TODO: There's probably a better way to write this.
## Returns the next available layer number.
func _get_available_layer() -> int:
	#_elements.sort()
	
	if _elements.keys().size() == 0:
		return 0
	else:
		# FIXME:
		var previous_layer: int = 0
		for dict: Dictionary[StringName, Variant] in _elements.values():
			if dict.has(LAYER):
				if dict.get(LAYER) - previous_layer > 1:
					_ensure_gapless_layers()
					break
		
		var highest_layer: int = 0
		for dict: Dictionary[StringName, Variant] in _elements.values():
			if dict.has(LAYER):
				if dict.get(LAYER) > highest_layer:
					highest_layer = dict.get(LAYER)
		return highest_layer + 1
	
	#return _elements.keys()[_elements.keys().size()] + 1 if _elements.keys().size() >= 1 else 0

## Ensures the element dictionary has no gaps in regards to layers.
func _ensure_gapless_layers() -> void:
	var new_dict: Dictionary[StringName, Dictionary] = {}
	var inc: int = 0
	for key: StringName in get_element_keys_sorted():
		var new_name: StringName = StringName(str(inc)) + key.lstrip(str(_get_layer_from_name(key)))
		var err_bool: bool = new_dict.set(new_name, get_element_properties(key))
		if not err_bool:
			printerr("Could not ensure gapless layers.")
	
	_elements = new_dict
	
	#_elements.sort()
	
	#var inc: int = 0
	#for key: StringName in _elements.keys():
		#var err: Error = _rename_element(key, StringName(str(inc)) + key.lstrip(str(_get_layer_from_name(key))))
		#if err:
			#printerr("Could not remove gaps from element dictionary.")
		#inc += 0
	#inc = 0
	#for dict: Dictionary[StringName, Variant] in _elements.values():
		#if dict.has(LAYER):
			#var err_bool: bool = dict.set(LAYER, inc)
			#if not err_bool:
				#printerr("Could not remove gaps from element dictionary.")
			#inc += 1
	
	#update_visualizer.emit()
	
	#var previous_layer: int = -1
	#for key: StringName in _elements.keys():
		#if _get_layer_from_name(key) - previous_layer > 

# TODO: Sort all these private helper methods, based on the order they appear,
# or alphabetical (easier to maintain).

## Renames an element. For instances of this class, use [method set_element_name].
func _rename_element(p_from: StringName, p_to: StringName) -> Error:
	var err_set: bool = _elements.set(p_to, _elements.get(p_from))
	if err_set:
		printerr("Mismatching arguments.")
		return FAILED
	var err_erase: bool = _elements.erase(p_from)
	if err_erase:
		printerr("Key does not exist.")
		return FAILED
	
	return OK

## Returns the layer of an element from its name.
## @deprecated
func _get_layer_from_name(p_name: StringName) -> int:
	return p_name.split("_")[0].to_int()

## Checks if a property dictionary is valid, by checking its type. See also [method create_property_dictionary].
## If [param full_check] is [code]true[/code], keys are also checked, to an extent.
## @deprecated: [method create_property_dictionary] is no longer in use.
func _is_element_property_dict_valid(
	p_properties: Dictionary[StringName, Variant], full_check: bool = true
) -> bool:
	if p_properties is not Dictionary[StringName, Variant]:
		printerr(
			"Given dictionary is not the correct type: {type}".format(
				{"type": type_string(typeof(p_properties))}
			)
		)
		return false
	if full_check:
		if not p_properties.has(TYPE):
			printerr("TYPE key does not exist.")
			return false
		else:
			if p_properties.get(TYPE) is not ElementType:
				printerr("TYPE key is not ElementType.")
				return false
		for key: StringName in p_properties.keys():
			if _is_null_or_empty(key):
				return false
			if _is_null_or_empty(p_properties.get(key)):
				return false
	
	return true

## Checks if [param p_name] is valid for elements.
func _is_valid_name(p_name: StringName) -> bool:
	if not _is_valid_builtin_type(p_name, TYPE_STRING_NAME):
		return false
	
	if _is_null_or_empty(p_name):
		printerr("Given name is empty.".format({"name": p_name}))
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
				print("Warning: Variable is empty.")
				return true
	if p_var == null:
		print("Warning: Variable is null.")
		return true
	
	return false

func _updated_elements() -> void:
	print(get_elements())
