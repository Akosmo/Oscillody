# Oscillody
# Copyright (C) 2025-present Akosmo

# This file is part of Oscillody. Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

extends ScrollContainer

# This script handles the settings panel.

#region NODES ##################################

@onready var output_d_value: OptionButton = %OutputDValue
@onready var buffer_q_s_value: SpinBox = %BufferQSValue
@onready var low_s_m_value: CheckButton = %LowSMValue
@onready var export_r_value: OptionButton = %ExportRValue

#endregion ##################################

func _ready() -> void:
	# Some wireless output devices seem to cause errors on the waveform.
	for output_device: String in AudioServer.get_output_device_list():
		output_d_value.add_item(output_device)
	if output_d_value.item_count < 1:
		MainUtils.logger("Output device list is empty.", true, true)
	
	buffer_q_s_value.value = MainUtils.buffer_queue_size
	
	low_s_m_value.button_pressed = MainUtils.low_specs_mode
	
	match MainUtils.video_resolution:
		Vector2i(1280, 720):
			export_r_value.select(0)
		Vector2i(1920, 1080):
			export_r_value.select(1)
		Vector2i(2560, 1440):
			export_r_value.select(2)

#region SETTINGS BUILT-IN SIGNAL FUNCTIONS ##################################

func _on_output_d_value_item_selected(index: int) -> void:
	AudioServer.set_output_device(output_d_value.get_item_text(index))
	MainUtils.logger("Output device set to " + output_d_value.get_item_text(index))
	
	MainUtils.update_visualizer.emit()

func _on_buffer_q_s_value_value_changed(value: float) -> void:
	MainUtils.buffer_queue_size = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_low_s_m_value_toggled(toggled_on: bool) -> void:
	MainUtils.load_low_specs_mode = toggled_on

func _on_export_r_value_item_selected(index: int) -> void:
	match index:
		0:
			MainUtils.video_resolution = Vector2i(1280, 720)
		1:
			MainUtils.video_resolution = Vector2i(1920, 1080)
		2:
			MainUtils.video_resolution = Vector2i(2560, 1440)

func _on_free_up_s_value_toggled(toggled_on: bool) -> void:
	MainUtils.free_up_space = toggled_on
	
	MainUtils.logger("Free up space: " + str(toggled_on))

func _on_links_and_more_meta_clicked(meta: Variant) -> void:
	var err: Error = OS.shell_open(meta)
	if err:
		MainUtils.logger("Could not open link. Error: " + error_string(err), true)

#endregion ##################################
