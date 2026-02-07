# Oscillody
# Copyright (C) 2025-present Akosmo

# This file is part of Oscillody. Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

extends Node

# This script is a singleton (autoload) and holds properties mostly related to how the visualizer looks.

#region JSON, PRESETS, AND PATHS ##################################

const AUDIO_FOR_RENDER: String = "audio_for_render"
const RENDER_PRESET_FILENAME: String = "render_preset"

var presets_in_selector: PackedStringArray = []
var preset_name: String = "Default"

var master_audio_path: String:
	set(new_path):
		master_audio_path = new_path
		MainUtils.audio_file_selected.emit()
		MainUtils.new_audio_master_selected.emit()
var stem_1_audio_path: String:
	set(new_path):
		stem_1_audio_path = new_path
		if new_path != "":
			MainUtils.audio_file_selected.emit()
var stem_2_audio_path: String:
	set(new_path):
		stem_2_audio_path = new_path
		if new_path != "":
			MainUtils.audio_file_selected.emit()
var stem_3_audio_path: String:
	set(new_path):
		stem_3_audio_path = new_path
		if new_path != "":
			MainUtils.audio_file_selected.emit()
var stem_4_audio_path: String:
	set(new_path):
		stem_4_audio_path = new_path
		if new_path != "":
			MainUtils.audio_file_selected.emit()

var presets_path: String = OS.get_executable_path().get_base_dir() + "/Presets/"
var render_info_path: String = OS.get_executable_path().get_base_dir() + "/Render Info/"

#endregion ##################################

#region SPECTRUM VARIABLES ##################################

const SPECTRUM_DATA_SOURCES_IN_SELECTOR: PackedStringArray = [
	"Master",
	"Stem 1",
	"Stem 2",
	"Stem 3",
	"Stem 4"
]
var spectrum_data_source: String = SPECTRUM_DATA_SOURCES_IN_SELECTOR[0]:
	set(new_source):
		spectrum_data_source = new_source
		if not OS.has_feature("movie"):
			MainUtils.spectrum_data_source_selected.emit()

#endregion ##################################

#region VISUALIZER SETTINGS ##################################

var number_of_stems: int = 1
var vertical_layout: bool = false
var include_dividers: bool = true

var title: String = ""
var title_fonts_in_selector: PackedStringArray = OS.get_system_fonts()
var title_font: String = "Calibri"
var title_font_bold: bool = false
var title_font_italic: bool = false
var title_position: Vector2i = Vector2i(50, 94)
var title_color: Color = Color.WHITE
var title_size: int = 65
var title_shadow_color: Color = Color.BLACK
var title_shadow_position: Vector2i = Vector2i(-4, 4)
var title_outline_color: Color = Color.BLACK
var title_outline_size: int = 0

var divider_colors: PackedColorArray = [Color.WHITE, Color.WHITE, Color.WHITE]
var divider_thickness: int = 2

const BACKGROUND_TYPES_IN_SELECTOR: PackedStringArray = [
	"Current Flow",
	"Domain Warping",
	"Echoes",
	"Image",
	"Isolines",
	"Simple Gradient",
	"Solid Colors",
	"Tides"
	]
var background_type: String = BACKGROUND_TYPES_IN_SELECTOR[6]

var current_flow_main_color: Color = Color(0.282, 0.282, 0.847)
var current_flow_background_color: Color = Color(0.063, 0.063, 0.094)
var current_flow_filled: bool = false
var current_flow_uv_scale: float = 5.0
var current_flow_iterations: float = 10.0
var current_flow_wave_thickness: float = 0.05
var current_flow_speed: float = 2.0

var domain_warping_color: Color = Color(0.282, 0.282, 0.847)
var domain_warping_color_mix: bool = false
var domain_warping_invert_colors: bool = false
var domain_warping_hue_shift: float = 0.0
var domain_warping_octaves: int = 6
var domain_warping_frequency_factor: float = 2.0
var domain_warping_amplitude: float = 5.0
var domain_warping_frequency_increment: float = 2.0
var domain_warping_amplitude_decrement: float = 5.0
var domain_warping_speed: float = 2.0

