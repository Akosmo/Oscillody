# Oscillody
# Copyright (C) 2025-present Akosmo

# element_canvas_analyzer_drawable.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

# TODO: Needs to be rewritten (including in C#).

extends Node2D

var element: ElementAnalyzer

#var _capture_effect: AudioEffectCapture
var _audio_data: RealTimeAudioData

var _analyzer_type: ElementAnalyzer.AnalyzerType
var _analyzer_begin_position: Vector2
var _analyzer_end_position: Vector2
var _analyzer_height: float
var _waveform_sample_history_length: int
var _waveform_thickness: float
var _waveform_color: Color
var _waveform_antialiasing: bool

var _waveform_data: PackedFloat32Array
var _angle: float
var _positive_direction: Vector2
var _total_samples: float
var _spacing: Vector2
#var _height: float
var _waveform_points: PackedVector2Array

func _ready() -> void:
	_audio_data = RealTimeAudioData.new()

func _draw() -> void:
	if element.get_analyzer_type() == ElementAnalyzer.AnalyzerType.WAVEFORM:
		_draw_waveform()
	#else:
		#_draw_spectrum()

func set_capture_effect(p_effect: AudioEffectCapture) -> void:
	_audio_data.set_capture_effect(p_effect)

func set_analyzer_type(p_value: ElementAnalyzer.AnalyzerType) -> void:
	_analyzer_type = p_value

func set_analyzer_begin_position(p_value: Vector2) -> void:
	_analyzer_begin_position = p_value * Vector2(WindowUtilities.get_subviewport_size())
	_update_positive_direction()
	_update_spacing()

func set_analyzer_end_position(p_value: Vector2) -> void:
	_analyzer_end_position = p_value * Vector2(WindowUtilities.get_subviewport_size())
	_update_positive_direction()
	_update_spacing()

func set_analyzer_height(p_value: float) -> void:
	_analyzer_height = WindowUtilities.get_subviewport_size().y / 2.0 * p_value

func set_sample_history_length(p_value: int) -> void:
	_waveform_sample_history_length = p_value
	_audio_data.set_sample_history_length(p_value)
	_total_samples = float(_audio_data.get_samples_per_second() - 1) * float(p_value)
	_update_spacing()

func set_waveform_thickness(p_value: float) -> void:
	_waveform_thickness = p_value

func set_waveform_color(p_value: Color) -> void:
	_waveform_color = p_value

func set_waveform_antialiasing(p_value: bool) -> void:
	_waveform_antialiasing = p_value

func _update_spacing() -> void:
	_spacing = Vector2(
		(_analyzer_end_position.x - _analyzer_begin_position.x) / _total_samples,
		(_analyzer_end_position.y - _analyzer_begin_position.y) / _total_samples
	)

func _update_positive_direction() -> void:
	_angle = _analyzer_begin_position.angle_to_point(_analyzer_end_position)
	_positive_direction = Vector2(sin(_angle), cos(_angle) * -1)

func _draw_waveform() -> void:
	if is_zero_approx(_waveform_color.a):
		return
	
	_waveform_data = _audio_data.get_waveform_data()
	
	_waveform_points.clear()
	if _waveform_points.resize(_waveform_data.size()):
		print("Cannot resize array with waveform points.")
	
	#var begin_pos: Vector2 = \
	#Vector2(element.get_begin_x_position(), element.get_begin_y_position()) * \
	#Vector2(WindowUtilities.get_subviewport_size())
	#var end_pos: Vector2 = \
	#Vector2(element.get_end_x_position(), element.get_end_y_position()) * \
	#Vector2(WindowUtilities.get_subviewport_size())
	#_angle = _analyzer_begin_position.angle_to_point(_analyzer_end_position)
	#_positive_direction = Vector2(sin(_angle), cos(_angle) * -1)
	#_total_samples = float(_audio_data.get_samples_per_second() - 1) * float(_waveform_sample_history_length)
	#_spacing = Vector2(
		#(_analyzer_end_position.x - _analyzer_begin_position.x) / _total_samples,
		#(_analyzer_end_position.y - _analyzer_begin_position.y) / _total_samples
	#)
	#_height = WindowUtilities.get_subviewport_size().y / 2.0 * element.get_height()
	
	# 1: Construct line
	var base_line: PackedVector2Array
	@warning_ignore("return_value_discarded")
	base_line.resize(_waveform_data.size())
	for point_idx: int in base_line.size():
		base_line[point_idx].x = _analyzer_begin_position.x + point_idx * _spacing.x
		base_line[point_idx].y = _analyzer_begin_position.y + point_idx * _spacing.y
	
	# 2: Modify points of the line based on the audio amplitude times positive_direction times height
	for point_idx: int in _waveform_data.size():
		_waveform_points[point_idx].x = \
		base_line[point_idx].x + _waveform_data[point_idx] * _analyzer_height * _positive_direction.x
		_waveform_points[point_idx].y = \
		base_line[point_idx].y + _waveform_data[point_idx] * _analyzer_height * _positive_direction.y
	
	draw_polyline(
		_waveform_points,
		_waveform_color,
		_waveform_thickness,
		_waveform_antialiasing
	)
