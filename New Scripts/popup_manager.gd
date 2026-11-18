# Oscillody
# Copyright (C) 2025-present Akosmo

# popup_manager.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

extends Node

signal popup_requested(p_popup_type: PopupType)

enum PopupType {
	ABOUT,
	CLOSE_REQUEST,
	PRESET,
	PROGRESS,
	UNSAVED_CHANGES,
	UPDATE
}

func request_popup(p_popup_type: PopupType) -> void:
	popup_requested.emit(p_popup_type)
