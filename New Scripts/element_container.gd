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

var element_manager: ElementManager
var element_uid: int

@onready var _delete_button: Button = %DeleteButton
@onready var _duplicate_button: Button = %DuplicateButton
@onready var _element_name_button: Button = %ElementNameButton

func _ready() -> void:
	if _connect_all_signals():
		printerr("Could not connect signals.")
	
	element_uid = element_manager.create_element()
	@warning_ignore("unsafe_cast")
	set_name(element_manager.get_element_property(element_uid, element_manager.NAME) as StringName)
	_element_name_button.set_text(
		str(element_manager.get_element_property(element_uid, element_manager.NAME))
	)

func _connect_all_signals() -> Error:
	if _delete_button.pressed.connect(_on_delete_button_pressed):
		return ERR_INVALID_PARAMETER
	if _duplicate_button.pressed.connect(_on_duplicate_button_pressed):
		return ERR_INVALID_PARAMETER
	if _element_name_button.pressed.connect(_on_element_name_button_pressed):
		return ERR_INVALID_PARAMETER
	if element_manager.elements_updated.connect(_on_elements_updated):
		return ERR_INVALID_PARAMETER
	
	return OK

func _on_delete_button_pressed() -> void:
	if element_manager.delete_element(element_uid):
		printerr("Could not delete element.")
		return
	display_element_properties.emit(-1)
	queue_free()

func _on_duplicate_button_pressed() -> void:
	pass

func _on_element_name_button_pressed() -> void:
	display_element_properties.emit(element_uid)

func _on_elements_updated() -> void:
	if element_manager.element_exists(element_uid):
		_element_name_button.set_text(
			str(element_manager.get_element_property(element_uid, element_manager.NAME))
		)
