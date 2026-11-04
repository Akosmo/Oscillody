# Oscillody
# Copyright (C) 2025-present Akosmo

# debug_container.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

extends PanelContainer

var _format_dictionary: Dictionary[String, Variant]

@onready var _tab_container: TabContainer = $MarginContainer/TabContainer

@onready var _general_label: Label = %GeneralLabel
@onready var _files_label: Label = %FilesLabel
@onready var _visualizer_label: Label = %VisualizerLabel
@onready var _settings_label: Label = %SettingsLabel
@onready var _log_label: Label = %LogLabel
@onready var _freeze_button: Button = %FreezeButton

func _ready() -> void:
	if not _freeze_button.is_pressed():
		_freeze_button.set_text("Freeze Visualizer")
	else:
		_freeze_button.set_text("Unfreeze Visualizer")
	
	SettingsManager.debug_visibility_changed.connect(_on_debug_visibility_changed)
	
	_freeze_button.toggled.connect(_on_freeze_button_toggled)

func _process(_delta: float) -> void:
	#if Engine.get_process_frames() % 60 != 0:
		#return
	
	if not is_visible() or _tab_container.get_current_tab() == 5:
		return
	
	# TODO: Fix any awkward spacing in the resulting text.
	match _tab_container.get_current_tab():
		0:
			_format_dictionary = {
				"FPS": int(Engine.get_frames_per_second()),
				"Sample_Rate": int(AudioServer.get_mix_rate()),
				"Export_Sample_Rate": ProjectSettings.get_setting("editor/movie_writer/mix_rate"),
				"Input_Sample_Rate": int(AudioServer.get_input_mix_rate()),
				"Number_Of_Channels": AudioServer.get_bus_channels(0) * 2,
				"Audio_Driver": AudioServer.get_driver_name(),
				"Output_Latency": roundi(AudioServer.get_output_latency() * 1000.0),
				"Monitor_Resolution": DisplayServer.screen_get_size(),
				"Rendering_Method": RenderingServer.get_current_rendering_method(),
				"Window_Size": WindowUtilities.get_window_size(),
				"Visualizer_Size": WindowUtilities.get_subviewport().get_size(),
				"Time_Since_Launch": str(Time.get_ticks_msec() / 1000.0).pad_decimals(2),
				"Unix_Time": str(Time.get_unix_time_from_system()).pad_decimals(2),
				"Update_Last_Checked_At": SettingsManager.get_update_last_checked_at(),
				"Memory_Usage": String.humanize_size(
					RenderingServer.get_rendering_device().get_memory_usage(RenderingDevice.MEMORY_TOTAL)
				),
				"Version": ProjectSettings.get_setting("application/config/version"),
				"Engine_Version": Engine.get_version_info().get("string"),
				"Audio_Input": ProjectSettings.get_setting("audio/driver/enable_input"),
			}
			_general_label.set_text(
				"FPS: {FPS}
				Sample Rate: {Sample_Rate} Hz
				Export Sample Rate: {Export_Sample_Rate} Hz
				Input Sample Rate: {Input_Sample_Rate} Hz
				Number of Channels: {Number_Of_Channels}
				Audio Driver: {Audio_Driver}
				Output Latency: {Output_Latency} ms
				Monitor Resolution: {Monitor_Resolution}
				Rendering Method: {Rendering_Method}
				Window Size: {Window_Size}
				Visualizer Size: {Visualizer_Size}
				Time Since Launch: {Time_Since_Launch} secs
				Unix Time: {Unix_Time} secs
				Update Last Checked At: {Update_Last_Checked_At}
				Memory Usage: {Memory_Usage}
				Version: {Version}
				Engine Version: {Engine_Version}
				Audio Input: {Audio_Input}".format(_format_dictionary)
			)
		1:
			var imported_audio_files: String = ""
			var stream_names: Array[StringName] = AudioManager.get_stream_names().keys()
			for stream_name: StringName in stream_names:
				var line_str: String = "    {file},\n".format({"file": stream_name.get_file()})
				imported_audio_files += line_str
			#imported_audio_files += "]"
			var full_bus_info_str: String = ""
			for bus_idx: int in AudioServer.get_bus_count():
				var line_str: String = \
				"Name: {name}, Muted: {muted}, Number of Effects: {number_of_effects}".format(
					{
						"name": AudioServer.get_bus_name(bus_idx),
						"muted": AudioServer.is_bus_mute(bus_idx),
						"number_of_effects": AudioServer.get_bus_effect_count(bus_idx)
					}
				)
				if not bus_idx == AudioServer.get_bus_count() - 1:
					line_str += "\n"
				full_bus_info_str += line_str
			var full_player_info_str: String = ""
			var audio_players: Dictionary[StringName, AudioStreamPlayer] = DebugUtilities.get_audio_players()
			var audio_players_array: Array[StringName] = audio_players.keys()
			for player_name: StringName in audio_players_array:
				var audio_player: AudioStreamPlayer = audio_players.get(player_name) as AudioStreamPlayer
				var single_player_info_str: String = \
				"- Name: {name}
				- Bus: {bus}
				- Playing: {playing}
				- Paused: {paused}
				- Time: {time}".format(
					{
						"name": player_name,
						"bus": audio_player.get_bus(),
						"playing": audio_player.is_playing(),
						"paused": audio_player.get_stream_paused(),
						"time": str(audio_player.get_playback_position()).pad_decimals(2)
					}
				)
				if not player_name == audio_players_array[-1]:
					single_player_info_str += "\n-------\n"
				full_player_info_str += single_player_info_str
			_format_dictionary = {
				"Preset": FileManager.get_selected_preset(),
				"Master": AudioManager.get_master_name(),
				"Imported_Audio_Files": imported_audio_files,
				"Audio_Buses": full_bus_info_str,
				"Audio_Players": full_player_info_str
			}
			_files_label.set_text(
				"Preset: {Preset}
				Master: {Master}
				\nImported Audio Files: \n{Imported_Audio_Files}
				\nAudio Buses:\n{Audio_Buses}
				\nAudio Players:\n{Audio_Players}".format(_format_dictionary)
			)
		2:
			var full_element_dict_str: String = ""
			var element_array: Array[Element] = ElementManager.get_elements(false)
			#if not element_array.is_empty():
				#full_element_dict_str = "{\n"
			for element: Element in element_array:
				full_element_dict_str += "{\n"
				var element_properties: Dictionary[StringName, Variant] = element.get_properties()
				for property_key: StringName in element_properties.keys():
					var str_line: String = "    {key}: {value},\n".format(
						{"key": String(property_key), "value": str(element_properties.get(property_key))}
					)
					full_element_dict_str += str_line
				full_element_dict_str += "}\n"
			_format_dictionary = {
				"Next_Element_Unique_ID": DebugUtilities.get_element_next_unique_id(),
				"Element_Count": ElementManager.get_element_count(),
				"Element_Container_Count": DebugUtilities.get_element_container_count(),
				"Element_Properties_Container_Count": DebugUtilities.get_element_properties_container_count(),
				"Element_Canvas_Count": DebugUtilities.get_element_canvas_count(),
				"Elements": full_element_dict_str
			}
			_visualizer_label.set_text(
				"Next Element Unique ID: {Next_Element_Unique_ID}
				Element Count: {Element_Count}
				Element Container Count: {Element_Container_Count}
				Element Properties Container Count: {Element_Properties_Container_Count}
				Element Canvas Count: {Element_Canvas_Count}
				\nElements: \n{Elements}".format(_format_dictionary)
			)
		3:
			_format_dictionary = {
				"Input_Device": AudioServer.get_input_device(),
				"Output_Device": AudioServer.get_output_device(),
				"Export_Resolution": SettingsManager.get_export_resolution(),
				"FFmpeg_Status": not SettingsManager.get_ffmpeg_path().is_empty(),
				"App_Theme": SettingsManager.get_app_theme()
			}
			_settings_label.set_text(
				"Input Device: {Input_Device}
				Output Device: {Output_Device}
				Export Resolution: {Export_Resolution}
				FFmpeg Status: {FFmpeg_Status}
				App Theme: {App_Theme}".format(_format_dictionary)
			)
		4:
			_log_label.set_text(DebugUtilities.get_log_text())

func _on_debug_visibility_changed() -> void:
	set_visible(SettingsManager.get_debug_panel())

func _on_freeze_button_toggled(p_toggled_on: bool) -> void:
	if not p_toggled_on:
		_freeze_button.set_text("Freeze Visualizer")
	else:
		_freeze_button.set_text("Unfreeze Visualizer")
	
	DebugUtilities.freeze_visualizer_changed.emit(p_toggled_on)
