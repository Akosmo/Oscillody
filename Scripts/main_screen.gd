# Oscillody
# Copyright (C) 2025 Akosmo

# This file is part of Oscillody. Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

extends Node2D

# This script handles a few general UI controls.

#region NODES ##################################

@onready var ui_controls: CanvasLayer = $UIControls

@onready var fps_counter: Label = %FPSCounter

@onready var buttons_container_control: Control = %ButtonsContainerControl
@onready var buttons_container: HBoxContainer = %ButtonsContainer

@onready var files_button: Button = %FilesButton
@onready var customize_button: Button = %CustomizeButton
@onready var settings_button: Button = %SettingsButton

@onready var side_panel: PanelContainer = %SidePanel

@onready var files_container: ScrollContainer = %FilesContainer
@onready var customize_container: ScrollContainer = %CustomizeContainer
@onready var settings_container: ScrollContainer = %SettingsContainer

@onready var greetings: CenterContainer = %Greetings
@onready var greetings_color_rect: ColorRect = %GreetingsColorRect

@onready var save_p_color_rect: ColorRect = %SavePColorRect

@onready var render_p_color_rect: ColorRect = %RenderPColorRect

@onready var ui_anim_player: AnimationPlayer = %UIAnimPlayer

@onready var update_checker: HTTPRequest = $UpdateChecker

@onready var close_popup: ConfirmationDialog = $ClosePopup

#endregion ##################################

#region UI VARIABLES ##################################

var side_panel_closed: bool = true

var is_fullscreen: bool = false
@onready var base_window_size: Vector2i = DisplayServer.window_get_size()

#endregion ##################################

func _ready() -> void:
	if MainUtils.disabled_greetings:
		greetings.visible = false
	
	DisplayServer.window_set_min_size(base_window_size)
	MainUtils.update_visualizer.connect(update_main_screen)
	MainUtils.close_requested.connect(on_close_requested)
	
	if MainUtils.can_check_updates:
		var err: Error = update_checker.request("https://api.github.com/repos/akosmo/oscillody/releases/latest")
		if err:
			MainUtils.logger("Could not check for latest release. Check your internet connection.", true, true)
	
	update_main_screen()

func _process(_delta: float) -> void:
	fps_counter.text = "Preview - FPS: " + str(int(Engine.get_frames_per_second()))

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen") and not is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		is_fullscreen = true
		MainUtils.logger("Entered fullscreen.")
	elif event.is_action_pressed("fullscreen") and is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(base_window_size)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		is_fullscreen = false
		MainUtils.logger("Left fullscreen.")
	
	if event.is_action_pressed("toggle_ui") and ui_controls.visible:
		ui_controls.visible = false
		MainUtils.ui_visible = false
		MainUtils.logger("UI toggled off.")
	elif event.is_action_pressed("toggle_ui") and not ui_controls.visible:
		ui_controls.visible = true
		MainUtils.ui_visible = true
		MainUtils.logger("UI toggled on.")

func update_main_screen() -> void:
	greetings_color_rect.custom_minimum_size = MainUtils.window_size
	buttons_container_control.position.x = MainUtils.window_size.x - 220.0
	save_p_color_rect.custom_minimum_size = MainUtils.window_size
	render_p_color_rect.custom_minimum_size = MainUtils.window_size

func on_close_requested() -> void:
	close_popup.popup()

#region UI BUILT-IN SIGNAL FUNCTIONS ##################################

func _on_disable_greetings_value_toggled(toggled_on: bool) -> void:
	MainUtils.disabled_greetings = toggled_on

func _on_files_button_pressed() -> void:
	if not files_container.visible:
		files_container.visible = true

	if side_panel_closed:
		side_panel_closed = false
		ui_anim_player.play("panel_in")
	elif not side_panel_closed and not (customize_container.visible or settings_container.visible):
		side_panel_closed = true
		ui_anim_player.play("panel_out")

	if customize_container.visible or settings_container.visible:
		customize_container.visible = false
		settings_container.visible = false

func _on_customize_button_pressed() -> void:
	if not customize_container.visible:
		customize_container.visible = true

	if side_panel_closed:
		side_panel_closed = false
		ui_anim_player.play("panel_in")
	elif not side_panel_closed and not (files_container.visible or settings_container.visible):
		side_panel_closed = true
		ui_anim_player.play("panel_out")
	
	if files_container.visible or settings_container.visible:
		files_container.visible = false
		settings_container.visible = false

func _on_settings_button_pressed() -> void:
	if not settings_container.visible:
		settings_container.visible = true

	if side_panel_closed:
		side_panel_closed = false
		ui_anim_player.play("panel_in")
	elif not side_panel_closed and not (files_container.visible or customize_container.visible):
		side_panel_closed = true
		ui_anim_player.play("panel_out")
	
	if files_container.visible or customize_container.visible:
		files_container.visible = false
		customize_container.visible = false

func _on_create_button_pressed() -> void:
	ui_anim_player.play("greetings_out")

func _on_update_checker_request_completed(result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	MainUtils.update_last_checked = int(Time.get_unix_time_from_system())
	MainUtils.logger(
		"Checking update at: " + str(MainUtils.update_last_checked) + ". Disabling update checker for 10 minutes."
		)
	MainUtils.can_check_updates = false
	
	if result == HTTPRequest.RESULT_SUCCESS:
		var json_body: Dictionary = JSON.parse_string(body.get_string_from_utf8())
		if json_body == null:
			MainUtils.logger("Could not parse request for latest release.", true, true)
			return
		var latest_version: String = json_body["tag_name"]
		latest_version = latest_version.replace("v", "")
		MainUtils.logger("Current version: " + MainUtils.current_version + " - Latest version: " + latest_version)
		if MainUtils.current_version != latest_version:
			MainUtils.logger("New version available! Go to \"Settings\" and click \"Check for Updates\".", true)
		else:
			MainUtils.logger("There are no new updates.")
	else:
		MainUtils.logger(
			"Error code: " + str(result) \
+ " - Request failed for latest release, manually check for updates in \"Settings\".",
			true,
			true
			)

func _on_close_popup_confirmed() -> void:
	MainUtils.save_settings()
	MainUtils.logger("Session closed (main process).")
	get_tree().quit()

func _on_ui_anim_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "panel_out" and
	(files_container.visible or customize_container.visible or settings_container.visible)):
		files_container.visible = false
		customize_container.visible = false
		settings_container.visible = false

func _on_side_panel_gui_input(event: InputEvent) -> void:
	if "pressed=true" in str(event):
		get_viewport().gui_release_focus()

func _on_release_focus_gui_input(event: InputEvent) -> void:
	if "pressed=true" in str(event):
		get_viewport().gui_release_focus()

#endregion ##################################
