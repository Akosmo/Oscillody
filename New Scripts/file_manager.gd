# Oscillody
# Copyright (C) 2025-present Akosmo

# file_manager.gd is part of Oscillody.
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

signal preset_saved(p_preset_name: String)

enum AppDirectory {
	LOG,
	PRESETS,
	RENDER_INFO,
	SETTINGS,
	TEMP
}

const SN_PRESET: StringName = &"(File)_Preset"
const SN_MASTER: StringName = &"(File)_Master"

const LOG_FILENAME: String = "log.log"
const SETTINGS_FILENAME: String = "settings.json"

var _base_directory: String
var _debug_base_directory: String

var _log_directory: String
var _presets_directory: String
var _render_info_directory: String
var _settings_directory: String
var _temp_directory: String

var _selected_preset: String

func _init() -> void:
	_base_directory = OS.get_executable_path().get_base_dir()
	_debug_base_directory = OS.get_user_data_dir()
	
	if OS.has_feature("editor"):
		_log_directory = _debug_base_directory.path_join("Log (Oscillody Debug)")
		_presets_directory = _debug_base_directory.path_join("Presets (Oscillody Debug)")
		_settings_directory = _debug_base_directory.path_join("Settings (Oscillody Debug)")
	else:
		_log_directory = _base_directory.path_join("Log")
		_presets_directory = _base_directory.path_join("Presets")
		_render_info_directory = _base_directory.path_join("Render Info")
		_settings_directory = _base_directory.path_join("Settings")
		_temp_directory = _base_directory.path_join("Temp")
	
	_selected_preset = ""

func get_directory(p_directory: AppDirectory) -> String:
	match p_directory:
		AppDirectory.LOG:
			return _log_directory
		AppDirectory.PRESETS:
			return _presets_directory
		AppDirectory.RENDER_INFO:
			return _render_info_directory
		AppDirectory.SETTINGS:
			return _settings_directory
		AppDirectory.TEMP:
			return _temp_directory
		_:
			push_error("Unknown directory.")
			return ""

func get_selected_preset() -> String:
	return _selected_preset

func preset_exists(p_preset_name: String) -> bool:
	return FileAccess.file_exists(_presets_directory.path_join(p_preset_name + ".json"))

# TEST: Save empty preset.
func save_preset(p_preset_name: String, p_render_preset: bool = false) -> Error:
	CustomLogger.log_normal(
		"Saving preset: {preset} (render preset: {render})".format(
			{"preset": p_preset_name, "render": p_render_preset}
		)
	)
	
	var dir_to_use: String = _render_info_directory if p_render_preset else _presets_directory
	if check_directory(dir_to_use):
		return ERR_FILE_BAD_PATH
	
	var preset_file: FileAccess = FileAccess.open(
		dir_to_use.path_join(p_preset_name + ".json"),
		FileAccess.WRITE
	)
	if preset_file == null:
		CustomLogger.log_critical_error(
			"Could not create preset file. Error: {Error}".format(
				{"Error": error_string(FileAccess.get_open_error())}
			)
		)
		return ERR_FILE_CANT_WRITE
	
	var save_data: Dictionary[int, Dictionary]
	for element: Element in ElementManager.get_elements(false):
		if not save_data.set(element.get_element_unique_id(), element.get_properties()):
			CustomLogger.log_warning(
				"Could not save Element: {name}. Skipping.".format({"name": element.get_element_name()})
			)
	
	if not preset_file.store_line(JSON.stringify(save_data, "\t", false)):
		CustomLogger.log_critical_error(
			"Could not write preset file. Error: {Error}".format(
				{"Error": error_string(FileAccess.get_open_error())}
			)
		)
		preset_file.close()
		return ERR_FILE_CANT_WRITE
	
	preset_file.close()
	
	preset_saved.emit(p_preset_name)
	
	_selected_preset = p_preset_name
	
	return OK

