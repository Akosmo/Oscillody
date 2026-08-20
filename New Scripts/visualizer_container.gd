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

# TODO: Make members private if not used outside the class. And document this class.

extends VSplitContainer

var element_manager: ElementManager
var _element_container: PackedScene = preload("res://New Scenes/element_container.tscn")
var _property_container: PackedScene = preload("res://New Scenes/property_container.tscn")
var _element_property_container_script: Script = preload("res://New Scripts/element_property_container.gd")

@onready var _add_element_button: Button = %AddElementButton
@onready var _element_box_container: VBoxContainer = \
$PanelContainer/MarginContainer/ScrollContainer/VBoxContainer
@onready var _properties_box_container: VBoxContainer = \
$PanelContainer2/MarginContainer/ScrollContainer/VBoxContainer


func _ready() -> void:
	if _add_element_button.pressed.connect(_on_add_element_pressed):
		printerr("Could not connect the \"pressed\" signal")

func _on_add_element_pressed() -> void:
	var element_node: ElementContainer = _element_container.instantiate()
	element_node.element_manager = element_manager
	_element_box_container.add_child(element_node)
	if element_node.display_element_properties.connect(_display_element_properties):
		printerr("Could not connect \"_display_element_properties\".")

func _display_element_properties(p_element_uid: int) -> void:
	# TODO: Removing and instantiating properties all the time is messy, and maybe not performance friendly.
	# Prefer hiding properties once instantiated.
	if _properties_box_container.get_child_count():
		for node: PropertyContainer in _properties_box_container.get_children():
			_properties_box_container.remove_child(node)
	
	if element_manager.element_exists(p_element_uid):
		for property: StringName in element_manager.get_element_properties(p_element_uid).keys():
			var property_node: PanelContainer = _property_container.instantiate()
			property_node.set_script(_element_property_container_script)
			@warning_ignore("unsafe_property_access")
			property_node.element_manager = element_manager
			@warning_ignore("unsafe_property_access")
			property_node.element_uid = p_element_uid
			@warning_ignore("unsafe_property_access")
			property_node.property_key = property
			_properties_box_container.add_child(property_node)
