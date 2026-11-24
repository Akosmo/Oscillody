# Oscillody
# Copyright (C) 2025-present Akosmo

# custom_popup.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name CustomPopup
extends Control

@onready var panel_container: PanelContainer = $PanelContainer

@onready var _blur_color_rect: ColorRect = $BlurColorRect
@onready var _black_color_rect: ColorRect = $BlackColorRect

var _tween: Tween

func popup_show() -> void:
	show()
	_tween = create_tween()
	_tween.set_parallel(true)
	
	_tween.set_ease(Tween.EaseType.EASE_OUT).set_trans(Tween.TransitionType.TRANS_BACK)
	
	# Using offset transform doesn't work.
	_tween.tween_method(panel_container.set_scale, Vector2.ZERO, Vector2.ONE, 0.25)
	_tween.tween_method(_set_blur_amount, 0.0, 2.0, 0.25)
	_tween.tween_method(
		_black_color_rect.set_color,
		Color(0.0, 0.0, 0.0, 0.0),
		Color(0.0, 0.0, 0.0, 0.5),
		0.25
	)

func popup_hide() -> void:
	_tween = create_tween()
	_tween.set_parallel(true)
	
	_tween.set_ease(Tween.EaseType.EASE_IN).set_trans(Tween.TransitionType.TRANS_BACK)
	_tween.tween_method(panel_container.set_scale, Vector2.ONE, Vector2.ZERO, 0.25)
	_tween.tween_method(_set_blur_amount, 2.0, 0.0, 0.25)
	_tween.tween_method(
		_black_color_rect.set_color,
		Color(0.0, 0.0, 0.0, 0.5),
		Color(0.0, 0.0, 0.0, 0.0),
		0.25
	)
	
	_tween.finished.connect(_on_tween_hide_finished, CONNECT_ONE_SHOT)

func _set_blur_amount(p_amount: float) -> void:
	_blur_color_rect.get_material().set_shader_parameter("blur_amount", p_amount)

func _on_tween_hide_finished() -> void:
	hide()
