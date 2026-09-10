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

var _capture_effect: AudioEffectCapture
var _sample_history_length: int

var _temporary_stereo_buffer: PackedVector2Array
var _temporary_average_buffer: PackedFloat32Array
var _sample_index: int
var _average_sample: float
var _distributed_audio_samples: Array[PackedFloat32Array]
var _temporary_distributed_audio_samples: Array[PackedFloat32Array]
var _pre_waveform_points: PackedFloat32Array

var _spectrum_analyzer_effect_instance: AudioEffectSpectrumAnalyzerInstance
var _begin_frequency: int
var _end_frequency: int
var _minimum_decibels: int
var _smoothing_type: ElementReactive.ReactiveSmoothingType
var _smoothing_amount: float

var _magnitude_stereo: Vector2
var _current_magnitude: float
var _previous_magnitude: float

func get_samples_per_second() -> int:
	return _SAMPLES_PER_SECOND

func _get_distributed_audio_samples_size() -> int:
	return _distributed_audio_samples.size()

func set_capture_effect(p_effect: AudioEffectCapture) -> void:
	_capture_effect = p_effect

func set_sample_history_length(p_length: int) -> void:
	_sample_history_length = p_length

func get_waveform_data() -> PackedFloat32Array:
	if _capture_effect == null or _sample_history_length == null or _sample_history_length < 1:
		@warning_ignore("return_value_discarded")
		_pre_waveform_points.resize(_SAMPLES_PER_SECOND * _sample_history_length)
		_pre_waveform_points.fill(0.0)
		return _pre_waveform_points
	
	if _capture_effect.can_get_buffer(_SAMPLES_PER_SECOND):
		_temporary_stereo_buffer = _capture_effect.get_buffer(_SAMPLES_PER_SECOND)
		@warning_ignore("return_value_discarded")
		_audio_data_dictionary.set(_capture_effect, _temporary_stereo_buffer)
	elif _audio_data_dictionary.has(_capture_effect):
		_temporary_stereo_buffer = _audio_data_dictionary.get(_capture_effect)
	
	@warning_ignore("return_value_discarded")
	_temporary_average_buffer.resize(_SAMPLES_PER_SECOND)
	_sample_index = 0
	for sample: Vector2 in _temporary_stereo_buffer:
		_average_sample = (sample.x + sample.y) * 0.5
		_temporary_average_buffer[_sample_index] = _average_sample
		_sample_index += 1
	if _sample_history_length < _temporary_distributed_audio_samples.size():
		@warning_ignore("return_value_discarded")
		_temporary_distributed_audio_samples.resize(_sample_history_length)
	_temporary_distributed_audio_samples.append_array([_temporary_average_buffer.duplicate()])
	if _temporary_distributed_audio_samples.size() > _sample_history_length:
		_temporary_distributed_audio_samples.remove_at(0)
	_distributed_audio_samples = _temporary_distributed_audio_samples
	
	_pre_waveform_points.clear()
	for buffer: PackedFloat32Array in _distributed_audio_samples:
		_pre_waveform_points.append_array(buffer)
	
	return _pre_waveform_points

func set_spectrum_analyzer_effect_instance(p_effect: AudioEffectSpectrumAnalyzerInstance) -> void:
	_spectrum_analyzer_effect_instance = p_effect

func set_begin_frequency(p_frequency: int) -> void:
	_begin_frequency = p_frequency

func set_end_frequency(p_frequency: int) -> void:
	_end_frequency = p_frequency

func set_minimum_decibels(p_decibels: int) -> void:
	_minimum_decibels = p_decibels

func set_smoothing_type(p_type: ElementReactive.ReactiveSmoothingType) -> void:
	_smoothing_type = p_type

func set_smoothing_amount(p_amount: float) -> void:
	_smoothing_amount = p_amount

func get_current_magnitude() -> float:
	if (
		not AudioManager.is_master_playing() or
		_spectrum_analyzer_effect_instance == null or
		_begin_frequency == null or
		(_begin_frequency < 20 and _begin_frequency > 60) or
		_end_frequency == null or
		(_begin_frequency < 60 and _begin_frequency > 150) or
		_minimum_decibels == null or
		(_minimum_decibels < -100 and _minimum_decibels > -10) or
		_smoothing_type == null or
		_smoothing_amount == null or
		(_smoothing_amount < 0.1 and _smoothing_amount > 1.0)
	):
		return 0.0
	
	_magnitude_stereo = _spectrum_analyzer_effect_instance.get_magnitude_for_frequency_range(
		float(_begin_frequency),
		float(_end_frequency),
		AudioEffectSpectrumAnalyzerInstance.MAGNITUDE_MAX
	)
	_current_magnitude = clampf(
		(float(_minimum_decibels * -1.0) + \
		linear_to_db(float(_magnitude_stereo.x + _magnitude_stereo.y * 0.5))) / \
		float(_minimum_decibels * -1.0),
		0.0,
		1.0
	)
	
	match _smoothing_type:
		# TODO: Figure out if it makes sense to keep this type.
		ElementReactive.ReactiveSmoothingType.BOTH:
			if is_equal_approx(_smoothing_amount, 1.0):
				_smoothing_amount = 0.95
			_current_magnitude = _smoothing_amount * _previous_magnitude + \
			(1 - _smoothing_amount) * abs(_current_magnitude)
			if is_equal_approx(_smoothing_amount, 0.95):
				_smoothing_amount = 1.0
			if _current_magnitude < _previous_magnitude:
				_current_magnitude = _previous_magnitude - (0.1 - (_smoothing_amount * 0.1) + 0.01)
		ElementReactive.ReactiveSmoothingType.DECAY:
			if is_equal_approx(_smoothing_amount, 0.95):
				_smoothing_amount = 1.0
			if _current_magnitude < _previous_magnitude:
				_current_magnitude = _previous_magnitude - (0.1 - (_smoothing_amount * 0.1) + 0.01)
		ElementReactive.ReactiveSmoothingType.INTERPOLATION:
			if is_equal_approx(_smoothing_amount, 1.0):
				_smoothing_amount = 0.95
			_current_magnitude = _smoothing_amount * _previous_magnitude + \
			(1 - _smoothing_amount) * abs(_current_magnitude)
		ElementReactive.ReactiveSmoothingType.NONE:
			if is_equal_approx(_smoothing_amount, 0.95):
				_smoothing_amount = 1.0
	
	_previous_magnitude = _current_magnitude
	
	return clampf(_current_magnitude, 0.0, 1.0)