var echoes_main_color: Color = Color(0.282, 0.282, 0.847)
var echoes_background_color: Color = Color(0.063, 0.063, 0.094)
var echoes_fractal_uv: bool = false
var echoes_change_origin: bool = false
var echoes_iterations: int = 8
var echoes_uv_scale: float = 1.0
var echoes_vector_scale_1: float = 1.0
var echoes_iterator_factor_1: float = 1.0
var echoes_uv_length_factor: float = 1.0
var echoes_vector_scale_2: float = 1.0
var echoes_iterator_factor_2: float = 1.0
var echoes_time_scale: float = 1.0
var echoes_iterator_factor_3: float = 1.0
var echoes_distance_scale: float = 1.0
var echoes_pulse_frequency: float = 0.1
var echoes_line_thickness: float = 0.1
var echoes_iterator_factor_4: float = 1.0
var echoes_assignment_mode_1: int = 0
var echoes_thickness_variation: int = 0
var echoes_assignment_mode_2: int = 0
var echoes_thin_lines: bool = false
var echoes_assignment_mode_3: bool = false
var echoes_assignment_mode_4: bool = false
var echoes_fractal_distance: bool = false
var echoes_speed: float = 2.0

var image_path: String:
	set(new_path):
		image_path = new_path
		MainUtils.image_file_selected.emit()
var image_size: int = 1
var image_opacity: int = 100
var image_blur: int = 0

var isolines_line_color: Color = Color(0.282, 0.282, 0.847)
var isolines_background_color: Color = Color(0.063, 0.063, 0.094)
var isolines_filled: bool = false
var isolines_line_thickness: float = 10.0
var isolines_thickness_variation: float = 0.0
var isolines_line_amount: float = 10.0
var isolines_uv_scale: float = 5.0
var isolines_speed: float = 2.0

var simple_gradient_color_1: Color = Color(0.282, 0.282, 0.847)
var simple_gradient_color_2: Color = Color(0.063, 0.063, 0.094)
var simple_gradient_direction: int = 1

var background_colors: PackedColorArray = [
	Color(0.063, 0.063, 0.094),
	Color(0.063, 0.063, 0.094),
	Color(0.063, 0.063, 0.094),
	Color(0.063, 0.063, 0.094)
	]

var tides_wave_color: Color = Color(0.282, 0.282, 0.847)
var tides_tint: Color = Color(0.063, 0.063, 0.094)
var tides_color_mix: bool = false
var tides_invert_colors: bool = false
var tides_hue_shift: float = 0.0
var tides_iterations: int = 6
var tides_speed: float = 2.0

var shader_brightness: float = 0.0
var shader_blur: int = 0

var background_shake_amplitude: float = 0.0
var background_shake_frequency: float = 10.0

var icon_enabled: bool = false
var icon_path: String:
	set(new_path):
		icon_path = new_path
		MainUtils.icon_file_selected.emit()
var icon_color: Color = Color.WHITE
var icon_rotation: float = 0.0
var icon_size: float = 4.0

const POST_PROCESSING_TYPES_IN_SELECTOR: PackedStringArray = [
	"Chromatic Aberration",
	"Glitch",
	"Spin/Zoom Blur",
	"Tape Distortion",
	"Scanlines",
	"Lens Distortion",
	"Gradient Overlay",
	"Vignette",
	"Bloom",
	"Grain"
	]
var post_processing_type: String = POST_PROCESSING_TYPES_IN_SELECTOR[0]

var chromatic_aberration_strength: float = 0.0

var glitch_block_offset_amount: float = 0.0
var glitch_pixel_offset_amount: float = 0.0
var glitch_speed_factor: float = 100.0

var spin_zoom_blur_change_mode: bool = false
var spin_zoom_blur_strength: float = 0.0

var tape_distortion_wave_strength: float = 0.0
var tape_distortion_wave_speed: float = 5.0
var tape_distortion_wave_frequency: float = 2.0
var tape_distortion_wave_thickness: int = 25
var tape_distortion_block_strength: float = 0.0
var tape_distortion_block_speed: float = 10.0
var tape_distortion_block_frequency: float = 4.0

