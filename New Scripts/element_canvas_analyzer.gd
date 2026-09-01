# Oscillody
# Copyright (C) 2025-present Akosmo

# element_canvas_analyzer.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ElementCanvasAnalyzer
extends ElementCanvas

const _SAMPLE_AMOUNT: int = 1024

var element: ElementAnalyzer

var _node_2d: Node2D
#var _audio_data: AudioData = AudioData.new()

# Internals: Waveform
#var _capture_effect: AudioEffectCapture
#var _waveform_data: PackedFloat32Array
#var _waveform_point_spacing: Vector2
#var _waveform_points: PackedVector2Array

# TODO: Add proper waveform spacing, point position with dot product, and height.
# TODO: Add source selection: get streams from AudioManager.

func _ready() -> void:
	_node_2d = Node2D.new()
	_node_2d.set_script(preload("uid://cponhhfeulyxf"))
	@warning_ignore("unsafe_property_access")
	_node_2d.element = element
	add_child(_node_2d)
	
	if element.property_changed.connect(_on_element_property_changed):
		printerr("Could not connect signal.")
	
	if AudioManager.stream_list_updated.connect(_on_stream_list_updated):
		printerr("Could not connect signal.")

func _process(_delta: float) -> void:
	_node_2d.queue_redraw()

func get_element() -> Element:
	return element

func _on_element_property_changed(p_property: StringName) -> void:
	match p_property:
		ElementAnalyzer.SN_NAME:
			set_name(element.get_element_name() + "_" + str(element.get_unique_id()))
		ElementAnalyzer.SN_TYPE:
			queue_free()
		ElementAnalyzer.SN_LAYER:
			set_layer(element.get_layer())
		ElementAnalyzer.SN_VISIBILITY:
			set_visible(element.get_visibility())
			set_process(element.get_visibility())
		ElementAnalyzer.SN_AUDIO_SOURCE:
			if not element.get_audio_source().is_empty():
				@warning_ignore("unsafe_property_access")
				_node_2d.capture_effect = AudioServer.get_bus_effect(
					AudioServer.get_bus_index(element.get_audio_source()),
					0
				)
			else:
				@warning_ignore("unsafe_property_access")
				_node_2d.capture_effect = null

func _on_stream_list_updated() -> void:
	if not element.get_audio_source().is_empty():
		@warning_ignore("unsafe_property_access")
		_node_2d.capture_effect = AudioServer.get_bus_effect(
			AudioServer.get_bus_index(element.get_audio_source()),
			0
		)
	else:
		@warning_ignore("unsafe_property_access")
		_node_2d.capture_effect = null
