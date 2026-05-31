# Oscillody
# Copyright (C) 2025-present Akosmo

# visualizer_container.gd is part of Oscillody. Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

extends VSplitContainer

var element_container: PackedScene = preload("res://New Scenes/element_container.tscn")
#var undo_redo: UndoRedo = UndoRedo.new()
var elements: VisualizerElements = VisualizerElements.new()

@onready var add_element_button: Button = %AddElementButton
@onready var v_box_container: VBoxContainer = $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer

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
	v_box_container.add_child(element_node)
	
	#undo_redo.create_action("Add element")
	#undo_redo.add_do_method(v_box_container.add_child.bind(element_node))
	#undo_redo.add_do_reference(element_node)
	#undo_redo.add_undo_method(v_box_container.remove_child.bind(element_node))
	#undo_redo.commit_action()











#extends VSplitContainer
#
#var element_container: PackedScene = preload("res://New Scenes/element_container.tscn")
#
#@onready var add_element_button: Button = %AddElementButton
#@onready var v_box_container: VBoxContainer = $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer
#
#func _ready() -> void:
	#var err_add_element: Error = add_element_button.connect("pressed", _add_element)
	#if err_add_element:
		#printerr("Could not connect add_element signal")
#
#func _add_element() -> void:
	#ActionUtils.undo_redo.create_action("Add element")
	#
	#var element_node: ElementContainer = element_container.instantiate()
	#
	#ActionUtils.undo_redo.add_do_method(v_box_container.add_child.bind(element_node))
	#
	#ActionUtils.undo_redo.add_do_method(element_node.connect.bind("delete_element", _delete_element))
	#ActionUtils.undo_redo.add_do_method(element_node.connect.bind("duplicate_element", _duplicate_element))
	#ActionUtils.undo_redo.add_do_method(element_node.connect.bind("rename_element", _rename_element))
	#
	#var element_name: StringName = &"Empty Element_0"
	#var inc: int = 0
	#for key: StringName in VisualizerElements.get_elements():
		#if key == element_name:
			#inc += 1
			#element_name = &"Empty Element_" + str(inc)
	#var layer: int = get_tree().get_node_count_in_group(&"VisualizerElementsUI")
	#
	#ActionUtils.undo_redo.add_do_method(element_node.set_initial_name.bind(element_name))
	#ActionUtils.undo_redo.add_do_method(element_node.add_to_group.bind(&"VisualizerElementsUI"))
	#ActionUtils.undo_redo.add_do_method(v_box_container.move_child.bind(add_element_button.get_parent(), -1))
	#
	#var properties: Dictionary[StringName, Variant] = VisualizerElements.create_property_dictionary(VisualizerElements.ElementType.EMPTY, layer)
	#ActionUtils.undo_redo.add_do_method(VisualizerElements.create_element.bind(element_name, properties))
	#
	#ActionUtils.undo_redo.add_undo_method(VisualizerElements.delete_element.bind(element_name))
	#
	#ActionUtils.undo_redo.add_undo_method(element_node.remove_from_group.bind(&"VisualizerElementsUI"))
	#
	#ActionUtils.undo_redo.add_undo_method(element_node.disconnect.bind("rename_element", _rename_element))
	#ActionUtils.undo_redo.add_undo_method(element_node.disconnect.bind("duplicate_element", _duplicate_element))
	#ActionUtils.undo_redo.add_undo_method(element_node.disconnect.bind("delete_element", _delete_element))
	#
	#ActionUtils.undo_redo.add_undo_method(v_box_container.remove_child.bind(element_node))
	#
	#ActionUtils.undo_redo.add_undo_method(v_box_container.move_child.bind(add_element_button.get_parent(), -1))
	#
	#ActionUtils.undo_redo.commit_action()
	#
	#v_box_container.move_child(add_element_button.get_parent(), -1)
#
#func _delete_element(p_element_name: StringName) -> void:
	#ActionUtils.undo_redo.create_action("Delete element")
	#
	#print("deleting {element}".format({"element": p_element_name}))
	#
	#var element_node: ElementContainer = _get_element_node(p_element_name)
	#if element_node == null:
		#printerr("Could not find node to delete.")
		#return
	#
	#ActionUtils.undo_redo.add_do_method(VisualizerElements.delete_element.bind(p_element_name))
	#ActionUtils.undo_redo.add_do_method(element_node.remove_from_group.bind(&"VisualizerElementsUI"))
	#
	#ActionUtils.undo_redo.add_do_method(element_node.disconnect.bind("rename_element", _rename_element))
	#ActionUtils.undo_redo.add_do_method(element_node.disconnect.bind("duplicate_element", _duplicate_element))
	#ActionUtils.undo_redo.add_do_method(element_node.disconnect.bind("delete_element", _delete_element))
	#
	#ActionUtils.undo_redo.add_do_method(v_box_container.remove_child.bind(element_node))
	#
	#ActionUtils.undo_redo.add_do_method(v_box_container.move_child.bind(add_element_button.get_parent(), -1))
	#
	#ActionUtils.undo_redo.commit_action()
	#
	#v_box_container.move_child(add_element_button.get_parent(), -1)
#
#func _duplicate_element(p_element_name: StringName) -> void:
	#print("duplicating {element}".format({"element": p_element_name}))
#
#func _rename_element(p_element_name: StringName) -> void:
	#print("renaming {element}".format({"element": p_element_name}))
#
#func _get_element_node(p_name: StringName) -> ElementContainer:
	#var node_arr: Array[Node] = v_box_container.get_children()
	#for node: ElementContainer in node_arr:
		#if node.get_name() == p_name:
			#return node
	#
	#return null