var scanlines_darkness: float = 0.0
var scanlines_amount_of_lines: float = 400.0
var scanlines_interlaced_scan: bool = false
var scanlines_speed: float = 2.0

var lens_distortion_strength: float = 0.0
var lens_distortion_zoom: float = 1.0
var lens_distortion_border: bool = true
var lens_distortion_border_color: Color = Color.BLACK
var lens_distortion_chromatic_aberration_strength: float = 0.0

var gradient_overlay_color_1: Color = Color(0.0, 0.5, 1.0, 1.0)
var gradient_overlay_color_2: Color = Color(1.0, 0.0, 0.5, 1.0)
var gradient_overlay_direction: int = 1
var gradient_overlay_opacity: float = 0.0

var vignette_color: Color = Color.BLACK
var vignette_size: float = 0.0
var vignette_sharpness: float = 7.5

var bloom_amount: float = 0.0
var bloom_blend_mode: int = 0

var grain_static: bool = false
var grain_opacity: int = 0

const AUDIO_REACTION_CONTROLS_IN_SELECTOR: PackedStringArray = [
	"Title",
	"Background",
	"Icon",
	"Post-Processing"
	]
var audio_reaction_control: String = AUDIO_REACTION_CONTROLS_IN_SELECTOR[0]

var title_position_reaction_strength: float = 0.0
var title_size_reaction_strength: float = 0.0
var background_shader_speed_reaction_strength: float = 0.0
var background_image_size_reaction_strength: float = 0.0
var shake_amplitude_reaction_strength: float = 0.0
var shake_frequency_reaction_strength: float = 0.0
var icon_position_reaction_strength: float = 0.0
var icon_size_reaction_strength: float = 0.0
var icon_rotation_reaction_strength: float = 0.0
var chromatic_aberration_strength_reaction_strength: float = 0.0
var glitch_block_offset_reaction_strength: float = 0.0
var glitch_pixel_offset_reaction_strength: float = 0.0
var spin_zoom_blur_strength_reaction_strength: float = 0.0
var vignette_size_reaction_strength: float = 0.0
var bloom_amount_reaction_strength: float = 0.0
var audio_reaction_min_db_level: int = -40
var audio_reaction_smoothing_amount: int = 5

#endregion ##################################

#region WAVEFORM VARIABLES ##################################

var waveform_colors: PackedColorArray = [Color.WHITE, Color.WHITE, Color.WHITE, Color.WHITE]
var waveform_thickness: int = 1
var waveform_height: float = 5.0
var waveform_antialiasing: bool = true

# Waveform number, X spacing, Y position, color
var waveform_configs: Array[Variant] = [
	[1, 0.0, 0, waveform_colors[0]],
	[2, 0.0, 0, waveform_colors[1]],
	[3, 0.0, 0, waveform_colors[2]],
	[4, 0.0, 0, waveform_colors[3]]
]

#endregion ##################################

#region VIDEO VARIABLES ##################################

var video_resolution: Vector2i # Only used for loading in this script
var fallback_to_default_resolution: bool = false

#endregion ##################################

#region PROPERTY LISTS ##################################

var script_property_names: Array = get_property_list().map(get_var_name)
var script_property_types: Array = get_property_list().map(get_var_type)

var default_property_dict: Dictionary[StringName, Variant]

var exception_list: Array[StringName] = [
	"Node",
	"_import_path",
	"name",
	"unique_name_in_owner",
	"scene_file_path",
	"owner",
	"multiplayer",
	"Process",
	"process_mode",
	"process_priority",
	"process_physics_priority",
	"Thread Group",
	"process_thread_group",
	"process_thread_group_order",
	"process_thread_messages",
	"Physics Interpolation",
	"physics_interpolation_mode",
	"Auto Translate",
	"auto_translate_mode",
	"Editor Description",
	"editor_description",
	"script",
	"global_variables.gd",
	"presets_in_selector",
	"preset_name",
	"master_audio_path",
	"stem_1_audio_path",
	"stem_2_audio_path",
	"stem_3_audio_path",
	"stem_4_audio_path",
	"presets_path",
	"render_info_path",
	"spectrum_data_source",
	"title_fonts_in_selector",
	"post_processing_type",
	"audio_reaction_control",
	"waveform_configs",
	"video_resolution",
	"fallback_to_default_resolution",
	"script_property_names",
	"script_property_types",
	"default_property_dict",
	"exception_list"
]

