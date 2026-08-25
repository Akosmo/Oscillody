# Oscillody
# Copyright (C) 2025-present Akosmo

# element_analyzer.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ElementAnalyzer
extends Element

# TODO: Make members private.

enum AnalyzerType {
	WAVEFORM,
	SPECTRUM
}

const _ANALYZER_TYPE: StringName = &"Analyzer Type"
const _WAVEFORM: StringName = &"Waveform"
const _SPECTRUM: StringName = &"Spectrum"
const _ANALYZER_SOURCE: StringName = &"Analyzer Source"

const _BEGIN_X_POSITION: StringName = &"Begin X Position"
const _BEGIN_Y_POSITION: StringName = &"Begin Y Position"
const _END_X_POSITION: StringName = &"End X Position"
const _END_Y_POSITION: StringName = &"End Y Position"
const _HEIGHT: StringName = &"Height"

# Property Key Names: Waveform
const _WAVEFORM_THICKNESS: StringName = &"Waveform Thickness"
const _WAVEFORM_COLOR: StringName = &"Waveform Color"
const _WAVEFORM_ANTIALIASING: StringName = &"Waveform Antialiasing"

const _SAMPLE_AMOUNT: int = 1024

var element_uid: int

var _node_2d: Node2D

var _property_dictionary: Dictionary[StringName, Variant]

var _element_name: String
var _element_type: ElementManager.ElementType
var _element_layer: int
var _element_visibility: bool

var _analyzer_type: AnalyzerType
var _analyzer_source: StringName

var _begin_position: Vector2
var _end_position: Vector2
var _height: float

# Add: Waveform dict stuff
var _waveform_thickness: float
var _waveform_color: Color
var _waveform_antialiasing: bool

# Internals: Waveform
var _capture_effect: AudioEffectCapture
var _sample_history_length: int
var _audio_samples: Array[PackedFloat32Array]
var _temporary_audio_samples: Array[PackedFloat32Array]
var _waveform_point_spacing: float
var _pre_waveform_points: PackedFloat32Array
var _waveform_points: PackedVector2Array

# TODO: Add proper waveform spacing, point position with dot product, and height.
# TODO: Add source selection: get streams from AudioManager.

func _ready() -> void:
	_node_2d = Node2D.new()
	add_child(_node_2d)
	
	_property_dictionary = ElementManager.get_element_properties(element_uid)
	
	_analyzer_type = AnalyzerType.WAVEFORM
	
	_setup_properties()
	
	for property_key: StringName in _property_dictionary.keys():
		_change_property(property_key, true)
	
	if ElementManager.element_property_changed.connect(_on_element_property_changed):
		return printerr("Could not connect signal.")

func _process(_delta: float) -> void:
	#_waveform_get_buffer() # TODO: Only run this if there's an effect available in a bus to get.
	_node_2d.queue_redraw()

func _draw() -> void:
	if _analyzer_type == AnalyzerType.WAVEFORM:
		_draw_waveform()
	#else:
		#_draw_spectrum()

func _draw_waveform() -> void:
	if is_zero_approx(_waveform_color.a):
		return
	
	_pre_waveform_points.clear()
	
	for buffer: PackedFloat32Array in _audio_samples:
		_pre_waveform_points.append_array(buffer)
	
	_waveform_points.clear()
	if _waveform_points.resize(_pre_waveform_points.size()):
		print("Cannot resize array with waveform points.")
	
	if _audio_samples.size() == _sample_history_length:
		for point: int in _pre_waveform_points.size():
			_waveform_points[point].x = point * _waveform_point_spacing
			_waveform_points[point].y = _pre_waveform_points[point] * 100.0 # Arbitrary height factor.
	
	if _waveform_points.size() > 1 and _audio_samples.size() > 0:
		_node_2d.draw_polyline(_waveform_points, _waveform_color, _waveform_thickness, _waveform_antialiasing)

