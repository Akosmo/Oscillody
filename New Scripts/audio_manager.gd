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

# TODO: Disallow loading the same audio file.

class_name AudioManager
extends Node
## Manager class for audio.
##
## This class is used for communications between the player control, [AudioStreamPlayer]s under the
## visualizer, and any other nodes that need access to current audio data (such as [Waveform]).

## Emitted whenever new audio files are imported, or existing ones are cleared from Oscillody.
signal audio_files_changed
## Emitted whenever a different stream is set as master (audible).
signal master_changed

## Emitted whenever the player control attempts to play or pause the master stream player.
signal play_pause_requested
## Emitted whenever the player control attempts to stop the master stream player.
signal stop_requested
## Emitted whenever the player control attempts to change the volume of the master stream player.
signal volume_change_requested
## Emitted whenever the player control attempts to seek a position in the master stream player.
## [param p_time] sets the position at which the player will seek to.
signal seek_requested(p_time: float)

## Emitted whenever [member _is_master_playing] changes.
signal master_play_state_changed

## Holds all imported audio files, as [AudioStream]s. It will have the appropriate type based on the
## files extention. For example, a [code].mp3[/code] file is imported as [AudioStreamMP3].
## See [method test_and_import_audio_files].
static var _streams: Dictionary[StringName, AudioStream]
static var _master_name: StringName
static var _is_master_playing: bool
static var _is_loop_enabled: bool
static var _master_volume: float = 1.0

## Emits [signal play_pause_requested], connected to an [AudioStreamPlayer].
func request_play_pause() -> void:
	play_pause_requested.emit()

## Emits [signal stop_requested], connected to an [AudioStreamPlayer].
func request_stop() -> void:
	stop_requested.emit()

## Emits [signal volume_change_requested], connected to an [AudioStreamPlayer].
func request_volume_change(p_volume_linear: float) -> void:
	_master_volume = p_volume_linear
	volume_change_requested.emit()

func get_master_volume() -> float:
	return _master_volume

## Emits [signal seek_requested], connected to an [AudioStreamPlayer].
func request_seek(p_time: float = 0.0) -> void:
	seek_requested.emit(p_time)

## Emits [signal master_play_state_changed], connected to the player control.
func set_master_playing(p_playing: bool) -> void:
	_is_master_playing = p_playing
	master_play_state_changed.emit()

## Returns [code]true[/code] if the master [AudioStreamPlayer] is playing.
func is_master_playing() -> bool:
	return _is_master_playing

## Enables loop.
func enable_loop(p_enable: bool) -> void:
	_is_loop_enabled = p_enable

## Returns [code]true[/code] if loop is enabled.
func is_loop_enabled() -> bool:
	return _is_loop_enabled

## Returns the duration of the currently selected master stream.
func get_master_duration() -> float:
	var stream: AudioStream = _streams.get(_master_name)
	return stream.get_length()

## Returns a deep copy of [member _streams].
func get_streams() -> Dictionary[StringName, AudioStream]:
	return _streams.duplicate_deep(Resource.DeepDuplicateMode.DEEP_DUPLICATE_ALL)

## Changes the selected master, based on its key in [member _streams].
func set_master_name(p_name: StringName) -> void:
	if p_name not in _streams.keys() and not p_name.is_empty():
		printerr("Master not in streams dictionary.")
		return
	
	_master_name = p_name
	
	master_changed.emit()

## Returns the name of the selected master.
func get_master_name() -> StringName:
	return _master_name

## Clear [member _streams].
func clear_streams() -> void:
	_streams.clear()
	
	audio_files_changed.emit()
	master_play_state_changed.emit()

## Converts audio files to the appropriate [AudioStream] type. If the conversion is successful,
## the stream is added to [member _streams], with its filename as the key. Otherwise, returns
## [constant @GlobalScope.FAILED].
func test_and_import_audio_files(p_paths: PackedStringArray) -> Error:
	if p_paths.is_empty():
		return FAILED
	
	for path: String in p_paths:
		if path.is_empty():
			printerr("Audio path is empty.")
			return FAILED
			
		var filename: String = path.get_file()
		match filename.get_extension():
			"mp3":
				var stream: AudioStreamMP3 = AudioStreamMP3.load_from_file(path)
				if stream == null:
					printerr("{filename} could not be set as stream.".format({"filename": filename}))
					return FAILED
				if not _streams.set(StringName(filename.rstrip("." + filename.get_extension())), stream):
					printerr("Could not set stream to streams dictionary.")
			"wav":
				var stream: AudioStreamWAV = AudioStreamWAV.load_from_file(path)
				if stream == null:
					printerr(
						"{filename} could not be set as stream. \
If it's .wav, make sure it has no more than 2 channels, \
and prefer 16bit depth".format({"filename": filename})
					)
					return FAILED
				if not _streams.set(StringName(filename.rstrip("." + filename.get_extension())), stream):
					printerr("Could not set stream to streams dictionary.")
			"ogg":
				var stream: AudioStreamOggVorbis = AudioStreamOggVorbis.load_from_file(path)
				if stream == null:
					printerr(
						"{filename} could not be set as stream. \
If it's .ogg, make sure it's a Vorbis \
audio in the Ogg file container.".format({"filename": filename})
					)
					return FAILED
				if not _streams.set(StringName(filename.rstrip("." + filename.get_extension())), stream):
					printerr("Could not set stream to streams dictionary.")
			_:
				printerr("{filename} does not contain valid audio extension.".format(
					{"filename": filename})
				)
				return FAILED
	
	audio_files_changed.emit()
	
	return OK
