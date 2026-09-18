# Oscillody
# Copyright (C) 2025-present Akosmo

# element_with_audio.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

@abstract
class_name ElementWithAudio
extends Element

const SN_AUDIO_SOURCE: StringName = &"Audio_Source"

var _audio_source: StringName = &""

func set_audio_source(p_value: StringName) -> void:
	_audio_source = p_value
	property_changed.emit(SN_AUDIO_SOURCE)

func get_audio_source() -> StringName:
	return _audio_source

@abstract func get_properties() -> Dictionary[StringName, Variant]

@abstract func get_setters() -> Dictionary[StringName, StringName]
