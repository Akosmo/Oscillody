# Oscillody
# Copyright (C) 2025-present Akosmo

# help_container.gd is part of Oscillody.
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

@onready var _documentation_button: Button = %DocumentationButton
@onready var _suggest_features_button: Button = %SuggestFeaturesButton
@onready var _report_bugs_button: Button = %ReportBugsButton
@onready var _support_button: Button = %SupportButton
@onready var _about_oscillody_button: Button = %AboutOscillodyButton

func _ready() -> void:
	if _documentation_button.pressed.connect(_on_documentation_pressed):
		printerr("Could not connect signal.")
	if _suggest_features_button.pressed.connect(_on_suggest_features_pressed):
		printerr("Could not connect signal.")
	if _report_bugs_button.pressed.connect(_on_report_bugs_pressed):
		printerr("Could not connect signal.")
	if _support_button.pressed.connect(_on_support_pressed):
		printerr("Could not connect signal.")
	if _about_oscillody_button.pressed.connect(_on_about_oscillody_pressed):
		printerr("Could not connect signal.")

# TODO: See if there are better ways to open things aside from `shell_open()`.
# TODO: Use the return errors from `shell_open()`.
# TODO: Merge "suggest features" and "report bugs".

func _on_documentation_pressed() -> void:
	pass

func _on_suggest_features_pressed() -> void:
	if OS.shell_open("https://github.com/Akosmo/Oscillody/issues"):
		printerr("Could not open resource with URI.")

func _on_report_bugs_pressed() -> void:
	if OS.shell_open("https://github.com/Akosmo/Oscillody/issues"):
		printerr("Could not open resource with URI.")

func _on_support_pressed() -> void:
	if OS.shell_open("https://www.patreon.com/akosmo"):
		printerr("Could not open resource with URI.")

# NOTE: If v3 will have the same opening message, this button should be the one that displays it again.
# Otherwise, think of a link to use here, replace the text, or delete the button.
func _on_about_oscillody_pressed() -> void:
	pass
