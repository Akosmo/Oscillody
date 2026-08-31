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

class_name ElementContainer
extends PanelContainer
## UI class represending an [Element].

## Emitted when the button with the Element's name is pressed.
signal element_selected(p_element: Element)
## Emitter when the delete button is pressed.
signal element_container_deleted(p_element: Element)

var element: Element

@onready var _delete_button: Button = %DeleteButton
@onready var _element_name_button: Button = %ElementNameButton

func _ready() -> void:
	element = ElementManager.create_element()
	set_name(element.get_element_name() + "_" + str(element.get_unique_id()))
	_element_name_button.set_text(element.get_element_name())
	
	if _connect_signals():
		printerr("Could not connect signals.")

func _connect_signals() -> Error:
	if _delete_button.pressed.connect(_on_delete_button_pressed):
		return ERR_INVALID_PARAMETER
	if _element_name_button.pressed.connect(_on_element_name_button_pressed):
		return ERR_INVALID_PARAMETER
	
	if element.property_changed.connect(_on_element_name_changed):
		return ERR_INVALID_PARAMETER
	
	if ElementManager.element_type_changed.connect(_on_element_type_changed):
		return ERR_INVALID_PARAMETER
	
	return OK

func _on_delete_button_pressed() -> void:
	ElementManager.delete_element(element)
	element_container_deleted.emit(element)
	queue_free()

func _on_element_name_button_pressed() -> void:
	element_selected.emit(element)

func _on_element_name_changed(p_property: StringName) -> void:
	if p_property == element.SN_NAME:
		_element_name_button.set_text(element.get_element_name())

func _on_element_type_changed(p_element: Element) -> void:
	if element.get_unique_id() == p_element.get_unique_id():
		element = p_element
