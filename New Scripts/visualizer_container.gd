# Oscillody
# Copyright (C) 2025-present Akosmo

# visualizer_container.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

extends VSplitContainer

const _ELEMENT_CONTAINER: PackedScene = preload("uid://bpi6qpn388std")
const _ELEMENT_PROPERTIES_CONTAINER: PackedScene = preload("uid://b8e8erhj4yg58")

#var _property_container: PackedScene = preload("res://New Scenes/property_container.tscn")
#var _element_property_container_script: Script = preload("res://New Scripts/element_property_container.gd")

var _current_element_selected: Element = null

@onready var _add_element_button: Button = %AddElementButton
@onready var _element_box_container: VBoxContainer = \
$PanelContainer/MarginContainer/ScrollContainer/VBoxContainer
#@onready var _properties_box_container: VBoxContainer = \
#$PanelContainer2/MarginContainer/ScrollContainer/VBoxContainer
@onready var _scroll_container: ScrollContainer = $PanelContainer2/MarginContainer/ScrollContainer


func _ready() -> void:
	if _add_element_button.pressed.connect(_on_add_element_pressed):
		printerr("Could not connect signal.")
	#if ElementManager.element_deleted.connect(_on_element_deleted):
		#printerr("Could not connect signal.")
	if ElementManager.element_type_changed.connect(_update_properties_container):
		printerr("Could not connect signal.")
	if ElementManager.element_layers_updated.connect(_on_element_layers_updated):
		printerr("Could not connect signal.")

func _on_add_element_pressed() -> void:
	var element_node: ElementContainer = _ELEMENT_CONTAINER.instantiate()
	_element_box_container.add_child(element_node)
	if element_node.element_selected.connect(_update_properties_container):
		printerr("Could not connect signal.")
	if element_node.element_container_deleted.connect(_on_element_container_deleted):
		printerr("Could not connect signal.")

func _update_properties_container(p_element: Element) -> void:
	if p_element == _current_element_selected:
		return
	
	_current_element_selected = p_element
	
	#if _properties_box_container.get_child_count():
		#for node: ElementPropertyContainer in _properties_box_container.get_children():
			#node.queue_free()
	
	var found_node_for_element: bool = false
	if _scroll_container.get_child_count():
		for node: Control in _scroll_container.get_children():
			if node.has_method("get_element"):
				var matching_elements: bool = node.get_element() == p_element
				node.set_visible(matching_elements)
				if found_node_for_element == false:
					found_node_for_element = matching_elements
			#if node.is_visible():
				#node.queue_free()
	
	if found_node_for_element:
		return
	
	#if p_element != null:
		#for property_key: StringName in p_element.get_property_dictionary().keys():
			#var property_node: PanelContainer = _property_container.instantiate()
			#property_node.set_script(_element_property_container_script)
			#@warning_ignore("unsafe_property_access")
			#property_node.element = p_element
			#@warning_ignore("unsafe_property_access")
			#property_node.property_key = property_key
			#_properties_box_container.add_child(property_node)
	if p_element != null:
		var node: ElementPropertiesContainer = _ELEMENT_PROPERTIES_CONTAINER.instantiate()
		node.element = p_element
		_scroll_container.add_child(node)

func _on_element_container_deleted(p_element: Element) -> void:
	if _scroll_container.get_child_count():
		for node: Control in _scroll_container.get_children():
			if node.has_method("get_element") and node.get_element() == p_element:
				node.queue_free()
				#var matching_elements: bool = node.get_element() == p_element
				#node.set_visible(matching_elements)
	#if p_element == _current_element_selected:
		#if _properties_box_container.get_child_count():
			#for node: ElementPropertyContainer in _properties_box_container.get_children():
				#node.queue_free()

func _on_element_layers_updated() -> void:
	for node: Node in _element_box_container.get_children():
		if node is not ElementContainer:
			continue
		var element_node: ElementContainer = node as ElementContainer
		_element_box_container.move_child(element_node, element_node.element.get_element_layer() + 1)