# TODO: Handle compatibility (missing properties (TEST), new properties (TEST), and different UI configs).
# This should be handled in ElementManager, probably during the `load_element()` call.
func load_preset(p_preset_name: String) -> Error:
	CustomLogger.log_normal("Loading preset: " + p_preset_name)
	
	var dir_to_use: String = _render_info_directory if OS.has_feature("movie") else _presets_directory
	if check_directory(dir_to_use):
		return ERR_FILE_BAD_PATH
	
	var preset_path: String = dir_to_use.path_join(p_preset_name + ".json")
	if not FileAccess.file_exists(preset_path):
		CustomLogger.log_error("Preset \"{preset}\" does not exist.".format({"preset": p_preset_name}))
	
	var json_resource: JSON = JSON.new()
	var preset_text: String = FileAccess.get_file_as_string(preset_path)
	if preset_text.is_empty():
		CustomLogger.log_error(
			"Could not open preset file. Error: {Error}.".format(
				{"Error": error_string(FileAccess.get_open_error())}
			)
		)
		return ERR_FILE_CANT_OPEN
	if json_resource.parse(preset_text):
		CustomLogger.log_error(
			"Could not parse preset file. Error: {Error}; Line: {Line}".format(
				{"Error": json_resource.get_error_message(), "Line": json_resource.get_error_line()}
			)
		)
		return ERR_PARSE_ERROR
	
	var raw_data: Dictionary = json_resource.get_data()
	if raw_data.is_empty():
		CustomLogger.log_error("Preset JSON data is empty.")
		return FAILED
	
	ElementManager.clear_elements()
	if ElementManager.reset_unique_id():
		return FAILED
	
	var load_data: Dictionary[int, Dictionary] = _fix_preset_json_data(raw_data)
	for element: int in load_data.keys():
		var property_dict: Dictionary[StringName, Variant] = load_data.get(element)
		if property_dict == null:
			CustomLogger.log_warning("Could not load an Element's properties. Skipping.")
			continue
		ElementManager.load_element(property_dict)
	
	_selected_preset = p_preset_name
	
	return OK

func get_preset_list() -> PackedStringArray:
	var ret: PackedStringArray
	
	if check_directory(_presets_directory):
		return ret
	
	for file: String in DirAccess.get_files_at(_presets_directory):
		if file.get_extension() == "json":
			ret.append(file.get_basename())
	
	# TODO: Maybe sort this list.
	
	return ret

func save_settings() -> Error:
	CustomLogger.log_normal("Saving settings.")
	
	if check_directory(_settings_directory):
		return ERR_FILE_BAD_PATH
	
	var settings_file: FileAccess = FileAccess.open(
		_settings_directory.path_join(SETTINGS_FILENAME),
		FileAccess.WRITE
	)
	if settings_file == null:
		CustomLogger.log_warning(
			"Could not create settings file. Error: {Error}".format(
				{"Error": error_string(FileAccess.get_open_error())}
			)
		)
		return ERR_FILE_CANT_WRITE
	
	var save_data: Dictionary[StringName, Variant]
	var settings_getters: Dictionary[StringName, StringName] = SettingsManager.get_getters()
	for getter_key: StringName in settings_getters.keys():
		save_data.set(getter_key, SettingsManager.call(settings_getters.get(getter_key) as StringName))
	#save_data.set(SettingsManager.SN_INPUT_DEVICE, SettingsManager.get_input_device())
	#save_data.set(SettingsManager.SN_OUTPUT_DEVICE, SettingsManager.get_output_device())
	#save_data.set(SettingsManager.SN_EXPORT_RESOLUTION, SettingsManager.get_export_resolution())
	#save_data.set(SettingsManager.SN_FFMPEG_PATH, SettingsManager.get_ffmpeg_path())
	#save_data.set(SettingsManager.SN_APP_THEME, SettingsManager.get_app_theme())
	
	if not settings_file.store_line(JSON.stringify(save_data, "\t", false)):
		CustomLogger.log_warning(
			"Could not write settings file. Error: {Error}".format(
				{"Error": error_string(FileAccess.get_open_error())}
			)
		)
		settings_file.close()
		return ERR_FILE_CANT_WRITE
	
	settings_file.close()
	
	return OK