#endregion ##################################

# Video resolution for render process can only be set in an `_init()` function, and this is the earliest
# place in the code where I can do this.
func _init() -> void:
	video_resolution = load_video_resolution() # Loading this, since it's also used in the main process
	if OS.has_feature("movie"):
		ProjectSettings.set_setting("display/window/stretch/mode", "viewport")
		ProjectSettings.set_setting("display/window/size/viewport_width", video_resolution.x)
		ProjectSettings.set_setting("display/window/size/viewport_height", video_resolution.y)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, true)

func _ready() -> void:
	if title_fonts_in_selector.is_empty():
		MainUtils.logger("Could not load system fonts.", true, true)
	title_fonts_in_selector.sort()
	
	if OS.has_feature("editor"):
		presets_path = "user://PresetsDebug/"
		render_info_path = "user://RenderInfoDebug/"
	
	var preset_arr: Array = DirAccess.get_files_at(presets_path)
	# Better sorting. Array element `a` is compared to `b` and put behind if less than 0 (returns a `true`).
	# The normal sort does "1, 10, 11, 12...19, 2, 20, 21...".
	preset_arr.sort_custom(func(a: String, b: String) -> bool: return a.naturalnocasecmp_to(b) < 0)
	for file: String in preset_arr:
		if file.ends_with(".json") and file != "render_preset.json":
			var preset_to_add: String = file.get_basename()
			presets_in_selector.append(preset_to_add)
		else:
			continue
	
	MainUtils.copy_master.connect(copy_master_path)
	MainUtils.audio_files_cleared.connect(clear_audio_files)
	
	var err_1: Error = check_for_dirs(presets_path, false)
	if err_1:
		MainUtils.logger("Could not find " + presets_path + ".", true, true)
	var err_2: Error = check_for_dirs(render_info_path, false)
	if err_2:
		MainUtils.logger("Could not find " + render_info_path + ".", true, true)
	
	for property: StringName in exception_list:
		if property in script_property_names:
			continue
		else:
			MainUtils.logger("Could not find \"" + str(property) + "\" in Exception List.", true)
	
	for property: StringName in script_property_names:
		if property not in exception_list:
			default_property_dict[property] = get(property)
		else:
			continue

func load_video_resolution() -> Vector2i:
	# Using `print()` since `MainUtils.logger()` is not defined by this point.
	var path: String = OS.get_executable_path().get_base_dir() + "/Settings/settings.json"
	if OS.has_feature("editor"):
		path = "user://SettingsDebug/settings.json"
	if FileAccess.file_exists(path):
		var json_text: String = FileAccess.get_file_as_string(path)
		if json_text.is_empty():
			fallback_to_default_resolution = true
			printerr("Can't find video resolution in \"settings.json\"")
			return Vector2i(1280, 720)
		var save_data: Variant = JSON.parse_string(json_text)
		if save_data == null:
			fallback_to_default_resolution = true
			printerr("Can't parse \"settings.json\"")
			return Vector2i(1280, 720)
		if "video_resolution" not in save_data:
			fallback_to_default_resolution = true
			printerr("No video resolution in settings.")
			return Vector2i(1280, 720)
		print("Video resolution set: " + save_data["video_resolution"])
		return str_to_vec(save_data["video_resolution"])
	else:
		fallback_to_default_resolution = true
		printerr("\"settings.json\" does not exist in " + path + ".")
		return Vector2i(1280, 720)

func copy_master_path() -> void:
	stem_1_audio_path = master_audio_path
	stem_2_audio_path = master_audio_path
	stem_3_audio_path = master_audio_path
	stem_4_audio_path = master_audio_path

func clear_audio_files() -> void:
	master_audio_path = ""
	stem_1_audio_path = ""
	stem_2_audio_path = ""
	stem_3_audio_path = ""
	stem_4_audio_path = ""

