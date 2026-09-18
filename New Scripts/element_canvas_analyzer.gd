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

var element: ElementAnalyzer
var _element_ui_configurations: ElementAnalyzerUIConfigurations

var _node_2d: Node2D

func _ready() -> void:
	#set_name(element.get_element_name() + "_" + str(element.get_unique_id()))
	#set_layer(element.get_layer())
	
	_element_ui_configurations = ElementManager.get_element_ui_configurations(element.get_element_type())
	
	_node_2d = Node2D.new()
	_node_2d.set_script(preload("uid://cponhhfeulyxf"))
	@warning_ignore("unsafe_property_access")
	_node_2d.element = element
	add_child(_node_2d)
	_on_stream_list_updated()
	@warning_ignore("unsafe_method_access")
	#_node_2d.set_sample_history_length(element.get_waveform_sample_history_length())
	
	for property_key: StringName in element.get_properties().keys():
		_on_element_property_changed(property_key)
	
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
		ElementAnalyzer.SN_ELEMENT_NAME:
			set_name(element.get_element_name() + "_" + str(element.get_element_unique_id()))
		ElementAnalyzer.SN_ELEMENT_TYPE:
			if element.get_element_type() != Element.ElementType.ANALYZER:
				queue_free()
		ElementAnalyzer.SN_ELEMENT_LAYER:
			set_layer(element.get_element_layer())
		ElementAnalyzer.SN_ELEMENT_VISIBILITY:
			set_visible(element.get_element_visibility())
			set_process(element.get_element_visibility())
		ElementAnalyzer.SN_AUDIO_SOURCE:
			_on_stream_list_updated()
		ElementAnalyzer.SN_ANALYZER_TYPE:
			_node_2d.set_analyzer_type(element.get_analyzer_type())
		ElementAnalyzer.SN_ANALYZER_BEGIN_X_POSITION, ElementAnalyzer.SN_ANALYZER_BEGIN_Y_POSITION:
			_node_2d.set_analyzer_begin_position(
				Vector2(element.get_analyzer_begin_x_position(), element.get_analyzer_begin_y_position())
			)
		ElementAnalyzer.SN_ANALYZER_END_X_POSITION, ElementAnalyzer.SN_ANALYZER_END_Y_POSITION:
			_node_2d.set_analyzer_end_position(
				Vector2(element.get_analyzer_end_x_position(), element.get_analyzer_end_y_position())
			)
		ElementAnalyzer.SN_ANALYZER_HEIGHT:
			_node_2d.set_analyzer_height(element.get_analyzer_height())
		ElementAnalyzer.SN_WAVEFORM_SAMPLE_HISTORY_LENGTH:
			_node_2d.set_sample_history_length(element.get_waveform_sample_history_length())
		ElementAnalyzer.SN_WAVEFORM_THICKNESS:
			_node_2d.set_waveform_thickness(element.get_waveform_thickness())
		ElementAnalyzer.SN_WAVEFORM_COLOR:
			_node_2d.set_waveform_color(element.get_waveform_color())
		ElementAnalyzer.SN_WAVEFORM_ANTIALIASING:
			_node_2d.set_waveform_antialiasing(element.get_waveform_antialiasing())

func _on_stream_list_updated() -> void:
	if not element.get_audio_source().is_empty():
		@warning_ignore("unsafe_method_access")
		_node_2d.set_capture_effect(
			AudioServer.get_bus_effect(
				AudioServer.get_bus_index(element.get_audio_source()),
				0
			)
		)
	else:
		@warning_ignore("unsafe_method_access")
		_node_2d.set_capture_effect(null)
