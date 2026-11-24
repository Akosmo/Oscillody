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

var _current_element_selected: Element = null

@onready var _add_element_button: Button = %AddElementButton
@onready var _elements_box_container: VBoxContainer = \
$ElementsPanelContainer/MarginContainer/ScrollContainer/VBoxContainer
@onready var _element_properties_scroll_container: ScrollContainer = \
$ElementPropertiesPanelContainer/MarginContainer/ScrollContainer

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	_add_element_button.pressed.connect(_on_add_element_pressed)
	ElementManager.element_created.connect(_on_element_created)
	ElementManager.element_deleted.connect(_on_element_deleted)
	ElementManager.element_type_changed.connect(_on_element_type_changed)
	ElementManager.element_layers_updated.connect(_on_element_layers_updated)

func _on_add_element_pressed() -> void:
	_current_element_selected = ElementManager.create_element()

func _update_properties_container(p_element: Element, p_visible: bool) -> void:
	if p_element != _current_element_selected:
		_current_element_selected = p_element
	
	for node: Control in _elements_box_container.get_children():
		if (
			node.has_method("get_element") and
			node.get_element() != p_element and
			not node.is_queued_for_deletion()
		):
			node.set_button_toggled(false, false)
	
	var found_node_for_element: bool = false
	for node: Control in _element_properties_scroll_container.get_children():
		if node.has_method("get_element") and not node.is_queued_for_deletion():
			var matching_elements: bool = node.get_element() == p_element
			node.set_visible(matching_elements and p_visible)
			if not found_node_for_element and matching_elements:
				found_node_for_element = matching_elements
	
	if found_node_for_element:
		return
	
	if p_element != null:
		var node: ElementPropertiesContainer = _ELEMENT_PROPERTIES_CONTAINER.instantiate()
		node.element = p_element
		_element_properties_scroll_container.add_child(node)

func _on_element_created(p_element: Element) -> void:
	var element_node: ElementContainer = _ELEMENT_CONTAINER.instantiate()
	element_node.element = p_element
	element_node.element_selected.connect(_update_properties_container)
	_elements_box_container.add_child(element_node)
	
	if p_element != _current_element_selected:
		_current_element_selected = p_element
	
	for node: Control in _element_properties_scroll_container.get_children():
		if node.has_method("get_element"):
			node.hide()
	
	if p_element != null:
		var node: ElementPropertiesContainer = _ELEMENT_PROPERTIES_CONTAINER.instantiate()
		node.element = p_element
		_element_properties_scroll_container.add_child(node)
		node.hide()
	
	element_node.set_button_toggled(true)
	
	# Subtract one: an irrelevant node.
	DebugUtilities.set_element_container_count(_elements_box_container.get_child_count() - 1)
	DebugUtilities.set_element_properties_container_count(_element_properties_scroll_container.get_child_count() - 1)

func _on_element_deleted(p_element: Element) -> void:
	for node: Control in _elements_box_container.get_children():
		if node.has_method("get_element") and node.get_element() == p_element:
			node.queue_free()
	
	for node: Control in _element_properties_scroll_container.get_children():
		if node.has_method("get_element") and node.get_element() == p_element:
			node.queue_free()
	
	# Subtract two: an irrelevant node, and the node that's about to be freed.
	DebugUtilities.set_element_container_count(_elements_box_container.get_child_count() - 2)
	DebugUtilities.set_element_properties_container_count(_element_properties_scroll_container.get_child_count() - 2)

func _on_element_type_changed(p_old_element: Element, _p_new_element: Element) -> void:
	for node: Control in _element_properties_scroll_container.get_children():
		if node.has_method("get_element"):
			if node.get_element() == p_old_element:
				node.queue_free()
				break

func _on_element_layers_updated() -> void:
	for node: Node in _elements_box_container.get_children():
		if node is not ElementContainer:
			continue
		var element_node: ElementContainer = node as ElementContainer
		_elements_box_container.move_child(element_node, element_node.element.get_element_layer() + 1)