func check_for_dirs(path: String, loading: bool) -> Error:
	if not DirAccess.dir_exists_absolute(path) and not loading:
		var err: Error = DirAccess.make_dir_absolute(path)
		if err:
			MainUtils.logger("Could not recreate " + path + ". Error: " + error_string(err), true, true)
			return FAILED
	return OK

func save_audio(path: String = render_info_path) -> void:
	var err: Error = check_for_dirs(path, false)
	if err:
		MainUtils.logger("Could not save audio: " + path + " not found.", true, true)
		return
	var save_data: Dictionary[String, Variant] = {
		"master_audio_path": master_audio_path,
		"stem_1_audio_path": stem_1_audio_path,
		"stem_2_audio_path": stem_2_audio_path,
		"stem_3_audio_path": stem_3_audio_path,
		"stem_4_audio_path": stem_4_audio_path,
		"spectrum_data_source": spectrum_data_source,
		}
	var formatted_path: String = path + AUDIO_FOR_RENDER + ".json"
	var save_json: FileAccess = FileAccess.open(formatted_path, FileAccess.WRITE)
	if save_json == null:
		MainUtils.logger("Could not save audio. Error: " + error_string(FileAccess.get_open_error()), true, true)
		return
	save_json.store_line(JSON.stringify(save_data, "\t"))
	save_json.close()
	
	MainUtils.logger("Audio saved.")

func load_audio(audio_files_to_use: String = AUDIO_FOR_RENDER) -> void:
	var path: String = render_info_path + audio_files_to_use + ".json"
	if FileAccess.file_exists(path):
		var json_text: String = FileAccess.get_file_as_string(path)
		if json_text.is_empty():
			MainUtils.logger("Render audio file is empty. Close the render window.", true, true)
			return
		var save_data: Variant = JSON.parse_string(json_text)
		if save_data == null:
			MainUtils.logger("Could not parse render audio file. Close the render window.", true, true)
			return
		master_audio_path = save_data["master_audio_path"]
		stem_1_audio_path = save_data["stem_1_audio_path"]
		stem_2_audio_path = save_data["stem_2_audio_path"]
		stem_3_audio_path = save_data["stem_3_audio_path"]
		stem_4_audio_path = save_data["stem_4_audio_path"]
		spectrum_data_source = save_data["spectrum_data_source"]
		MainUtils.logger("Audio loaded.")
	else:
		MainUtils.logger(
			"Audio-related JSON file does not exist in " + render_info_path + ". Close the render window.",
			true,
			true
			)