# TODO: Handle compatibility: missing properties, and new properties.
func load_settings() -> Error:
	CustomLogger.log_normal("Loading settings.")
	
	if check_directory(_settings_directory):
		return ERR_FILE_BAD_PATH
	
	var settings_path: String = _settings_directory.path_join(SETTINGS_FILENAME)
	if not FileAccess.file_exists(settings_path):
		CustomLogger.log_error("Settings do not exist.")
	
	var json_resource: JSON = JSON.new()
	var settings_text: String = FileAccess.get_file_as_string(settings_path)
	if settings_text.is_empty():
		CustomLogger.log_error(
			"Could not open settings file. Error: {Error}.".format(
				{"Error": error_string(FileAccess.get_open_error())}
			)
		)
		return ERR_FILE_CANT_OPEN
	if json_resource.parse(settings_text):
		CustomLogger.log_error(
			"Could not parse settings file. Error: {Error}; Line: {Line}".format(
				{"Error": json_resource.get_error_message(), "Line": json_resource.get_error_line()}
			)
		)
		return ERR_PARSE_ERROR
	
	var raw_data: Dictionary = json_resource.get_data()
	if raw_data.is_empty():
		CustomLogger.log_error("Settings JSON data is empty.")
		return FAILED
	
	var load_data: Dictionary[StringName, Variant] = _fix_json_data(raw_data)
	
	var settings_properties: Dictionary[StringName, Variant] = SettingsManager.get_properties()
	for property_key: StringName in settings_properties.keys():
		# If file has missing information.
		if not load_data.has(property_key):
			CustomLogger.log_warning(
				"{Property} is not available in the property dictionary. Keeping its default value.".format(
					{"Property": property_key}
				)
			)
	
	for property_key: StringName in load_data.keys():
		var property_value: Variant = load_data.get(property_key)
		if typeof(property_value) == TYPE_STRING and property_value.is_empty():
			CustomLogger.log_warning("{Property} has an empty value.".format({"Property": property_key}))
			continue
		
		var settings_setters: Dictionary[StringName, StringName] = SettingsManager.get_setters()
		# If settings has missing information.
		if not settings_setters.has(property_key):
			CustomLogger.log_warning(
				"{Property} does not exist in the settings class. Skipping.".format({"Property": property_key})
			)
			continue
		
		SettingsManager.call(settings_setters.get(property_key) as StringName, property_value)
		#match property_key:
			#SettingsManager.SN_INPUT_DEVICE:
				#SettingsManager.set_input_device(load_data.get(property_key))
			#SettingsManager.SN_OUTPUT_DEVICE:
				#SettingsManager.set_output_device(load_data.get(property_key))
			#SettingsManager.SN_EXPORT_RESOLUTION:
				#SettingsManager.set_export_resolution(load_data.get(property_key))
			#SettingsManager.SN_FFMPEG_PATH:
				#SettingsManager.set_ffmpeg_path(load_data.get(property_key))
			#SettingsManager.SN_APP_THEME:
				#SettingsManager.set_app_theme(load_data.get(property_key))
	
	return OK

func check_directory(p_path: String) -> Error:
	if not DirAccess.dir_exists_absolute(p_path):
		push_warning(
			"\"{Directory}\" does not exist. Attempting to make it.".format({"Directory": p_path})
		)
		if DirAccess.make_dir_absolute(p_path):
			push_error("Could not make \"{Directory}\".".format({"Directory": p_path}))
			return FAILED
	
	return OK

