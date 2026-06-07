# Oscillody
# Copyright (C) 2025-present Akosmo

# element_container.gd is part of Oscillody.
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

class_name ElementContainer
extends PanelContainer

signal display_element_properties(element_uid: int)

var elements: VisualizerElements
var element_uid: int
var node_element_name: StringName

@onready var delete_button: Button = %DeleteButton
@onready var duplicate_button: Button = %DuplicateButton
#@onready var rename_button: Button = %RenameButton
@onready var element_name_button: Button = %ElementNameButton

func _ready() -> void:
	element_uid = elements.create_element()
	node_element_name = elements.get_element_property(element_uid, elements.NAME)
	set_name(node_element_name)
	element_name_button.set_text(node_element_name)
	add_to_group(&"VisualizerElementsUI")
	
	var err_del: Error = delete_button.connect("pressed", _delete_node_element)
	if err_del:
		printerr("Could not connect to \"_delete_node_element\".")
	var err_dup: Error = duplicate_button.connect("pressed", _duplicate_node_element)
	if err_dup:
		printerr("Could not connect to \"_duplicate_node_element\".")
	var err_display: Error = element_name_button.connect(
		"pressed", func()->void: display_element_properties.emit(element_uid)
	)
	if err_display:
		printerr("Could not connect to \"display_element_properties\".")
	var err_on_elements_updated: Error = elements.elements_updated.connect(_on_elements_updated) as Error
	if err_on_elements_updated:
		printerr("Could not connect to \"_on_elements_updated\".")

func _delete_node_element() -> void:
	var err: Error = elements.delete_element(element_uid)
	if err:
		printerr("Could not delete element.")
		return
	display_element_properties.emit(-1)
	remove_from_group(&"VisualizerElementsUI")
	queue_free()

func _duplicate_node_element() -> void:
	pass

func _on_elements_updated() -> void:
	if elements.element_exists(element_uid):
		element_name_button.set_text(str(elements.get_element_property(element_uid, elements.NAME)))