# TODO: Add new iterating method to this function. Then repeat the process anywhere else where it saves files like
# this, and add something similar to `customize_container.gd`.
func save_preset(save_preset_name: String, path: String = presets_path) -> void:
	var err: Error = check_for_dirs(path, false)
	if err:
		MainUtils.logger("Could not save preset: " + path + " not found.", true, true)
		return
	var save_data: Dictionary[String, Variant] = {
		"number_of_stems": number_of_stems,
		"vertical_layout": vertical_layout,
		"include_dividers": include_dividers,
		"title": title,
		"title_font": title_font,
		"title_font_bold": title_font_bold,
		"title_font_italic": title_font_italic,
		"title_position": title_position,
		"title_color": title_color,
		"title_size": title_size,
		"title_shadow_color": title_shadow_color,
		"title_shadow_position": title_shadow_position,
		"title_outline_color": title_outline_color,
		"title_outline_size": title_outline_size,
		"divider_colors_1": divider_colors[0],
		"divider_colors_2": divider_colors[1],
		"divider_colors_3": divider_colors[2],
		"divider_thickness": divider_thickness,
		"background_type": background_type,
		"current_flow_main_color": current_flow_main_color,
		"current_flow_background_color": current_flow_background_color,
		"current_flow_filled": current_flow_filled,
		"current_flow_uv_scale": current_flow_uv_scale,
		"current_flow_iterations": current_flow_iterations,
		"current_flow_wave_thickness": current_flow_wave_thickness,
		"current_flow_speed": current_flow_speed,
		"domain_warping_color": domain_warping_color,
		"domain_warping_color_mix": domain_warping_color_mix,
		"domain_warping_invert_colors": domain_warping_invert_colors,
		"domain_warping_hue_shift": domain_warping_hue_shift,
		"domain_warping_octaves": domain_warping_octaves,
		"domain_warping_frequency_factor": domain_warping_frequency_factor,
		"domain_warping_amplitude": domain_warping_amplitude,
		"domain_warping_frequency_increment": domain_warping_frequency_increment,
		"domain_warping_amplitude_decrement": domain_warping_amplitude_decrement,
		"domain_warping_speed": domain_warping_speed,
		"echoes_main_color": echoes_main_color,
		"echoes_background_color": echoes_background_color,
		"echoes_fractal_uv": echoes_fractal_uv,
		"echoes_change_origin": echoes_change_origin,
		"echoes_iterations": echoes_iterations,
		"echoes_uv_scale": echoes_uv_scale,
		"echoes_vector_scale_1": echoes_vector_scale_1,
		"echoes_iterator_factor_1": echoes_iterator_factor_1,
		"echoes_uv_length_factor": echoes_uv_length_factor,
		"echoes_vector_scale_2": echoes_vector_scale_2,
		"echoes_iterator_factor_2": echoes_iterator_factor_2,
		"echoes_time_scale": echoes_time_scale,
		"echoes_iterator_factor_3": echoes_iterator_factor_3,
		"echoes_distance_scale": echoes_distance_scale,
		"echoes_pulse_frequency": echoes_pulse_frequency,
		"echoes_line_thickness": echoes_line_thickness,
		"echoes_iterator_factor_4": echoes_iterator_factor_4,
		"echoes_assignment_mode_1": echoes_assignment_mode_1,
		"echoes_thickness_variation": echoes_thickness_variation,
		"echoes_assignment_mode_2": echoes_assignment_mode_2,
		"echoes_thin_lines": echoes_thin_lines,
		"echoes_assignment_mode_3": echoes_assignment_mode_3,
		"echoes_assignment_mode_4": echoes_assignment_mode_4,
		"echoes_fractal_distance": echoes_fractal_distance,
		"echoes_speed": echoes_speed,
		"image_path": image_path,
		"image_size": image_size,
		"image_opacity": image_opacity,
		"image_blur": image_blur,
		"isolines_line_color": isolines_line_color,
		"isolines_background_color": isolines_background_color,
		"isolines_filled": isolines_filled,
		"isolines_line_thickness": isolines_line_thickness,
		"isolines_thickness_variation": isolines_thickness_variation,
		"isolines_line_amount": isolines_line_amount,
		"isolines_uv_scale": isolines_uv_scale,
		"isolines_speed": isolines_speed,
		"simple_gradient_color_1": simple_gradient_color_1,
		"simple_gradient_color_2": simple_gradient_color_2,
		"simple_gradient_direction": simple_gradient_direction,
		"background_colors_1": background_colors[0],
		"background_colors_2": background_colors[1],
		"background_colors_3": background_colors[2],
		"background_colors_4": background_colors[3],
		"tides_wave_color": tides_wave_color,
		"tides_tint": tides_tint,
		"tides_color_mix": tides_color_mix,
		"tides_invert_colors": tides_invert_colors,
		"tides_hue_shift": tides_hue_shift,
		"tides_iterations": tides_iterations,
		"tides_speed": tides_speed,
		"shader_brightness": shader_brightness,
		"shader_blur": shader_blur,
		"background_shake_amplitude": background_shake_amplitude,
		"background_shake_frequency": background_shake_frequency,
		"icon_enabled": icon_enabled,
		"icon_path": icon_path,
		"icon_color": icon_color,
		"icon_rotation": icon_rotation,
		"icon_size": icon_size,
		"chromatic_aberration_strength": chromatic_aberration_strength,
		"glitch_block_offset_amount": glitch_block_offset_amount,
		"glitch_pixel_offset_amount": glitch_pixel_offset_amount,
		"glitch_speed_factor": glitch_speed_factor,
		"spin_zoom_blur_change_mode": spin_zoom_blur_change_mode,
		"spin_zoom_blur_strength": spin_zoom_blur_strength,
		"tape_distortion_wave_strength": tape_distortion_wave_strength,
		"tape_distortion_wave_speed": tape_distortion_wave_speed,
		"tape_distortion_wave_frequency": tape_distortion_wave_frequency,
		"tape_distortion_wave_thickness": tape_distortion_wave_thickness,
		"tape_distortion_block_strength": tape_distortion_block_strength,
		"tape_distortion_block_speed": tape_distortion_block_speed,
		"tape_distortion_block_frequency": tape_distortion_block_frequency,
		"scanlines_darkness": scanlines_darkness,
		"scanlines_amount_of_lines": scanlines_amount_of_lines,
		"scanlines_interlaced_scan": scanlines_interlaced_scan,
		"scanlines_speed": scanlines_speed,
		"lens_distortion_strength": lens_distortion_strength,
		"lens_distortion_zoom": lens_distortion_zoom,
		"lens_distortion_border": lens_distortion_border,
		"lens_distortion_border_color": lens_distortion_border_color,
		"lens_distortion_chromatic_aberration_strength": lens_distortion_chromatic_aberration_strength,
		"gradient_overlay_color_1": gradient_overlay_color_1,
		"gradient_overlay_color_2": gradient_overlay_color_2,
		"gradient_overlay_direction": gradient_overlay_direction,
		"gradient_overlay_opacity": gradient_overlay_opacity,
		"vignette_color": vignette_color,
		"vignette_size": vignette_size,
		"vignette_sharpness": vignette_sharpness,
		"bloom_amount": bloom_amount,
		"bloom_blend_mode": bloom_blend_mode,
		"grain_static": grain_static,
		"grain_opacity": grain_opacity,
		"title_position_reaction_strength": title_position_reaction_strength,
		"title_size_reaction_strength": title_size_reaction_strength,
		"background_shader_speed_reaction_strength": background_shader_speed_reaction_strength,
		"background_image_size_reaction_strength": background_image_size_reaction_strength,
		"shake_amplitude_reaction_strength": shake_amplitude_reaction_strength,
		"shake_frequency_reaction_strength": shake_frequency_reaction_strength,
		"icon_position_reaction_strength": icon_position_reaction_strength,
		"icon_size_reaction_strength": icon_size_reaction_strength,
		"icon_rotation_reaction_strength": icon_rotation_reaction_strength,
		"chromatic_aberration_strength_reaction_strength": chromatic_aberration_strength_reaction_strength,
		"glitch_block_offset_reaction_strength": glitch_block_offset_reaction_strength,
		"glitch_pixel_offset_reaction_strength": glitch_pixel_offset_reaction_strength,
		"spin_zoom_blur_strength_reaction_strength": spin_zoom_blur_strength_reaction_strength,
		"vignette_size_reaction_strength": vignette_size_reaction_strength,
		"bloom_amount_reaction_strength": bloom_amount_reaction_strength,
		"audio_reaction_min_db_level": audio_reaction_min_db_level,
		"audio_reaction_smoothing_amount": audio_reaction_smoothing_amount,
		"waveform_colors_1": waveform_colors[0],
		"waveform_colors_2": waveform_colors[1],
		"waveform_colors_3": waveform_colors[2],
		"waveform_colors_4": waveform_colors[3],
		"waveform_thickness": waveform_thickness,
		"waveform_height": waveform_height,
		"waveform_antialiasing": waveform_antialiasing
	}
	var formatted_path: String
	formatted_path = path + save_preset_name + ".json"
	var save_json: FileAccess = FileAccess.open(formatted_path, FileAccess.WRITE)
	if save_json == null:
		MainUtils.logger("Could not save preset. Error: " + error_string(FileAccess.get_open_error()), true, true)
		return
	save_json.store_line(JSON.stringify(save_data, "\t"))
	save_json.close()
	
	MainUtils.logger("Preset succesfully saved: " + formatted_path)

