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

extends Node2D

var element: ElementAnalyzer
var capture_effect: AudioEffectCapture

var _waveform_data: PackedFloat32Array
var _spacing: Vector2
var _height: float
var _waveform_points: PackedVector2Array

func _draw() -> void:
	if element.get_analyzer_type() == element.AnalyzerType.WAVEFORM:
		_draw_waveform()
	#else:
		#_draw_spectrum()

func _draw_waveform() -> void:
	if is_zero_approx(element.get_waveform_color().a):
		return
	
	if capture_effect != null:
		_waveform_data = RealTimeAudioData.get_waveform_data(
			capture_effect,
			element.get_waveform_sample_history_length()
		)
	
	_waveform_points.clear()
	if _waveform_points.resize(_waveform_data.size()):
		print("Cannot resize array with waveform points.")
	
	var begin_pos: Vector2 = \
	Vector2(element.get_begin_x_position(), element.get_begin_y_position()) * \
	Vector2(WindowUtilities.get_subviewport_size())
	var end_pos: Vector2 = \
	Vector2(element.get_end_x_position(), element.get_end_y_position()) * \
	Vector2(WindowUtilities.get_subviewport_size())
	var angle: float = begin_pos.angle_to_point(end_pos)
	var positive_direction: Vector2 = Vector2(sin(angle), cos(angle) * -1)
	var total_samples: float = float(RealTimeAudioData.get_number_of_samples() - 1) * \
	float(element.get_waveform_sample_history_length())
	_spacing = Vector2(
		(end_pos.x - begin_pos.x) / total_samples,
		(end_pos.y - begin_pos.y) / total_samples
	)
	_height = WindowUtilities.get_subviewport_size().y / 2.0 * element.get_height()
	
	# 1: Construct line
	var base_line: PackedVector2Array
	@warning_ignore("return_value_discarded")
	base_line.resize(_waveform_data.size())
	for point_idx: int in base_line.size():
		base_line[point_idx].x = begin_pos.x + point_idx * _spacing.x
		base_line[point_idx].y = begin_pos.y + point_idx * _spacing.y
	
	# 2: Modify points of the line based on the audio amplitude times positive_direction times height
	if RealTimeAudioData._get_audio_samples_size() == element.get_waveform_sample_history_length():
		for point_idx: int in _waveform_data.size():
			_waveform_points[point_idx].x = \
			base_line[point_idx].x + _waveform_data[point_idx] * _height * positive_direction.x
			_waveform_points[point_idx].y = \
			base_line[point_idx].y + _waveform_data[point_idx] * _height * positive_direction.y
	
	if _waveform_points.size() > 1 and RealTimeAudioData._get_audio_samples_size() > 0:
		draw_polyline(
			_waveform_points,
			element.get_waveform_color(),
			element.get_waveform_thickness(),
			element.get_waveform_antialiasing()
		)