# TODO: These audio data stuff should probably be in a singleton, so that values can be recycled for
# better perfomance (think audio reaction).
func _waveform_get_buffer() -> void:
	# TODO: Don't call this every frame.
	_capture_effect = AudioServer.get_bus_effect(AudioServer.get_bus_index(_analyzer_source), 0)
	
	if _capture_effect.can_get_buffer(_SAMPLE_AMOUNT):
		# TODO: Don't make new variables here.
		var temp_pair_buffer: PackedVector2Array = _capture_effect.get_buffer(_SAMPLE_AMOUNT)
		var temp_average_buffer: PackedFloat32Array
		if temp_average_buffer.resize(_SAMPLE_AMOUNT):
			print("Could not resize temporary averaged buffer array.")
		var point_idx: int = 0
		for sample: Vector2 in temp_pair_buffer:
			var avg_sample: float = (sample.x + sample.y) * 0.5
			temp_average_buffer[point_idx] = avg_sample
			point_idx += 1
		if _sample_history_length < _temporary_audio_samples.size():
			if _temporary_audio_samples.resize(_sample_history_length):
				print("Could not resize temporary averaged buffer array.")
		_temporary_audio_samples.append_array([temp_average_buffer.duplicate()])
		if _temporary_audio_samples.size() > _sample_history_length:
			_temporary_audio_samples.remove_at(0)
		_audio_samples = _temporary_audio_samples