func str_to_vec(vector_as_str: String) -> Variant:
	var vec_arr: Array = vector_as_str.replace("(", "").replace(")", "").split(", ")
	if vec_arr.size() == 2:
		return Vector2i(int(vec_arr[0]), int(vec_arr[1]))
	elif vec_arr.size() == 4:
		return Color(float(vec_arr[0]), float(vec_arr[1]), float(vec_arr[2]), float(vec_arr[3]))
	else:
		return

func get_var_name(element: Dictionary) -> StringName:
	return element.get("name")

func get_var_type(element: Dictionary) -> int:
	return element.get("type")

func check_and_set_property(property_name: StringName, saved_data: Variant) -> Error:
	var missing_property: bool = false
	if String(property_name) in saved_data.keys():
		# Vector2i and Color types.
		if typeof(get(property_name)) == 6 or typeof(get(property_name)) == 20:
			set(property_name, str_to_vec(saved_data[String(property_name)]))
		else:
			set(property_name, saved_data[String(property_name)])
	# Checking PackedColorArrays.
	elif String(property_name + "_1") in saved_data.keys():
		var temp_arr: PackedColorArray
		temp_arr.resize(2)
		if String(property_name + "_3") in saved_data.keys():
			temp_arr.resize(3)
		if String(property_name + "_4") in saved_data.keys():
			temp_arr.resize(4)
		for color_idx: int in temp_arr.size():
			temp_arr[color_idx] = str_to_vec(saved_data[String(property_name + "_" + str(color_idx + 1))])
		if get(property_name).size() - temp_arr.size() == 0:
			set(property_name, temp_arr)
		elif get(property_name).size() - temp_arr.size() == 1:
			MainUtils.logger("Current array for \"" + str(property_name) + "\" is bigger than the one in preset")
			var original_arr: PackedColorArray = get(property_name)
			temp_arr.append(original_arr[original_arr.size() - 1])
			set(property_name, temp_arr)
		elif get(property_name).size() - temp_arr.size() == 2:
			MainUtils.logger("Current array for \"" + str(property_name) \
+ "\" is bigger than the one in the preset")
			var original_arr: PackedColorArray = get(property_name)
			temp_arr.append(original_arr[original_arr.size() - 2])
			temp_arr.append(original_arr[original_arr.size() - 1])
			set(property_name, temp_arr)
		else:
			MainUtils.logger("Saved PackedColorArray \"" \
+ str(property_name) + "\" has a size bigger than current PackedColorArray, or smaller by more than 2 indeces. \
Setting array to default value: " + str(default_property_dict.get(property_name)))
			set(property_name, default_property_dict.get(property_name))
	else:
		MainUtils.logger("\"" + str(property_name) \
+ "\" not found. Using its default value: " + str(default_property_dict.get(property_name)))
		set(property_name, default_property_dict.get(property_name))
		missing_property = true
	if missing_property:
		return Error.FAILED
	else:
		return Error.OK

