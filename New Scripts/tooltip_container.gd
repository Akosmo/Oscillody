# Oscillody
# Copyright (C) 2025-present Akosmo

# tooltip_container.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

extends PanelContainer

#@onready var _margin_container: MarginContainer = $MarginContainer
@onready var _tooltip_label: Label = %TooltipLabel

func _ready() -> void:
	TooltipManager.tooltip_updated.connect(_on_tooltip_updated)

func _on_tooltip_updated(p_visible: bool, p_text: String) -> void:
	if not p_visible:
		_tooltip_label.hide()
		_tooltip_label.set_text("")
		return
	
	_tooltip_label.show()
	_tooltip_label.set_text(p_text)
