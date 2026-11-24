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

const _LINK_GITHUB_ISSUES: String = "https://github.com/Akosmo/Oscillody/issues"
const _LINK_PATREON: String = "https://www.patreon.com/akosmo"

@onready var _documentation_button: Button = %DocumentationButton
@onready var _suggest_features_report_bugs_button: Button = %SuggestFeaturesReportBugsButton
@onready var _support_button: Button = %SupportButton
@onready var _about_oscillody_button: Button = %AboutOscillodyButton

func _ready() -> void:
	_suggest_features_report_bugs_button.set_tooltip_text(_LINK_GITHUB_ISSUES)
	_support_button.set_tooltip_text(_LINK_PATREON)
	
	_connect_signals()

func _connect_signals() -> void:
	_documentation_button.pressed.connect(_on_documentation_pressed)
	_suggest_features_report_bugs_button.pressed.connect(_on_suggest_features_report_bugs_pressed)
	_support_button.pressed.connect(_on_support_pressed)
	_about_oscillody_button.pressed.connect(_on_about_oscillody_pressed)

func _on_documentation_pressed() -> void:
	pass

func _on_suggest_features_report_bugs_pressed() -> void:
	if OS.shell_open(_LINK_GITHUB_ISSUES):
		CustomLogger.log_error("Could not open link: " + _LINK_GITHUB_ISSUES)

func _on_support_pressed() -> void:
	if OS.shell_open(_LINK_PATREON):
		CustomLogger.log_error("Could not open link: " + _LINK_PATREON)

func _on_about_oscillody_pressed() -> void:
	PopupManager.request_popup(PopupManager.PopupType.ABOUT)