func _setup_properties() -> void:
	var new_property_dict: Dictionary[StringName, Variant] = _property_dictionary
	if _analyzer_type == AnalyzerType.WAVEFORM:
		if not new_property_dict.set(_BEGIN_X_POSITION, 0.0):
			printerr("Could not set property.")
		if not new_property_dict.set(_BEGIN_Y_POSITION, 0.5):
			printerr("Could not set property.")
		if not new_property_dict.set(_END_X_POSITION, 1.0):
			printerr("Could not set property.")
		if not new_property_dict.set(_END_Y_POSITION, 0.5):
			printerr("Could not set property.")
		if not new_property_dict.set(_HEIGHT, 2.0): # TODO: Replace with `1.0` for fullscreen.
			printerr("Could not set property.")
		if not new_property_dict.set(_WAVEFORM_THICKNESS, 1.0):
			printerr("Could not set property.")
		if not new_property_dict.set(_WAVEFORM_COLOR, Color.WHITE):
			printerr("Could not set property.")
		if not new_property_dict.set(_WAVEFORM_ANTIALIASING, true):
			printerr("Could not set property.")
	else:
		pass
	
	for property_key: StringName in _property_dictionary:
		match property_key:
			ElementManager.NAME:
				var configs: Dictionary[StringName, Variant]
				configs.set(ElementUIHelper.CONTROL_NODE, ElementUIHelper.ControlNode.LINE_EDIT)
				configs.set(ElementUIHelper.DEFAULT_VALUE, "Element_" + str(element_uid))
				if ElementUIHelper.set_property_configurations(element_uid, property_key, configs):
					printerr("Could not set property configurations.")
			ElementManager.TYPE:
				var configs: Dictionary[StringName, Variant]
				configs.set(ElementUIHelper.CONTROL_NODE, ElementUIHelper.ControlNode.OPTION_BUTTON)
				# TEST: Check if this works...
				configs.set(ElementUIHelper.DEFAULT_VALUE, ElementManager.ElementType.EMPTY)
				if ElementUIHelper.set_property_configurations(element_uid, property_key, configs):
					printerr("Could not set property configurations.")
			ElementManager.LAYER:
				var configs: Dictionary[StringName, Variant]
				configs.set(ElementUIHelper.CONTROL_NODE, ElementUIHelper.ControlNode.NUMERICAL)
				if ElementUIHelper.set_property_configurations(element_uid, property_key, configs):
					printerr("Could not set property configurations.")
			ElementManager.VISIBILITY:
				var configs: Dictionary[StringName, Variant]
				configs.set(ElementUIHelper.CONTROL_NODE, ElementUIHelper.ControlNode.CHECK_BUTTON)
				configs.set(ElementUIHelper.DEFAULT_VALUE, true)
				if ElementUIHelper.set_property_configurations(element_uid, property_key, configs):
					printerr("Could not set property configurations.")
			_ANALYZER_TYPE:
				var configs: Dictionary[StringName, Variant]
				configs.set(ElementUIHelper.CONTROL_NODE, ElementUIHelper.ControlNode.OPTION_BUTTON)
				configs.set(ElementUIHelper.DEFAULT_VALUE, _WAVEFORM)
				configs.set(ElementUIHelper.OPTIONS, [_WAVEFORM, _SPECTRUM])
				if ElementUIHelper.set_property_configurations(element_uid, property_key, configs):
					printerr("Could not set property configurations.")
			_ANALYZER_SOURCE:
				var configs: Dictionary[StringName, Variant]
				configs.set(ElementUIHelper.CONTROL_NODE, ElementUIHelper.ControlNode.OPTION_BUTTON)
				var arr_options: PackedStringArray
				for stream_name: String in AudioManager.get_streams().values():
					arr_options.append(stream_name)
				configs.set(ElementUIHelper.OPTIONS, arr_options)
				if ElementUIHelper.set_property_configurations(element_uid, property_key, configs):
					printerr("Could not set property configurations.")
			_BEGIN_X_POSITION:
				var configs: Dictionary[StringName, Variant]
				configs.set(ElementUIHelper.CONTROL_NODE, ElementUIHelper.ControlNode.NUMERICAL)
				configs.set(ElementUIHelper.DEFAULT_VALUE, 0.0)
				configs.set(ElementUIHelper.MINIMUM, 0.0)
				configs.set(ElementUIHelper.MAXIUMUM, 1.0)
				configs.set(ElementUIHelper.STEP, 0.01)
				configs.set(ElementUIHelper.ROUNDED, false)
				if ElementUIHelper.set_property_configurations(element_uid, property_key, configs):
					printerr("Could not set property configurations.")
			_BEGIN_Y_POSITION:
				var configs: Dictionary[StringName, Variant]
				configs.set(ElementUIHelper.CONTROL_NODE, ElementUIHelper.ControlNode.NUMERICAL)
				configs.set(ElementUIHelper.DEFAULT_VALUE, 0.5)
				configs.set(ElementUIHelper.MINIMUM, 0.0)
				configs.set(ElementUIHelper.MAXIUMUM, 1.0)
				configs.set(ElementUIHelper.STEP, 0.01)
				configs.set(ElementUIHelper.ROUNDED, false)
				if ElementUIHelper.set_property_configurations(element_uid, property_key, configs):
					printerr("Could not set property configurations.")
			_END_X_POSITION:
				var configs: Dictionary[StringName, Variant]
				configs.set(ElementUIHelper.CONTROL_NODE, ElementUIHelper.ControlNode.NUMERICAL)
				configs.set(ElementUIHelper.DEFAULT_VALUE, 1.0)
				configs.set(ElementUIHelper.MINIMUM, 0.0)
				configs.set(ElementUIHelper.MAXIUMUM, 1.0)
				configs.set(ElementUIHelper.STEP, 0.01)
				configs.set(ElementUIHelper.ROUNDED, false)
				if ElementUIHelper.set_property_configurations(element_uid, property_key, configs):
					printerr("Could not set property configurations.")
			_END_Y_POSITION:
				var configs: Dictionary[StringName, Variant]
				configs.set(ElementUIHelper.CONTROL_NODE, ElementUIHelper.ControlNode.NUMERICAL)
				configs.set(ElementUIHelper.DEFAULT_VALUE, 0.5)
				configs.set(ElementUIHelper.MINIMUM, 0.0)
				configs.set(ElementUIHelper.MAXIUMUM, 1.0)
				configs.set(ElementUIHelper.STEP, 0.01)
				configs.set(ElementUIHelper.ROUNDED, false)
				if ElementUIHelper.set_property_configurations(element_uid, property_key, configs):
					printerr("Could not set property configurations.")
			_HEIGHT:
				var configs: Dictionary[StringName, Variant]
				configs.set(ElementUIHelper.CONTROL_NODE, ElementUIHelper.ControlNode.NUMERICAL)
				configs.set(ElementUIHelper.DEFAULT_VALUE, 2.0)
				configs.set(ElementUIHelper.MINIMUM, 0.0)
				configs.set(ElementUIHelper.MAXIUMUM, 2.0)
				configs.set(ElementUIHelper.STEP, 0.01)
				configs.set(ElementUIHelper.ROUNDED, false)
				if ElementUIHelper.set_property_configurations(element_uid, property_key, configs):
					printerr("Could not set property configurations.")
			_WAVEFORM_THICKNESS:
				var configs: Dictionary[StringName, Variant]
				configs.set(ElementUIHelper.CONTROL_NODE, ElementUIHelper.ControlNode.NUMERICAL)
				configs.set(ElementUIHelper.DEFAULT_VALUE, 1.0)
				configs.set(ElementUIHelper.MINIMUM, 0.0)
				configs.set(ElementUIHelper.MAXIUMUM, 10.0)
				configs.set(ElementUIHelper.STEP, 1.0)
				configs.set(ElementUIHelper.ROUNDED, true)
				if ElementUIHelper.set_property_configurations(element_uid, property_key, configs):
					printerr("Could not set property configurations.")
			_WAVEFORM_COLOR:
				var configs: Dictionary[StringName, Variant]
				configs.set(ElementUIHelper.CONTROL_NODE, ElementUIHelper.ControlNode.COLOR_PICKER_BUTTON)
				configs.set(ElementUIHelper.DEFAULT_VALUE, Color.WHITE)
				if ElementUIHelper.set_property_configurations(element_uid, property_key, configs):
					printerr("Could not set property configurations.")
			_WAVEFORM_ANTIALIASING:
				var configs: Dictionary[StringName, Variant]
				configs.set(ElementUIHelper.CONTROL_NODE, ElementUIHelper.ControlNode.CHECK_BUTTON)
				configs.set(ElementUIHelper.DEFAULT_VALUE, true)
				if ElementUIHelper.set_property_configurations(element_uid, property_key, configs):
					printerr("Could not set property configurations.")
			_:
				printerr("Property not matched.")
	
	if ElementManager.set_element_properties(element_uid, new_property_dict):
		printerr("Could not set properties.")

