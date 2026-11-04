# Oscillody
# Copyright (C) 2025-present Akosmo

# main.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

extends CanvasLayer

var is_ui_visible: bool

@onready var _main_container: PanelContainer = %MainContainer
@onready var _debug_container: PanelContainer = %DebugContainer
@onready var _player_control_container: PanelContainer = %PlayerControlContainer

@onready var _about_popup: CustomPopup = $AboutPopup
@onready var _preset_popup: CustomPopup = $PresetPopup
@onready var _update_popup: CustomPopup = $UpdatePopup
@onready var _close_request_popup: CustomPopup = $CloseRequestPopup

func _ready() -> void:
	is_ui_visible = true
	
	PopupManager.popup_requested.connect(_on_popup_requested)
	
	CustomLogger.log_normal("Oscillody fully launched.")

func _unhandled_key_input(event: InputEvent) -> void:
	var is_fullscreen: bool = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	
	if event.is_action_pressed("fullscreen") and not is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		is_fullscreen = true
	elif event.is_action_pressed("fullscreen") and is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		is_fullscreen = false
	
	if event.is_action_pressed("toggle_ui"):
		_main_container.set_visible(not is_ui_visible)
		if SettingsManager.get_debug_panel():
			_debug_container.set_visible(not is_ui_visible)
		_player_control_container.set_visible(not is_ui_visible)
		is_ui_visible = not is_ui_visible

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_on_popup_requested(PopupManager.PopupType.CLOSE_REQUEST)

func _on_popup_requested(p_popup_type: PopupManager.PopupType) -> void:
	match p_popup_type:
		PopupManager.PopupType.ABOUT:
			_about_popup.popup_show()
		PopupManager.PopupType.CLOSE_REQUEST:
			_close_request_popup.popup_show()
		PopupManager.PopupType.PRESET:
			_preset_popup.popup_show()
		PopupManager.PopupType.UPDATE:
			_update_popup.popup_show()
