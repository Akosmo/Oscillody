# Oscillody
# Copyright (C) 2025-present Akosmo

# real_time_audio_data.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

extends Node

const _NUMBER_OF_SAMPLES: int = 1024

var _temp_pair_buffer: PackedVector2Array
var _temp_average_buffer: PackedFloat32Array
var _waveform_point_idx: int
var _avg_sample: float
var _audio_samples: Array[PackedFloat32Array]
var _temporary_audio_samples: Array[PackedFloat32Array]
var _pre_waveform_points: PackedFloat32Array

#var _audio_data_dictionary: Dictionary[AudioEffectCapture, PackedFloat32Array]

func get_number_of_samples() -> int:
	return _NUMBER_OF_SAMPLES

func _get_audio_samples_size() -> int:
	return _audio_samples.size()

func get_waveform_data(p_effect: AudioEffectCapture, p_length: int) -> PackedFloat32Array:
	if p_effect.can_get_buffer(_NUMBER_OF_SAMPLES):
		_temp_pair_buffer = p_effect.get_buffer(_NUMBER_OF_SAMPLES)
		@warning_ignore("return_value_discarded")
		_temp_average_buffer.resize(_NUMBER_OF_SAMPLES)
		_waveform_point_idx = 0
		for sample: Vector2 in _temp_pair_buffer:
			_avg_sample = (sample.x + sample.y) * 0.5
			_temp_average_buffer[_waveform_point_idx] = _avg_sample
			_waveform_point_idx += 1
		if p_length < _temporary_audio_samples.size():
			@warning_ignore("return_value_discarded")
			_temporary_audio_samples.resize(p_length)
		_temporary_audio_samples.append_array([_temp_average_buffer.duplicate()])
		if _temporary_audio_samples.size() > p_length:
			_temporary_audio_samples.remove_at(0)
		_audio_samples = _temporary_audio_samples
	#else:
		#if _audio_data_dictionary.has(p_effect):
			#return _audio_data_dictionary.get(p_effect)
	
	_pre_waveform_points.clear()
	for buffer: PackedFloat32Array in _audio_samples:
		_pre_waveform_points.append_array(buffer)
	
	#@warning_ignore("return_value_discarded")
	#_audio_data_dictionary.set(p_effect, _pre_waveform_points)
	
	return _pre_waveform_points
