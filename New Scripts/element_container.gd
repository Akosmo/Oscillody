# Oscillody
# Copyright (C) 2025-present Akosmo

# element_container.gd is part of Oscillody. Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ElementContainer
extends PanelContainer

#signal delete_element(p_element_name: StringName)
#signal duplicate_element(p_element_name: StringName)
#signal rename_element(p_element_name: StringName)

var elements: VisualizerElements = VisualizerElements.new()
var node_element_name: StringName

@onready var delete_button: Button = %DeleteButton
@onready var duplicate_button: Button = %DuplicateButton
@onready var rename_button: Button = %RenameButton
@onready var element_name_button: Button = %ElementNameButton

func _ready() -> void:
	elements.create_element()
	node_element_name = elements.get_elements().keys()[elements.get_elements().keys().size() - 1]
	set_name(node_element_name)
	element_name_button.set_text(node_element_name)
	add_to_group(&"VisualizerElementsUI")
	
	var err_del: Error = delete_button.connect("pressed", _delete_node_element)
	if err_del:
		printerr("Could not connect \"delete_element\" signal to \"_delete_node_element\" method.")
	var err_dup: Error = duplicate_button.connect("pressed", _duplicate_node_element)
	if err_dup:
		printerr("Could not connect \"duplicate_element\" signal to \"_duplicate_node_element\" method.")
	var err_ren: Error = rename_button.connect("pressed", _rename_node_element)
	if err_ren:
		printerr("Could not connect \"rename_element\" signal to \"_rename_node_element\" method.")

#func _exit_tree() -> void:
	#remove_from_group(&"VisualizerElementsUI")

#func set_element_node_name(p_name: StringName) -> void:
	#node_element_name = p_name
	#element_name_button.set_text(node_element_name)
	#set_name(node_element_name)
#
func _delete_node_element() -> void:
	elements.delete_element(node_element_name)
	remove_from_group(&"VisualizerElementsUI")
	queue_free()

func _duplicate_node_element() -> void:
	pass

func _rename_node_element() -> void:
	pass