func _fix_preset_json_data(p_data: Dictionary) -> Dictionary[int, Dictionary]:
	var ret: Dictionary[int, Dictionary] = {}
	
	for item: String in p_data.keys():
		var raw_dict: Dictionary = p_data.get(item)
		var new_dict: Dictionary[StringName, Variant]
		var element_temp: Element
		match raw_dict.get(Element.SN_ELEMENT_TYPE) as Element.ElementType:
			Element.ElementType.EMPTY:
				element_temp = ElementEmpty.new() as ElementEmpty
			Element.ElementType.ANALYZER:
				element_temp = ElementAnalyzer.new() as ElementAnalyzer
			Element.ElementType.IMAGE:
				element_temp = ElementImage.new() as ElementImage
			Element.ElementType.SHADER:
				element_temp = ElementShader.new() as ElementShader
			Element.ElementType.TEXT:
				element_temp = ElementText.new() as ElementText
			Element.ElementType.VISUAL_EFFECT:
				element_temp = ElementVisualEffect.new() as ElementVisualEffect
		for item_inner: String in raw_dict.keys():
			match item_inner as StringName:
				Element.SN_ELEMENT_TYPE:
					new_dict.set(StringName(item_inner), raw_dict.get(item_inner) as Element.ElementType)
				ElementAnalyzer.SN_ANALYZER_TYPE:
					new_dict.set(
						StringName(item_inner),
						raw_dict.get(item_inner) as ElementAnalyzer.AnalyzerType
					)
				ElementReactive.SN_SMOOTHING_TYPE:
					new_dict.set(
						StringName(item_inner),
						raw_dict.get(item_inner) as ElementReactive.ReactiveSmoothingType
					)
				ElementShader.SN_SHADER_TYPE:
					new_dict.set(
						StringName(item_inner),
						raw_dict.get(item_inner) as ElementShader.ShaderType
					)
				ElementShader.SN_ECHOES_PULSE_MODE:
					new_dict.set(
						StringName(item_inner),
						raw_dict.get(item_inner) as ElementShader.EchoesPulseMode
					)
				ElementShader.SN_SIMPLE_GRADIENT_ORIGIN:
					new_dict.set(
						StringName(item_inner),
						raw_dict.get(item_inner) as ElementShader.SimpleGradientOrigin
					)
				ElementShader.SN_SHADER_BLEND_MODE:
					new_dict.set(
						StringName(item_inner),
						raw_dict.get(item_inner) as ElementShader.ShaderBlendMode
					)
				ElementVisualEffect.SN_VISUAL_EFFECT_TYPE:
					new_dict.set(
						StringName(item_inner),
						raw_dict.get(item_inner) as ElementVisualEffect.VisualEffectType
					)
				ElementVisualEffect.SN_BLOOM_BLEND_MODE:
					new_dict.set(
						StringName(item_inner),
						raw_dict.get(item_inner) as ElementVisualEffect.BloomBlendMode
					)
				ElementVisualEffect.SN_GRAIN_BLEND_MODE:
					new_dict.set(
						StringName(item_inner),
						raw_dict.get(item_inner) as ElementVisualEffect.GrainBlendMode
					)
				ElementVisualEffect.SN_SPIN_ZOOM_BLUR_MODE:
					new_dict.set(
						StringName(item_inner),
						raw_dict.get(item_inner) as ElementVisualEffect.SpinZoomBlurMode
					)
				ElementVisualEffect.SN_VIGNETTE_SHAPE:
					new_dict.set(
						StringName(item_inner),
						raw_dict.get(item_inner) as ElementVisualEffect.VignetteShape
					)
				ElementVisualEffect.SN_VIGNETTE_FALLOFF_FUNCTION:
					new_dict.set(
						StringName(item_inner),
						raw_dict.get(item_inner) as ElementVisualEffect.VignetteFalloffFunction
					)
				_:
					match typeof(element_temp.get_properties().get(item_inner)):
						TYPE_INT:
							new_dict.set(StringName(item_inner), raw_dict.get(item_inner) as int)
						TYPE_COLOR:
							var string_color: String = raw_dict.get(item_inner)
							var array_string_color: PackedStringArray = \
							string_color.remove_chars("()").split(", ")
							var fixed_color: Color
							fixed_color = Color(
								array_string_color[0].to_float(),
								array_string_color[1].to_float(),
								array_string_color[2].to_float(),
								array_string_color[3].to_float()
							)
							new_dict.set(StringName(item_inner), fixed_color)
						TYPE_STRING_NAME:
							new_dict.set(StringName(item_inner), raw_dict.get(item_inner) as StringName)
						_:
							new_dict.set(StringName(item_inner), raw_dict.get(item_inner))
		
		ret.set(item.to_int(), new_dict)
	
	return ret

func _fix_json_data(p_data: Dictionary) -> Dictionary[StringName, Variant]:
	var ret: Dictionary[StringName, Variant] = {}
	
	for item: String in p_data.keys():
		var item_sn: StringName = StringName(item)
		match typeof(SettingsManager.get_properties().get(item_sn)):
			TYPE_INT:
				ret.set(item_sn, p_data.get(item) as int)
			TYPE_STRING_NAME:
				ret.set(item_sn, p_data.get(item) as StringName)
			_:
				ret.set(item_sn, p_data.get(item))
	
	return ret
