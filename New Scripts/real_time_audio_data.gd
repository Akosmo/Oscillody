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

class_name RealTimeAudioData
extends RefCounted

const _SAMPLES_PER_SECOND: int = 1024

static var _audio_data_dictionary: Dictionary[AudioEffectCapture, PackedVector2Array]

var _temporary_stereo_buffer: PackedVector2Array
var _temporary_average_buffer: PackedFloat32Array
var _sample_index: int
var _average_sample: float
var _distributed_audio_samples: Array[PackedFloat32Array]
var _temporary_distributed_audio_samples: Array[PackedFloat32Array]
var _pre_waveform_points: PackedFloat32Array

func get_samples_per_second() -> int:
	return _SAMPLES_PER_SECOND

func _get_distributed_audio_samples_size() -> int:
	return _distributed_audio_samples.size()

func get_waveform_data(p_effect: AudioEffectCapture, p_length: int) -> PackedFloat32Array:
	if p_effect == null:
		@warning_ignore("return_value_discarded")
		_pre_waveform_points.resize(_SAMPLES_PER_SECOND * p_length)
		_pre_waveform_points.fill(0.0)
		return _pre_waveform_points
	
	if p_effect.can_get_buffer(_SAMPLES_PER_SECOND):
		_temporary_stereo_buffer = p_effect.get_buffer(_SAMPLES_PER_SECOND)
		@warning_ignore("return_value_discarded")
		_audio_data_dictionary.set(p_effect, _temporary_stereo_buffer)
	elif _audio_data_dictionary.has(p_effect):
		_temporary_stereo_buffer = _audio_data_dictionary.get(p_effect)
	
	@warning_ignore("return_value_discarded")
	_temporary_average_buffer.resize(_SAMPLES_PER_SECOND)
	_sample_index = 0
	for sample: Vector2 in _temporary_stereo_buffer:
		_average_sample = (sample.x + sample.y) * 0.5
		_temporary_average_buffer[_sample_index] = _average_sample
		_sample_index += 1
	if p_length < _temporary_distributed_audio_samples.size():
		@warning_ignore("return_value_discarded")
		_temporary_distributed_audio_samples.resize(p_length)
	_temporary_distributed_audio_samples.append_array([_temporary_average_buffer.duplicate()])
	if _temporary_distributed_audio_samples.size() > p_length:
		_temporary_distributed_audio_samples.remove_at(0)
	_distributed_audio_samples = _temporary_distributed_audio_samples
	
	_pre_waveform_points.clear()
	for buffer: PackedFloat32Array in _distributed_audio_samples:
		_pre_waveform_points.append_array(buffer)
	
	return _pre_waveform_points