func _change_property(p_property: StringName, p_new_element: bool = false) -> void:
	match p_property:
		ElementManager.NAME:
			_element_name = _property_dictionary.get(p_property)
			set_name(_element_name + "_" + str(element_uid))
		ElementManager.TYPE:
			if p_new_element:
				_element_type = _property_dictionary.get(p_property)
			else:
				queue_free()
		ElementManager.LAYER:
			_element_layer = _property_dictionary.get(p_property)
			set_layer(_element_layer)
		ElementManager.VISIBILITY:
			_element_visibility = _property_dictionary.get(p_property)
			set_visible(_element_visibility)
			set_process(_element_visibility)
		_BEGIN_X_POSITION:
			_begin_position.x = _property_dictionary.get(p_property)
		_BEGIN_Y_POSITION:
			_begin_position.y = _property_dictionary.get(p_property)
		_END_X_POSITION:
			_end_position.x = _property_dictionary.get(p_property)
		_END_Y_POSITION:
			_end_position.y = _property_dictionary.get(p_property)
		_HEIGHT:
			_height = _property_dictionary.get(p_property)
		_WAVEFORM_THICKNESS:
			_waveform_thickness = _property_dictionary.get(p_property)
		_WAVEFORM_COLOR:
			_waveform_color = _property_dictionary.get(p_property)
		_WAVEFORM_ANTIALIASING:
			_waveform_antialiasing = _property_dictionary.get(p_property)

func _on_element_property_changed(p_element_uid: int, p_property: StringName) -> void:
	if p_element_uid == element_uid:
		_change_property(p_property)
