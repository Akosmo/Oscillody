# Oscillody
# Copyright (C) 2025-present Akosmo

# audio_manager.gd is part of Oscillody.
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
## Manager class that handles audio playback.
##
## This class is used for communications between the player control and [AudioStreamPlayer]s under the
## visualizer.

## Emitted whenever the list of streams in the UI is updated, including an updated [member _master_name].
signal stream_list_updated
## Emitted whenever a different stream is set as Master (audible).
signal master_changed

## Emitted whenever the player control attempts to play or pause the Master stream player.
signal play_pause_requested
## Emitted whenever the player control attempts to stop the Master stream player.
signal stop_requested
## Emitted whenever the player control attempts to change the volume of the Master stream player.
signal volume_change_requested
## Emitted whenever the player control attempts to seek a position in the Master stream player.
## [param p_time] sets the position at which the player will seek to.
signal seek_requested(p_time: float)

## Emitted whenever [member _is_master_playing] changes.
signal master_play_state_changed

## Holds all imported audio files, as [AudioStream]s. It will have the appropriate type based on the
## files extention. For example, a [code].mp3[/code] file is imported as [AudioStreamMP3].
## See [method test_and_import_audio_files].
var _streams: Dictionary[StringName, AudioStream]
## The name of the Master stream, based on a key found in [member _streams].
var _master_name: StringName
var _stream_names: Dictionary[StringName, StringName]
var _is_master_playing: bool
var _is_loop_enabled: bool
var _master_volume: float = 1.0

var _time_position: float = 0.0
var _time_duration: float = 0.0

## Emits [signal play_pause_requested], connected to an [AudioStreamPlayer].
func request_play_pause() -> void:
	play_pause_requested.emit()

## Emits [signal stop_requested], connected to an [AudioStreamPlayer].
func request_stop() -> void:
	_time_position = 0.0
	stop_requested.emit()

## Emits [signal volume_change_requested], connected to an [AudioStreamPlayer].
func request_volume_change(p_volume_linear: float) -> void:
	_master_volume = p_volume_linear
	volume_change_requested.emit()

## Returns the current volume of the Master player.
func get_master_volume() -> float:
	return _master_volume

## Emits [signal seek_requested], connected to an [AudioStreamPlayer].
func request_seek(p_time: float) -> void:
	if not _is_master_playing: # Allow seeking to work if Master is not playing.
		_time_position = p_time
	seek_requested.emit(p_time)

## Emits [signal master_play_state_changed], connected to the player control.[br]
## [b]Note:[/b] This is different than [method request_play_pause], as it does not actually makes the
## Master [AudioStreamPlayer] play. Must be set manually.
func set_master_playing(p_playing: bool) -> void:
	_is_master_playing = p_playing
	master_play_state_changed.emit()

## Returns [code]true[/code] if the Master [AudioStreamPlayer] is playing.
func is_master_playing() -> bool:
	return _is_master_playing

## If [param p_enable] is [code]true[/code], loop is enabled.
func enable_loop(p_enable: bool) -> void:
	_is_loop_enabled = p_enable

## Returns [code]true[/code] if loop is enabled.
func is_loop_enabled() -> bool:
	return _is_loop_enabled

## Sets the current time position of the Master player.
func set_master_position(p_time: float) -> void:
	_time_position = p_time

## Returns the current time position of the Master player.
func get_master_position() -> float:
	return _time_position

## Sets the current time duration of the Master player.
func set_master_duration(p_time: float) -> void:
	_time_duration = p_time

## Returns the current time duration of the Master player.
func get_master_duration() -> float:
	return _time_duration

## Returns a deep copy of [member _streams].
func get_streams() -> Dictionary[StringName, AudioStream]:
	return _streams.duplicate_deep(Resource.DeepDuplicateMode.DEEP_DUPLICATE_ALL)

func get_stream_names() -> Dictionary[StringName, StringName]:
	return _stream_names.duplicate_deep(Resource.DeepDuplicateMode.DEEP_DUPLICATE_ALL)

## Changes the selected Master, based on its key in [member _streams].
func set_master_name(p_name: StringName) -> void:
	CustomLogger.log_normal("Setting master name to: " + p_name)
	
	if p_name not in _stream_names.values() and not p_name.is_empty():
		CustomLogger.log_critical_error("Master not in streams dictionary.")
		return
	
	_master_name = p_name

## Returns the name of the selected Master.
func get_master_name() -> StringName:
	return _master_name

## Emits [signal master_changed], and also [signal stream_list_updated] beforehand
## if [param p_setup] is [code]true[/code].
func notify_updated_streams(p_setup: bool) -> void:
	if p_setup:
		stream_list_updated.emit()
	master_changed.emit()

## Clear [member _streams].
func clear_streams() -> void:
	_streams.clear()
	_stream_names.clear()
	_time_duration = 0.0

func notify_cleared_streams() -> void:
	master_play_state_changed.emit()

## Converts audio file to the appropriate [AudioStream] type. If the conversion is successful,
## the stream is added to [member _streams], with its path as the key. Otherwise, returns
## [constant @GlobalScope.FAILED].
func import_audio_files(p_path: String) -> Error:
	if p_path.is_empty():
		CustomLogger.log_error("Audio path is empty.")
		return Error.FAILED
	
	CustomLogger.log_normal("Importing audio file: " + p_path.get_file())
	
	match p_path.get_extension():
		"mp3":
			var stream: AudioStreamMP3 = AudioStreamMP3.load_from_file(p_path)
			if stream == null:
				CustomLogger.log_error("{path} could not be set as stream.".format({"path": p_path}))
				return Error.FAILED
			if not _streams.set(StringName(p_path), stream):
				CustomLogger.log_critical_error("Could not set stream to streams dictionary.")
				return Error.FAILED
			if not _stream_names.set(StringName(p_path), StringName(p_path.get_file().get_basename())):
				CustomLogger.log_critical_error("Could not set stream name to path dictionary.")
				return Error.FAILED
		"wav":
			var stream: AudioStreamWAV = AudioStreamWAV.load_from_file(p_path)
			if stream == null:
				CustomLogger.log_error(
					"{path} could not be set as stream. \
If it's .wav, make sure it has no more than 2 channels, \
and is either uncompressed PCM or IEEE float format.".format({"path": p_path})
				)
				return Error.FAILED
			if stream.get_format() >= 2:
				CustomLogger.log_warning("Imported stream was lossily compressed.")
			if not _streams.set(StringName(p_path), stream):
				CustomLogger.log_critical_error("Could not set stream to streams dictionary.")
				return Error.FAILED
			if not _stream_names.set(StringName(p_path), StringName(p_path.get_file().get_basename())):
				CustomLogger.log_critical_error("Could not set stream name to path dictionary.")
				return Error.FAILED
		"ogg":
			var stream: AudioStreamOggVorbis = AudioStreamOggVorbis.load_from_file(p_path)
			if stream == null:
				CustomLogger.log_error(
					"{path} could not be set as stream. \
If it's .ogg, make sure it's a Vorbis \
audio in the Ogg file container.".format({"path": p_path})
				)
				return Error.FAILED
			if not _streams.set(StringName(p_path), stream):
				CustomLogger.log_critical_error("Could not set stream to streams dictionary.")
				return Error.FAILED
			if not _stream_names.set(StringName(p_path), StringName(p_path.get_file().get_basename())):
				CustomLogger.log_critical_error("Could not set stream name to path dictionary.")
				return Error.FAILED
		_:
			CustomLogger.log_error("{path} does not contain valid audio extension.".format({"path": p_path}))
			return Error.FAILED
	
	return Error.OK