func load_preset(preset: String) -> void:
	var err: Error = check_for_dirs(presets_path, true)
	if err:
		MainUtils.logger("Could not load preset. " + presets_path + " not found.", true, true)
	var path: String
	if preset == RENDER_PRESET_FILENAME:
		path = render_info_path + preset + ".json"
	else:
		path = presets_path + preset + ".json"
	if FileAccess.file_exists(path):
		var json_text: String = FileAccess.get_file_as_string(path)
		if json_text.is_empty():
			MainUtils.logger("Preset file is empty.", true)
			return
		var save_data: Dictionary = JSON.parse_string(json_text)
		if save_data == null:
			MainUtils.logger("Could not parse preset.", true, true)
			return
		var err_arr: Array[Error]
		err_arr.resize(default_property_dict.size())
		var err_idx: int = 0
		for property: StringName in default_property_dict.keys():
			err_arr[err_idx] = check_and_set_property(property, save_data)
			err_idx += 1
		if Error.FAILED in err_arr:
			MainUtils.logger("A loaded file has " + str(err_arr.count(Error.FAILED)) \
+ " missing or incomplete properties. Using their default values. Check the log file for more info.", true)
		MainUtils.logger("Preset loaded: " + preset)
	else:
		MainUtils.logger("Preset \"" + preset + "\" does not exist in " + presets_path + ".", true)
