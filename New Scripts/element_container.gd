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

signal element_selected(p_element_uid: int)

var _element_uid: int

@onready var _delete_button: Button = %DeleteButton
@onready var _duplicate_button: Button = %DuplicateButton
@onready var _element_name_button: Button = %ElementNameButton

func _ready() -> void:
	if _connect_all_signals():
		printerr("Could not connect signals.")
	
	_element_uid = ElementManager.create_element()
	@warning_ignore("unsafe_cast")
	set_name(ElementManager.get_element_property(_element_uid, ElementManager.NAME) as StringName)
	_element_name_button.set_text(
		str(ElementManager.get_element_property(_element_uid, ElementManager.NAME))
	)

func _connect_all_signals() -> Error:
	if _delete_button.pressed.connect(_on_delete_button_pressed):
		return ERR_INVALID_PARAMETER
	if _duplicate_button.pressed.connect(_on_duplicate_button_pressed):
		return ERR_INVALID_PARAMETER
	if _element_name_button.pressed.connect(_on_element_name_button_pressed):
		return ERR_INVALID_PARAMETER
	
	if ElementUIHelper.element_name_changed.connect(_on_element_name_changed):
		return ERR_INVALID_PARAMETER
	
	return OK

func _on_delete_button_pressed() -> void:
	if ElementManager.delete_element(_element_uid):
		printerr("Could not delete element.")
		return
	element_selected.emit(ElementManager.INVALID_UID)
	queue_free()

func _on_duplicate_button_pressed() -> void:
	pass

func _on_element_name_button_pressed() -> void:
	element_selected.emit(_element_uid)

func _on_element_name_changed(p_element_uid: int, p_name: String) -> void:
	if p_element_uid == _element_uid:
		_element_name_button.set_text(p_name)
