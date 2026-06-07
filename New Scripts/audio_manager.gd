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

class_name AudioManager
extends Node

@warning_ignore("unused_signal")
signal audio_files_changed(p_paths: PackedStringArray)

static var _streams: Dictionary[StringName, AudioStream]
static var _master: StringName

func _ready() -> void:
	var err: Error = audio_files_changed.connect(_test_audio_files_and_import) as Error
	if err:
		printerr("Could not connect signal.")

func _test_audio_files_and_import(p_paths: PackedStringArray) -> Error:
	if p_paths.is_empty():
		return FAILED
	else:
		for path: String in p_paths:
			if not path.is_empty():
				var filename: String = path.get_file()
				if path.get_extension() == "mp3":
					var stream: AudioStreamMP3 = AudioStreamMP3.load_from_file(path)
					if stream == null:
						printerr("{filename} could not be set as stream.".format({"filename": filename}))
						return FAILED
					var err_bool: bool = _streams.set(
						StringName(filename.rstrip("." + filename.get_extension())), stream
					)
					if not err_bool:
						printerr("Could not set stream to streams dictionary.")
				elif path.get_extension() == "wav":
					var stream: AudioStreamWAV = AudioStreamWAV.load_from_file(path)
					if stream == null:
						printerr(
							"{filename} could not be set as stream. \
If it's .wav, make sure it has no more than 2 channels, \
and prefer 16bit depth".format({"filename": filename})
						)
						return FAILED
					var err_bool: bool = _streams.set(
						StringName(filename.rstrip("." + filename.get_extension())), stream
					)
					if not err_bool:
						printerr("Could not set stream to streams dictionary.")
				elif path.get_extension() == "ogg":
					var stream: AudioStreamOggVorbis = AudioStreamOggVorbis.load_from_file(path)
					if stream == null:
						printerr(
							"{filename} could not be set as stream. \
If it's .ogg, make sure it's a Vorbis \
audio in the Ogg file container.".format({"filename": filename})
						)
						return FAILED
					var err_bool: bool = _streams.set(
						StringName(filename.rstrip("." + filename.get_extension())), stream
					)
					if not err_bool:
						printerr("Could not set stream to streams dictionary.")
				else:
					printerr("{filename} does not contain valid audio extension.".format(
						{"filename": filename})
					)
					return FAILED
			else:
				printerr("Audio path is empty.")
				return FAILED
		
	return OK

func get_streams() -> Dictionary[StringName, AudioStream]:
	return _streams.duplicate_deep(Resource.DeepDuplicateMode.DEEP_DUPLICATE_ALL)

func set_master(p_name: StringName) -> void:
	if p_name not in _streams.keys():
		printerr("Master not in streams dictionary.")
		return
	
	_master = p_name

func get_master() -> StringName:
	return _master
