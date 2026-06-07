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

var element_container: PackedScene = preload("res://New Scenes/element_container.tscn")
var property_container: PackedScene = preload("res://New Scenes/property_container.tscn")
var element_property_container_script: Script = preload("res://New Scripts/element_property_container.gd")
#var undo_redo: UndoRedo = UndoRedo.new()
var elements: VisualizerElements = VisualizerElements.new()

@onready var add_element_button: Button = %AddElementButton
@onready var element_box_container: VBoxContainer = \
$PanelContainer/MarginContainer/ScrollContainer/VBoxContainer
@onready var properties_box_container: VBoxContainer = \
$PanelContainer2/MarginContainer/ScrollContainer/VBoxContainer


func _ready() -> void:
	var err_on_add_element_pressed: Error =  add_element_button.connect(&"pressed", _on_add_element_pressed)
	if err_on_add_element_pressed:
		printerr("Could not connect the \"pressed\" signal")

#func _shortcut_input(event: InputEvent) -> void:
	#if event.is_action_pressed("undo") and undo_redo.has_undo():
		#print("pressing undo...")
		#var err_bool: bool = undo_redo.undo()
		#if not err_bool:
			#printerr("There is no action to undo.")
	#elif event.is_action_pressed("redo") and undo_redo.has_redo():
		#print("pressing redo...")
		#var err_bool: bool = undo_redo.redo()
		#if not err_bool:
			#printerr("There is no action to redo.")

func _on_add_element_pressed() -> void:
	var element_node: ElementContainer = element_container.instantiate()
	element_node.elements = elements
	element_box_container.add_child(element_node)
	var err_display_element_properties: Error = element_node.connect(
		"display_element_properties", _display_element_properties
	)
	if err_display_element_properties:
		printerr("Could not connect \"_display_element_properties\".")

func _display_element_properties(p_element_uid: int) -> void:
	# TODO: Removing and instantiating properties all the time is messy, and maybe not performance friendly.
	# Prefer hiding properties once instantiated.
	if properties_box_container.get_child_count():
		for node: PropertyContainer in properties_box_container.get_children():
			properties_box_container.remove_child(node)
	
	if elements.element_exists(p_element_uid):
		for property: StringName in elements.get_element_properties(p_element_uid):
			var property_node: PanelContainer = property_container.instantiate()
			property_node.set_script(element_property_container_script)
			@warning_ignore("unsafe_property_access")
			property_node.elements = elements
			@warning_ignore("unsafe_property_access")
			property_node.element_uid = p_element_uid
			@warning_ignore("unsafe_property_access")
			property_node.property_key = property
			properties_box_container.add_child(property_node)
