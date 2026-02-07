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

extends ScrollContainer

# This script changes UI control values to whatever is loaded on global_variables, and updates their values.

#region NODES ##################################

@onready var preset_value: OptionButton = %PresetValue

@onready var waveform_a_value: SpinBox = %WaveformAValue
@onready var vertical_l_value: CheckButton = %VerticalLValue
@onready var include_d_value: CheckButton = %IncludeDValue

@onready var title_value: LineEdit = %TitleValue
@onready var title_f_value: OptionButton = %TitleFValue
@onready var title_f_b_value: CheckButton = %TitleFBValue
@onready var title_f_i_value: CheckButton = %TitleFIValue
@onready var title_p_x_value: SpinBox = %TitlePXValue
@onready var title_p_y_value: SpinBox = %TitlePYValue
@onready var title_c_value: ColorPickerButton = %TitleCValue
@onready var title_si_value: SpinBox = %TitleSiValue
@onready var title_s_c_value: ColorPickerButton = %TitleSCValue
@onready var title_s_x_value: SpinBox = %TitleSXValue
@onready var title_s_y_value: SpinBox = %TitleSYValue
@onready var title_o_c_value: ColorPickerButton = %TitleOCValue
@onready var title_o_s_value: SpinBox = %TitleOSValue

@onready var waveform_1_colors: ColorPickerButton = %Waveform1Colors
@onready var waveform_2_colors: ColorPickerButton = %Waveform2Colors
@onready var waveform_3_colors: ColorPickerButton = %Waveform3Colors
@onready var waveform_4_colors: ColorPickerButton = %Waveform4Colors
@onready var waveform_t_value: SpinBox = %WaveformTValue
@onready var waveform_h_value: SpinBox = %WaveformHValue
@onready var waveform_aa_value: CheckButton = %WaveformAAValue

@onready var divider_c_value: ColorPickerButton = %DividerCValue
@onready var divider_c_value_2: ColorPickerButton = %DividerCValue2
@onready var divider_c_value_3: ColorPickerButton = %DividerCValue3
@onready var divider_t_value: SpinBox = %DividerTValue

@onready var bg_t_value: OptionButton = %BGTValue

@onready var c_f_main_c_value: ColorPickerButton = %CFMainCValue
@onready var c_f_background_c_value: ColorPickerButton = %CFBackgroundCValue
@onready var c_f_filled_value: CheckButton = %CFFilledValue
@onready var c_f_uv_s_value: SpinBox = %CFUVSValue
@onready var c_f_iterations_value: SpinBox = %CFIterationsValue
@onready var c_f_wave_t_value: SpinBox = %CFWaveTValue
@onready var c_f_speed_value: SpinBox = %CFSpeedValue

@onready var d_w_color_value: ColorPickerButton = %DWColorValue
@onready var d_w_color_m_value: CheckButton = %DWColorMValue
@onready var d_w_invert_c_value: CheckButton = %DWInvertCValue
@onready var d_w_hue_s_value: SpinBox = %DWHueSValue
@onready var d_w_oct_value: SpinBox = %DWOctValue
@onready var d_w_freq_f_value: SpinBox = %DWFreqFValue
@onready var d_w_amp_value: SpinBox = %DWAmpValue
@onready var d_w_freq_i_value: SpinBox = %DWFreqIValue
@onready var d_w_amp_d_value: SpinBox = %DWAmpDValue
@onready var d_w_speed_value: SpinBox = %DWSpeedValue

@onready var e_main_c_value: ColorPickerButton = %EMainCValue
@onready var e_background_c_value: ColorPickerButton = %EBackgroundCValue
@onready var e_fractal_uv_value: CheckButton = %EFractalUVValue
@onready var e_change_o_value: CheckButton = %EChangeOValue
@onready var e_iterations_value: SpinBox = %EIterationsValue
@onready var e_uv_s_value: SpinBox = %EUVSValue
@onready var e_vector_s_1_value: SpinBox = %EVectorS1Value
@onready var e_iterator_f_1_value: SpinBox = %EIteratorF1Value
@onready var e_uv_l_f_value: SpinBox = %EUVLFValue
@onready var e_vector_s_2_value: SpinBox = %EVectorS2Value
@onready var e_iterator_f_2_value: SpinBox = %EIteratorF2Value
@onready var e_time_s_value: SpinBox = %ETimeSValue
@onready var e_iterator_f_3_value: SpinBox = %EIteratorF3Value
@onready var e_distance_s_value: SpinBox = %EDistanceSValue
@onready var e_pulse_f_value: SpinBox = %EPulseFValue
@onready var e_line_t_value: SpinBox = %ELineTValue
@onready var e_iterator_f_4_value: SpinBox = %EIteratorF4Value
@onready var e_assignment_m_1_value: SpinBox = %EAssignmentM1Value
@onready var e_thickness_v_value: SpinBox = %EThicknessVValue
@onready var e_assignment_m_2_value: SpinBox = %EAssignmentM2Value
@onready var e_thin_l_value: CheckButton = %EThinLValue
@onready var e_assignment_m_3_value: CheckButton = %EAssignmentM3Value
@onready var e_assignment_m_4_value: CheckButton = %EAssignmentM4Value
@onready var e_fractal_d_value: CheckButton = %EFractalDValue
@onready var e_speed_value: SpinBox = %ESpeedValue

@onready var bg_img_path_button: Button = %BGImgPathButton
@onready var bg_img_p_file_dialog: FileDialog = %BGImgPFileDialog
@onready var bg_img_s_value: SpinBox = %BGImgSValue
@onready var bg_img_o_value: SpinBox = %BGImgOValue
@onready var bg_img_b_value: SpinBox = %BGImgBValue

@onready var i_line_c_value: ColorPickerButton = %ILineCValue
@onready var i_background_c_value: ColorPickerButton = %IBackgroundCValue
@onready var i_filled_value: CheckButton = %IFilledValue
@onready var i_line_t_value: SpinBox = %ILineTValue
@onready var i_thickness_v_value: SpinBox = %IThicknessVValue
@onready var i_line_a_value: SpinBox = %ILineAValue
@onready var i_uv_s_value: SpinBox = %IUVSValue
@onready var i_speed_value: SpinBox = %ISpeedValue

@onready var s_g_color_1_value: ColorPickerButton = %SGColor1Value
@onready var s_g_color_2_value: ColorPickerButton = %SGColor2Value
@onready var s_g_direction_value: SpinBox = %SGDirectionValue

@onready var bg_1_colors: ColorPickerButton = %BG1Colors
@onready var bg_2_colors: ColorPickerButton = %BG2Colors
@onready var bg_3_colors: ColorPickerButton = %BG3Colors
@onready var bg_4_colors: ColorPickerButton = %BG4Colors

@onready var t_color_value: ColorPickerButton = %TColorValue
@onready var t_tint_value: ColorPickerButton = %TTintValue
@onready var t_color_m_value: CheckButton = %TColorMValue
@onready var t_invert_c_value: CheckButton = %TInvertCValue
@onready var t_hue_s_value: SpinBox = %THueSValue
@onready var t_iterations_value: SpinBox = %TIterationsValue
@onready var t_speed_value: SpinBox = %TSpeedValue

@onready var shader_brightness_value: SpinBox = %ShaderBrightnessValue
@onready var shader_blur_value: SpinBox = %ShaderBlurValue

@onready var bg_shake_a_value: SpinBox = %BGShakeAValue
@onready var bg_shake_f_value: SpinBox = %BGShakeFValue

@onready var icon_e_value: CheckButton = %IconEValue
@onready var icon_path_button: Button = %IconPathButton
@onready var icon_p_file_dialog: FileDialog = %IconPFileDialog
@onready var icon_c_value: ColorPickerButton = %IconCValue
@onready var icon_r_value: SpinBox = %IconRValue
@onready var icon_s_value: SpinBox = %IconSValue

@onready var post_p_t_value: OptionButton = %PostPTValue

@onready var chromatic_a_s_value: SpinBox = %ChromaticASValue

@onready var glitch_b_o_a_value: SpinBox = %GlitchBOAValue
@onready var glitch_p_o_a_value: SpinBox = %GlitchPOAValue
@onready var glitch_s_f_value: SpinBox = %GlitchSFValue

@onready var spin_zoom_blur_c_m_value: CheckButton = %SpinZoomBlurCMValue
@onready var spin_zoom_blur_s_value: SpinBox = %SpinZoomBlurSValue

@onready var tape_d_w_s_value: SpinBox = %TapeDWSValue
@onready var tape_d_w_sp_value: SpinBox = %TapeDWSpValue
@onready var tape_d_w_f_value: SpinBox = %TapeDWFValue
@onready var tape_d_w_t_value: SpinBox = %TapeDWTValue
@onready var tape_d_b_s_value: SpinBox = %TapeDBSValue
@onready var tape_d_b_sp_value: SpinBox = %TapeDBSpValue
@onready var tape_d_b_f_value: SpinBox = %TapeDBFValue

@onready var scanlines_d_value: SpinBox = %ScanlinesDValue
@onready var scanlines_a_l_value: SpinBox = %ScanlinesALValue
@onready var scanlines_i_s_value: CheckButton = %ScanlinesISValue
@onready var scanlines_s_value: SpinBox = %ScanlinesSValue

@onready var lens_d_s_value: SpinBox = %LensDSValue
@onready var lens_d_z_value: SpinBox = %LensDZValue
@onready var lens_d_b_value: CheckButton = %LensDBValue
@onready var lens_d_b_c_value: ColorPickerButton = %LensDBCValue
@onready var lens_d_c_a_s_value: SpinBox = %LensDCASValue

@onready var gradient_o_c_1_value: ColorPickerButton = %GradientOC1Value
@onready var gradient_o_c_2_value: ColorPickerButton = %GradientOC2Value
@onready var gradient_o_d_value: SpinBox = %GradientODValue
@onready var gradient_o_o_value: SpinBox = %GradientOOValue

@onready var vignette_c_value: ColorPickerButton = %VignetteCValue
@onready var vignette_s_value: SpinBox = %VignetteSValue
@onready var vignette_sh_value: SpinBox = %VignetteShValue

@onready var bloom_a_value: SpinBox = %BloomAValue
@onready var bloom_b_m_value: OptionButton = %BloomBMValue

@onready var grain_s_value: CheckButton = %GrainSValue
@onready var grain_o_value: SpinBox = %GrainOValue

@onready var audio_r_c_value: OptionButton = %AudioRCValue
@onready var title_pos_reaction_s_value: SpinBox = %TitlePosReactionSValue
@onready var title_s_reaction_s_value: SpinBox = %TitleSReactionSValue
@onready var bg_s_s_reaction_s_value: SpinBox = %BGSSReactionSValue
@onready var bg_i_s_reaction_s_value: SpinBox = %BGISReactionSValue
@onready var shake_a_reaction_s_value: SpinBox = %ShakeAReactionSValue
@onready var shake_f_reaction_s_value: SpinBox = %ShakeFReactionSValue
@onready var icon_p_reaction_s_value: SpinBox = %IconPReactionSValue
@onready var icon_s_reaction_s_value: SpinBox = %IconSReactionSValue
@onready var icon_r_reaction_s_value: SpinBox = %IconRReactionSValue
@onready var c_a_s_reaction_s_value: SpinBox = %CASReactionSValue
@onready var glitch_b_o_reaction_s_value: SpinBox = %GlitchBOReactionSValue
@onready var glitch_p_o_reaction_s_value: SpinBox = %GlitchPOReactionSValue
@onready var s_z_b_s_reaction_s_value: SpinBox = %SZBSReactionSValue
@onready var vignette_s_reaction_s_value: SpinBox = %VignetteSReactionSValue
@onready var bloom_a_reaction_s_value: SpinBox = %BloomAReactionSValue

@onready var audio_r_m_db_value: SpinBox = %AudioRMdBValue
@onready var audio_r_smoothing_a_value: SpinBox = %AudioRSmoothingAValue

@onready var include_dividers: HBoxContainer = %IncludeDividers

@onready var title_font: HBoxContainer = %TitleFont
@onready var title_font_bold: HBoxContainer = %TitleFontBold
@onready var title_font_italic: HBoxContainer = %TitleFontItalic
@onready var title_position: HBoxContainer = %TitlePosition
@onready var title_color: HBoxContainer = %TitleColor
@onready var title_size: HBoxContainer = %TitleSize
@onready var title_shadow: VBoxContainer = %TitleShadow
@onready var title_outline: HBoxContainer = %TitleOutline

@onready var divider_colors: VBoxContainer = %DividerColors
@onready var divider_thickness: HBoxContainer = %DividerThickness

@onready var background_separator: HSeparator = %BackgroundSeparator

@onready var current_flow_main_color: HBoxContainer = %CurrentFlowMainColor
@onready var current_flow_background_color: HBoxContainer = %CurrentFlowBackgroundColor
@onready var current_flow_filled: HBoxContainer = %CurrentFlowFilled
@onready var current_flow_uv_scale: HBoxContainer = %CurrentFlowUVScale
@onready var current_flow_iterations: HBoxContainer = %CurrentFlowIterations
@onready var current_flow_wave_thickness: HBoxContainer = %CurrentFlowWaveThickness
@onready var current_flow_speed: HBoxContainer = %CurrentFlowSpeed

@onready var domain_warping_color: HBoxContainer = %DomainWarpingColor
@onready var domain_warping_color_mix: HBoxContainer = %DomainWarpingColorMix
@onready var domain_warping_invert_colors: HBoxContainer = %DomainWarpingInvertColors
@onready var domain_warping_hue_shift: HBoxContainer = %DomainWarpingHueShift
@onready var domain_warping_octaves: HBoxContainer = %DomainWarpingOctaves
@onready var domain_warping_freq_factor: HBoxContainer = %DomainWarpingFreqFactor
@onready var domain_warping_amp: HBoxContainer = %DomainWarpingAmp
@onready var domain_warping_freq_increment: HBoxContainer = %DomainWarpingFreqIncrement
@onready var domain_warping_amp_decrement: HBoxContainer = %DomainWarpingAmpDecrement
@onready var domain_warping_speed: HBoxContainer = %DomainWarpingSpeed

@onready var echoes_main_color: HBoxContainer = %EchoesMainColor
@onready var echoes_background_color: HBoxContainer = %EchoesBackgroundColor
@onready var echoes_fractal_uv: HBoxContainer = %EchoesFractalUV
@onready var echoes_change_origin: HBoxContainer = %EchoesChangeOrigin
@onready var echoes_iterations: HBoxContainer = %EchoesIterations
@onready var echoes_uv_scale: HBoxContainer = %EchoesUVScale
@onready var echoes_vector_scale_1: HBoxContainer = %EchoesVectorScale1
@onready var echoes_iterator_factor_1: HBoxContainer = %EchoesIteratorFactor1
@onready var echoes_uv_length_factor: HBoxContainer = %EchoesUVLengthFactor
@onready var echoes_vector_scale_2: HBoxContainer = %EchoesVectorScale2
@onready var echoes_iterator_factor_2: HBoxContainer = %EchoesIteratorFactor2
@onready var echoes_time_scale: HBoxContainer = %EchoesTimeScale
@onready var echoes_iterator_factor_3: HBoxContainer = %EchoesIteratorFactor3
@onready var echoes_distance_scale: HBoxContainer = %EchoesDistanceScale
@onready var echoes_pulse_frequency: HBoxContainer = %EchoesPulseFrequency
@onready var echoes_line_thickness: HBoxContainer = %EchoesLineThickness
@onready var echoes_iterator_factor_4: HBoxContainer = %EchoesIteratorFactor4
@onready var echoes_assignment_mode_1: HBoxContainer = %EchoesAssignmentMode1
@onready var echoes_thickness_variation: HBoxContainer = %EchoesThicknessVariation
@onready var echoes_assignment_mode_2: HBoxContainer = %EchoesAssignmentMode2
@onready var echoes_thin_lines: HBoxContainer = %EchoesThinLines
@onready var echoes_assignment_mode_3: HBoxContainer = %EchoesAssignmentMode3
@onready var echoes_assignment_mode_4: HBoxContainer = %EchoesAssignmentMode4
@onready var echoes_fractal_distance: HBoxContainer = %EchoesFractalDistance
@onready var echoes_speed: HBoxContainer = %EchoesSpeed

@onready var background_image_size: HBoxContainer = %BackgroundImageSize
@onready var background_image_opacity: HBoxContainer = %BackgroundImageOpacity
@onready var background_image_blur: HBoxContainer = %BackgroundImageBlur

@onready var isolines_line_color: HBoxContainer = %IsolinesLineColor
@onready var isolines_background_color: HBoxContainer = %IsolinesBackgroundColor
@onready var isolines_filled: HBoxContainer = %IsolinesFilled
@onready var isolines_line_thickness: HBoxContainer = %IsolinesLineThickness
@onready var isolines_thickness_variation: HBoxContainer = %IsolinesThicknessVariation
@onready var isolines_line_amount: HBoxContainer = %IsolinesLineAmount
@onready var isolines_uv_scale: HBoxContainer = %IsolinesUVScale
@onready var isolines_speed: HBoxContainer = %IsolinesSpeed

@onready var simple_gradient_color_1: HBoxContainer = %SimpleGradientColor1
@onready var simple_gradient_color_2: HBoxContainer = %SimpleGradientColor2
@onready var simple_gradient_direction: HBoxContainer = %SimpleGradientDirection

@onready var background_colors: VBoxContainer = %BackgroundColors

@onready var tides_color: HBoxContainer = %TidesColor
@onready var tides_tint: HBoxContainer = %TidesTint
@onready var tides_color_mix: HBoxContainer = %TidesColorMix
@onready var tides_invert_colors: HBoxContainer = %TidesInvertColors
@onready var tides_hue_shift: HBoxContainer = %TidesHueShift
@onready var tides_iterations: HBoxContainer = %TidesIterations
@onready var tides_speed: HBoxContainer = %TidesSpeed

@onready var shader_brightness: HBoxContainer = %ShaderBrightness
@onready var shader_blur: HBoxContainer = %ShaderBlur

@onready var background_shake_amplitude: HBoxContainer = %BackgroundShakeAmplitude
@onready var background_shake_frequency: HBoxContainer = %BackgroundShakeFrequency

@onready var icon_color: HBoxContainer = %IconColor
@onready var icon_rotation: HBoxContainer = %IconRotation
@onready var icon_size: HBoxContainer = %IconSize

@onready var chromatic_aberration_strength: HBoxContainer = %ChromaticAberrationStrength

@onready var glitch_block_offset_amount: HBoxContainer = %GlitchBlockOffsetAmount
@onready var glitch_pixel_offset_amount: HBoxContainer = %GlitchPixelOffsetAmount
@onready var glitch_speed_factor: HBoxContainer = %GlitchSpeedFactor

@onready var spin_zoom_blur_change_mode: HBoxContainer = %SpinZoomBlurChangeMode
@onready var spin_zoom_blur_strength: HBoxContainer = %SpinZoomBlurStrength

@onready var tape_dist_wave_strength: HBoxContainer = %TapeDistWaveStrength
@onready var tape_dist_wave_speed: HBoxContainer = %TapeDistWaveSpeed
@onready var tape_dist_wave_frequency: HBoxContainer = %TapeDistWaveFrequency
@onready var tape_dist_wave_thickness: HBoxContainer = %TapeDistWaveThickness
@onready var tape_dist_block_strength: HBoxContainer = %TapeDistBlockStrength
@onready var tape_dist_block_speed: HBoxContainer = %TapeDistBlockSpeed
@onready var tape_dist_block_frequency: HBoxContainer = %TapeDistBlockFrequency

@onready var scanlines_darkness: HBoxContainer = %ScanlinesDarkness
@onready var scanlines_amount_lines: HBoxContainer = %ScanlinesAmountLines
@onready var scanlines_interlaced_scan: HBoxContainer = %ScanlinesInterlacedScan
@onready var scanlines_speed: HBoxContainer = %ScanlinesSpeed

@onready var lens_dist_strength: HBoxContainer = %LensDistStrength
@onready var lens_dist_zoom: HBoxContainer = %LensDistZoom
@onready var lens_dist_border: HBoxContainer = %LensDistBorder
@onready var lens_dist_border_color: HBoxContainer = %LensDistBorderColor
@onready var lens_dist_chromatic_abr_strength: HBoxContainer = %LensDistChromaticAbrStrength

@onready var gradient_overlay_color_1: HBoxContainer = %GradientOverlayColor1
@onready var gradient_overlay_color_2: HBoxContainer = %GradientOverlayColor2
@onready var gradient_overlay_direction: HBoxContainer = %GradientOverlayDirection
@onready var gradient_overlay_opacity: HBoxContainer = %GradientOverlayOpacity

@onready var vignette_color: HBoxContainer = %VignetteColor
@onready var vignette_size: HBoxContainer = %VignetteSize
@onready var vignette_sharpness: HBoxContainer = %VignetteSharpness

@onready var bloom_amount: HBoxContainer = %BloomAmount
@onready var bloom_blend_mode: HBoxContainer = %BloomBlendMode

@onready var grain_static: HBoxContainer = %GrainStatic
@onready var grain_opacity: HBoxContainer = %GrainOpacity

@onready var title_pos_reaction_str: HBoxContainer = %TitlePosReactionStr
@onready var title_size_reaction_str: HBoxContainer = %TitleSizeReactionStr
@onready var bg_shader_speed_reaction_str: HBoxContainer = %BGShaderSpeedReactionStr
@onready var bg_image_size_reaction_str: HBoxContainer = %BGImageSizeReactionStr
@onready var shake_amp_reaction_str: HBoxContainer = %ShakeAmpReactionStr
@onready var shake_freq_reaction_str: HBoxContainer = %ShakeFreqReactionStr
@onready var icon_position_reaction_str: HBoxContainer = %IconPositionReactionStr
@onready var icon_size_reaction_str: HBoxContainer = %IconSizeReactionStr
@onready var icon_rotation_reaction_str: HBoxContainer = %IconRotationReactionStr
@onready var chro_aber_str_reaction_str: HBoxContainer = %ChroAberStrReactionStr
@onready var glitch_block_offset_reaction_str: HBoxContainer = %GlitchBlockOffsetReactionStr
@onready var glitch_pixel_offset_reaction_str: HBoxContainer = %GlitchPixelOffsetReactionStr
@onready var spin_zoom_blur_str_reaction_str: HBoxContainer = %SpinZoomBlurStrReactionStr
@onready var vignette_size_reaction_str: HBoxContainer = %VignetteSizeReactionStr
@onready var bloom_amt_reaction_str: HBoxContainer = %BloomAmtReactionStr

@onready var save_preset_container: CenterContainer = %SavePresetContainer

@onready var ui_anim_player: AnimationPlayer = %UIAnimPlayer

#endregion ##################################

func _ready() -> void:
	MainUtils.update_visualizer.connect(update_customize)
	MainUtils.new_preset_saved.connect(refresh_preset_list)
	
	var font_idx: int = 0
	for font: String in GlobalVariables.title_fonts_in_selector:
		title_f_value.add_item(font, font_idx)
		font_idx += 1
	title_f_value.select(GlobalVariables.title_fonts_in_selector.find(GlobalVariables.title_font))
	if GlobalVariables.title_font not in GlobalVariables.title_fonts_in_selector:
		MainUtils.logger("Could not find font \"" + GlobalVariables.title_font + "\" in preset.", true)
		GlobalVariables.title_font = "Calibri"
	title_f_value.select(GlobalVariables.title_fonts_in_selector.find(GlobalVariables.title_font))
	
	if bg_t_value.item_count == 0:
		for item: int in GlobalVariables.BACKGROUND_TYPES_IN_SELECTOR.size():
			bg_t_value.add_item(GlobalVariables.BACKGROUND_TYPES_IN_SELECTOR[item], item)
	bg_t_value.select(GlobalVariables.BACKGROUND_TYPES_IN_SELECTOR.find(GlobalVariables.background_type))
	bg_img_p_file_dialog.set_filters(PackedStringArray(["*.png, *.jpg, *.jpeg ; Supported Formats"]))
	
	icon_p_file_dialog.set_filters(PackedStringArray(["*.png, *.jpg, *.jpeg ; Supported Formats"]))
	
	if post_p_t_value.item_count == 0:
		for item: int in GlobalVariables.POST_PROCESSING_TYPES_IN_SELECTOR.size():
			post_p_t_value.add_item(GlobalVariables.POST_PROCESSING_TYPES_IN_SELECTOR[item], item)
	post_p_t_value.select(
		GlobalVariables.POST_PROCESSING_TYPES_IN_SELECTOR.find(GlobalVariables.post_processing_type)
		)
	
	if audio_r_c_value.item_count == 0:
		for item: int in GlobalVariables.AUDIO_REACTION_CONTROLS_IN_SELECTOR.size():
			audio_r_c_value.add_item(GlobalVariables.AUDIO_REACTION_CONTROLS_IN_SELECTOR[item], item)
	audio_r_c_value.select(
		GlobalVariables.AUDIO_REACTION_CONTROLS_IN_SELECTOR.find(GlobalVariables.audio_reaction_control)
		)
	
	var preset_iterable: int = 0
	for preset: String in GlobalVariables.presets_in_selector:
		preset_value.add_item(GlobalVariables.presets_in_selector[preset_iterable], preset_iterable)
		preset_iterable += 1
	if GlobalVariables.presets_in_selector.find(GlobalVariables.preset_name) >= 0:
		preset_value.select(GlobalVariables.presets_in_selector.find(GlobalVariables.preset_name))
		preset_value.item_selected.emit(GlobalVariables.presets_in_selector.find(GlobalVariables.preset_name))
	else:
		MainUtils.logger("Can't find Default preset, creating new one...", true)
		GlobalVariables.presets_in_selector.append(GlobalVariables.preset_name)
		GlobalVariables.save_preset(GlobalVariables.preset_name)
		MainUtils.new_preset_saved.emit()
		preset_value.item_selected.emit(GlobalVariables.presets_in_selector.find(GlobalVariables.preset_name))
	
	update_customize()

func update_customize() -> void:
	if GlobalVariables.vertical_layout:
		include_dividers.visible = true
	else:
		include_dividers.visible = false
	
	if GlobalVariables.title:
		title_font.visible = true
		title_font_bold.visible = true
		title_font_italic.visible = true
		title_position.visible = true
		title_color.visible = true
		title_size.visible = true
		title_shadow.visible = true
		title_outline.visible = true
	else:
		title_font.visible = false
		title_font_bold.visible = false
		title_font_italic.visible = false
		title_position.visible = false
		title_color.visible = false
		title_size.visible = false
		title_shadow.visible = false
		title_outline.visible = false
	
	if (GlobalVariables.number_of_stems > 1 and
	(not GlobalVariables.vertical_layout or GlobalVariables.include_dividers)):
		background_separator.visible = true
		divider_colors.visible = true
		divider_thickness.visible = true
	else:
		background_separator.visible = false
		divider_colors.visible = false
		divider_thickness.visible = false
	if (GlobalVariables.number_of_stems == 3 or
	(GlobalVariables.number_of_stems == 4 and not GlobalVariables.vertical_layout)):
		divider_c_value_2.visible = true
		divider_c_value_3.visible = false
	elif GlobalVariables.number_of_stems == 4 and GlobalVariables.vertical_layout:
		divider_c_value_2.visible = true
		divider_c_value_3.visible = true
	else:
		divider_c_value_2.visible = false
		divider_c_value_3.visible = false
	
	if GlobalVariables.background_type == "Current Flow":
		current_flow_main_color.visible = true
		current_flow_background_color.visible = true
		current_flow_filled.visible = true
		current_flow_uv_scale.visible = true
		current_flow_iterations.visible = true
		current_flow_wave_thickness.visible = true
		current_flow_speed.visible = true
		shader_brightness.visible = false
		shader_blur.visible = true
		background_shake_amplitude.visible = true
		background_shake_frequency.visible = true
	else:
		current_flow_main_color.visible = false
		current_flow_background_color.visible = false
		current_flow_filled.visible = false
		current_flow_uv_scale.visible = false
		current_flow_iterations.visible = false
		current_flow_wave_thickness.visible = false
		current_flow_speed.visible = false
	if GlobalVariables.background_type == "Domain Warping":
		domain_warping_color.visible = true
		domain_warping_color_mix.visible = true
		domain_warping_invert_colors.visible = true
		domain_warping_hue_shift.visible = true
		domain_warping_octaves.visible = true
		domain_warping_freq_factor.visible = true
		domain_warping_amp.visible = true
		domain_warping_freq_increment.visible = true
		domain_warping_amp_decrement.visible = true
		domain_warping_speed.visible = true
		shader_brightness.visible = true
		shader_blur.visible = true
		background_shake_amplitude.visible = true
		background_shake_frequency.visible = true
	else:
		domain_warping_color.visible = false
		domain_warping_color_mix.visible = false
		domain_warping_invert_colors.visible = false
		domain_warping_hue_shift.visible = false
		domain_warping_octaves.visible = false
		domain_warping_freq_factor.visible = false
		domain_warping_amp.visible = false
		domain_warping_freq_increment.visible = false
		domain_warping_amp_decrement.visible = false
		domain_warping_speed.visible = false
	if GlobalVariables.background_type == "Echoes":
		echoes_main_color.visible = true
		echoes_background_color.visible = true
		echoes_fractal_uv.visible = true
		echoes_change_origin.visible = true
		echoes_iterations.visible = true
		echoes_uv_scale.visible = true
		echoes_vector_scale_1.visible = true
		echoes_iterator_factor_1.visible = true
		echoes_uv_length_factor.visible = true
		echoes_vector_scale_2.visible = true
		echoes_iterator_factor_2.visible = true
		echoes_time_scale.visible = true
		echoes_iterator_factor_3.visible = true
		echoes_distance_scale.visible = true
		echoes_pulse_frequency.visible = true
		echoes_line_thickness.visible = true
		echoes_iterator_factor_4.visible = true
		echoes_assignment_mode_1.visible = true
		echoes_thickness_variation.visible = true
		echoes_assignment_mode_2.visible = true
		echoes_thin_lines.visible = true
		echoes_assignment_mode_3.visible = true
		echoes_assignment_mode_4.visible = true
		echoes_fractal_distance.visible = true
		echoes_speed.visible = true
		shader_brightness.visible = false
		shader_blur.visible = true
		background_shake_amplitude.visible = true
		background_shake_frequency.visible = true
	else:
		echoes_main_color.visible = false
		echoes_background_color.visible = false
		echoes_fractal_uv.visible = false
		echoes_change_origin.visible = false
		echoes_iterations.visible = false
		echoes_uv_scale.visible = false
		echoes_vector_scale_1.visible = false
		echoes_iterator_factor_1.visible = false
		echoes_uv_length_factor.visible = false
		echoes_vector_scale_2.visible = false
		echoes_iterator_factor_2.visible = false
		echoes_time_scale.visible = false
		echoes_iterator_factor_3.visible = false
		echoes_distance_scale.visible = false
		echoes_pulse_frequency.visible = false
		echoes_line_thickness.visible = false
		echoes_iterator_factor_4.visible = false
		echoes_assignment_mode_1.visible = false
		echoes_thickness_variation.visible = false
		echoes_assignment_mode_2.visible = false
		echoes_thin_lines.visible = false
		echoes_assignment_mode_3.visible = false
		echoes_assignment_mode_4.visible = false
		echoes_fractal_distance.visible = false
		echoes_speed.visible = false
	if GlobalVariables.background_type == "Image":
		bg_img_path_button.visible = true
		background_image_size.visible = true
		background_image_opacity.visible = true
		background_image_blur.visible = true
		shader_brightness.visible = false
		shader_blur.visible = false
		background_shake_amplitude.visible = true
		background_shake_frequency.visible = true
	else:
		bg_img_path_button.visible = false
		background_image_size.visible = false
		background_image_opacity.visible = false
		background_image_blur.visible = false
	if GlobalVariables.background_type == "Isolines":
		isolines_line_color.visible = true
		isolines_background_color.visible = true
		isolines_filled.visible = true
		isolines_line_thickness.visible = true
		isolines_thickness_variation.visible = true
		isolines_line_amount.visible = true
		isolines_uv_scale.visible = true
		isolines_speed.visible = true
		shader_brightness.visible = false
		shader_blur.visible = true
		background_shake_amplitude.visible = true
		background_shake_frequency.visible = true
	else:
		isolines_line_color.visible = false
		isolines_background_color.visible = false
		isolines_filled.visible = false
		isolines_line_thickness.visible = false
		isolines_thickness_variation.visible = false
		isolines_line_amount.visible = false
		isolines_uv_scale.visible = false
		isolines_speed.visible = false
	if GlobalVariables.background_type == "Simple Gradient":
		simple_gradient_color_1.visible = true
		simple_gradient_color_2.visible = true
		simple_gradient_direction.visible = true
		shader_brightness.visible = false
		shader_blur.visible = false
		background_shake_amplitude.visible = false
		background_shake_frequency.visible = false
	else:
		simple_gradient_color_1.visible = false
		simple_gradient_color_2.visible = false
		simple_gradient_direction.visible = false
	if GlobalVariables.background_type == "Solid Colors":
		background_colors.visible = true
		shader_brightness.visible = false
		shader_blur.visible = false
		background_shake_amplitude.visible = false
		background_shake_frequency.visible = false
	else:
		background_colors.visible = false
	if GlobalVariables.background_type == "Tides":
		tides_color.visible = true
		tides_tint.visible = true
		tides_color_mix.visible = true
		tides_invert_colors.visible = true
		tides_hue_shift.visible = true
		tides_iterations.visible = true
		tides_speed.visible = true
		shader_brightness.visible = true
		shader_blur.visible = true
		background_shake_amplitude.visible = true
		background_shake_frequency.visible = true
	else:
		tides_color.visible = false
		tides_tint.visible = false
		tides_color_mix.visible = false
		tides_invert_colors.visible = false
		tides_hue_shift.visible = false
		tides_iterations.visible = false
		tides_speed.visible = false
	
	if GlobalVariables.icon_enabled:
		icon_path_button.visible = true
		icon_color.visible = true
		icon_rotation.visible = true
		icon_size.visible = true
	else:
		icon_path_button.visible = false
		icon_color.visible = false
		icon_rotation.visible = false
		icon_size.visible = false
	
	if GlobalVariables.post_processing_type == "Chromatic Aberration":
		chromatic_aberration_strength.visible = true
	else:
		chromatic_aberration_strength.visible = false
	if GlobalVariables.post_processing_type == "Glitch":
		glitch_block_offset_amount.visible = true
		glitch_pixel_offset_amount.visible = true
		glitch_speed_factor.visible = true
	else:
		glitch_block_offset_amount.visible = false
		glitch_pixel_offset_amount.visible = false
		glitch_speed_factor.visible = false
	if GlobalVariables.post_processing_type == "Spin/Zoom Blur":
		spin_zoom_blur_change_mode.visible = true
		spin_zoom_blur_strength.visible = true
	else:
		spin_zoom_blur_change_mode.visible = false
		spin_zoom_blur_strength.visible = false
	if GlobalVariables.post_processing_type == "Tape Distortion":
		tape_dist_wave_strength.visible = true
		tape_dist_wave_speed.visible = true
		tape_dist_wave_frequency.visible = true
		tape_dist_wave_thickness.visible = true
		tape_dist_block_strength.visible = true
		tape_dist_block_speed.visible = true
		tape_dist_block_frequency.visible = true
	else:
		tape_dist_wave_strength.visible = false
		tape_dist_wave_speed.visible = false
		tape_dist_wave_frequency.visible = false
		tape_dist_wave_thickness.visible = false
		tape_dist_block_strength.visible = false
		tape_dist_block_speed.visible = false
		tape_dist_block_frequency.visible = false
	if GlobalVariables.post_processing_type == "Scanlines":
		scanlines_darkness.visible = true
		scanlines_amount_lines.visible = true
		scanlines_interlaced_scan.visible = true
		scanlines_speed.visible = true
	else:
		scanlines_darkness.visible = false
		scanlines_amount_lines.visible = false
		scanlines_interlaced_scan.visible = false
		scanlines_speed.visible = false
	if GlobalVariables.post_processing_type == "Lens Distortion":
		lens_dist_strength.visible = true
		lens_dist_zoom.visible = true
		lens_dist_border.visible = true
		lens_dist_border_color.visible = true
		lens_dist_chromatic_abr_strength.visible = true
	else:
		lens_dist_strength.visible = false
		lens_dist_zoom.visible = false
		lens_dist_border.visible = false
		lens_dist_border_color.visible = false
		lens_dist_chromatic_abr_strength.visible = false
	if GlobalVariables.post_processing_type == "Gradient Overlay":
		gradient_overlay_color_1.visible = true
		gradient_overlay_color_2.visible = true
		gradient_overlay_direction.visible = true
		gradient_overlay_opacity.visible = true
	else:
		gradient_overlay_color_1.visible = false
		gradient_overlay_color_2.visible = false
		gradient_overlay_direction.visible = false
		gradient_overlay_opacity.visible = false
	if GlobalVariables.post_processing_type == "Vignette":
		vignette_color.visible = true
		vignette_size.visible = true
		vignette_sharpness.visible = true
	else:
		vignette_color.visible = false
		vignette_size.visible = false
		vignette_sharpness.visible = false
	if GlobalVariables.post_processing_type == "Bloom":
		bloom_amount.visible = true
		bloom_blend_mode.visible = true
	else:
		bloom_amount.visible = false
		bloom_blend_mode.visible = false
	if GlobalVariables.post_processing_type == "Grain":
		grain_static.visible = true
		grain_opacity.visible = true
	else:
		grain_static.visible = false
		grain_opacity.visible = false
	
	if GlobalVariables.audio_reaction_control == "Title":
		title_pos_reaction_str.visible = true
		title_size_reaction_str.visible = true
	else:
		title_pos_reaction_str.visible = false
		title_size_reaction_str.visible = false
	if GlobalVariables.audio_reaction_control == "Background":
		bg_shader_speed_reaction_str.visible = true
		bg_image_size_reaction_str.visible = true
		shake_amp_reaction_str.visible = true
		shake_freq_reaction_str.visible = true
	else:
		bg_shader_speed_reaction_str.visible = false
		bg_image_size_reaction_str.visible = false
		shake_amp_reaction_str.visible = false
		shake_freq_reaction_str.visible = false
	if GlobalVariables.audio_reaction_control == "Icon":
		icon_position_reaction_str.visible = true
		icon_size_reaction_str.visible = true
		icon_rotation_reaction_str.visible = true
	else:
		icon_position_reaction_str.visible = false
		icon_size_reaction_str.visible = false
		icon_rotation_reaction_str.visible = false
	if GlobalVariables.audio_reaction_control == "Post-Processing":
		chro_aber_str_reaction_str.visible = true
		glitch_block_offset_reaction_str.visible = true
		glitch_pixel_offset_reaction_str.visible = true
		spin_zoom_blur_str_reaction_str.visible = true
		vignette_size_reaction_str.visible = true
		bloom_amt_reaction_str.visible = true
	else:
		chro_aber_str_reaction_str.visible = false
		glitch_block_offset_reaction_str.visible = false
		glitch_pixel_offset_reaction_str.visible = false
		spin_zoom_blur_str_reaction_str.visible = false
		vignette_size_reaction_str.visible = false
		bloom_amt_reaction_str.visible = false

func set_ui_values() -> void:
	var start_time: int = Time.get_ticks_msec()
	
	waveform_a_value.value = float(GlobalVariables.number_of_stems)
	vertical_l_value.button_pressed = GlobalVariables.vertical_layout
	include_d_value.button_pressed = GlobalVariables.include_dividers
	
	title_value.text = GlobalVariables.title
	title_f_b_value.button_pressed = GlobalVariables.title_font_bold
	title_f_i_value.button_pressed = GlobalVariables.title_font_italic
	title_p_x_value.value = float(GlobalVariables.title_position.x)
	title_p_y_value.value = float(GlobalVariables.title_position.y)
	title_c_value.color = GlobalVariables.title_color
	title_si_value.value = float(GlobalVariables.title_size)
	title_s_c_value.color = GlobalVariables.title_shadow_color
	title_s_x_value.value = float(GlobalVariables.title_shadow_position.x)
	title_s_y_value.value = float(GlobalVariables.title_shadow_position.y)
	title_o_c_value.color = GlobalVariables.title_outline_color
	title_o_s_value.value = float(GlobalVariables.title_outline_size)
	
	waveform_1_colors.color = GlobalVariables.waveform_colors[0]
	waveform_2_colors.color = GlobalVariables.waveform_colors[1]
	waveform_3_colors.color = GlobalVariables.waveform_colors[2]
	waveform_4_colors.color = GlobalVariables.waveform_colors[3]
	waveform_t_value.value = float(GlobalVariables.waveform_thickness)
	waveform_h_value.value = GlobalVariables.waveform_height
	waveform_aa_value.button_pressed = GlobalVariables.waveform_antialiasing
	
	divider_c_value.color = GlobalVariables.divider_colors[0]
	divider_c_value_2.color = GlobalVariables.divider_colors[1]
	divider_c_value_3.color = GlobalVariables.divider_colors[2]
	divider_t_value.value = float(GlobalVariables.divider_thickness)
	
	c_f_main_c_value.color = GlobalVariables.current_flow_main_color
	c_f_background_c_value.color = GlobalVariables.current_flow_background_color
	c_f_filled_value.button_pressed = GlobalVariables.current_flow_filled
	c_f_uv_s_value.value = GlobalVariables.current_flow_uv_scale
	c_f_iterations_value.value = GlobalVariables.current_flow_iterations
	c_f_wave_t_value.value = GlobalVariables.current_flow_wave_thickness
	c_f_speed_value.value = GlobalVariables.current_flow_speed
	
	d_w_color_value.color = GlobalVariables.domain_warping_color
	d_w_color_m_value.button_pressed = GlobalVariables.domain_warping_color_mix
	d_w_invert_c_value.button_pressed = GlobalVariables.domain_warping_invert_colors
	d_w_hue_s_value.value = GlobalVariables.domain_warping_hue_shift
	d_w_oct_value.value = float(GlobalVariables.domain_warping_octaves)
	d_w_freq_f_value.value = GlobalVariables.domain_warping_frequency_factor
	d_w_amp_value.value = GlobalVariables.domain_warping_amplitude
	d_w_freq_i_value.value = GlobalVariables.domain_warping_frequency_increment
	d_w_amp_d_value.value = GlobalVariables.domain_warping_amplitude_decrement
	d_w_speed_value.value = GlobalVariables.domain_warping_speed
	
	e_main_c_value.color = GlobalVariables.echoes_main_color
	e_background_c_value.color = GlobalVariables.echoes_background_color
	e_fractal_uv_value.button_pressed = GlobalVariables.echoes_fractal_uv
	e_change_o_value.button_pressed = GlobalVariables.echoes_change_origin
	e_iterations_value.value = float(GlobalVariables.echoes_iterations)
	e_uv_s_value.value = GlobalVariables.echoes_uv_scale
	e_vector_s_1_value.value = GlobalVariables.echoes_vector_scale_1
	e_iterator_f_1_value.value = GlobalVariables.echoes_iterator_factor_1
	e_uv_l_f_value.value = GlobalVariables.echoes_uv_length_factor
	e_vector_s_2_value.value = GlobalVariables.echoes_vector_scale_2
	e_iterator_f_2_value.value = GlobalVariables.echoes_iterator_factor_2
	e_time_s_value.value = GlobalVariables.echoes_time_scale
	e_iterator_f_3_value.value = GlobalVariables.echoes_iterator_factor_3
	e_distance_s_value.value = GlobalVariables.echoes_distance_scale
	e_pulse_f_value.value = GlobalVariables.echoes_pulse_frequency
	e_line_t_value.value = GlobalVariables.echoes_line_thickness
	e_iterator_f_4_value.value = GlobalVariables.echoes_iterator_factor_4
	e_assignment_m_1_value.value = float(GlobalVariables.echoes_assignment_mode_1)
	e_thickness_v_value.value = float(GlobalVariables.echoes_thickness_variation)
	e_assignment_m_2_value.value = float(GlobalVariables.echoes_assignment_mode_2)
	e_thin_l_value.button_pressed = GlobalVariables.echoes_thin_lines
	e_assignment_m_3_value.button_pressed = GlobalVariables.echoes_assignment_mode_3
	e_assignment_m_4_value.button_pressed = GlobalVariables.echoes_assignment_mode_4
	e_fractal_d_value.button_pressed = GlobalVariables.echoes_fractal_distance
	e_speed_value.value = GlobalVariables.echoes_speed
	
	bg_img_s_value.value = float(GlobalVariables.image_size)
	bg_img_o_value.value = float(GlobalVariables.image_opacity)
	bg_img_b_value.value = float(GlobalVariables.image_blur)
	
	i_line_c_value.color = GlobalVariables.isolines_line_color
	i_background_c_value.color = GlobalVariables.isolines_background_color
	i_filled_value.button_pressed = GlobalVariables.isolines_filled
	i_line_t_value.value = GlobalVariables.isolines_line_thickness
	i_thickness_v_value.value = GlobalVariables.isolines_thickness_variation
	i_line_a_value.value = GlobalVariables.isolines_line_amount
	i_uv_s_value.value = GlobalVariables.isolines_uv_scale
	i_speed_value.value = GlobalVariables.isolines_speed
	
	s_g_color_1_value.color = GlobalVariables.simple_gradient_color_1
	s_g_color_2_value.color = GlobalVariables.simple_gradient_color_2
	s_g_direction_value.value = float(GlobalVariables.simple_gradient_direction)
	
	bg_1_colors.color = GlobalVariables.background_colors[0]
	bg_2_colors.color = GlobalVariables.background_colors[1]
	bg_3_colors.color = GlobalVariables.background_colors[2]
	bg_4_colors.color = GlobalVariables.background_colors[3]
	
	t_color_value.color = GlobalVariables.tides_wave_color
	t_tint_value.color = GlobalVariables.tides_tint
	t_color_m_value.button_pressed = GlobalVariables.tides_color_mix
	t_invert_c_value.button_pressed = GlobalVariables.tides_invert_colors
	t_hue_s_value.value = GlobalVariables.tides_hue_shift
	t_iterations_value.value = float(GlobalVariables.tides_iterations)
	t_speed_value.value = GlobalVariables.tides_speed
	
	shader_brightness_value.value = GlobalVariables.shader_brightness
	shader_blur_value.value = float(GlobalVariables.shader_blur)
	
	bg_shake_a_value.value = GlobalVariables.background_shake_amplitude
	bg_shake_f_value.value = GlobalVariables.background_shake_frequency
	
	icon_e_value.button_pressed = GlobalVariables.icon_enabled
	icon_c_value.color = GlobalVariables.icon_color
	icon_r_value.value = GlobalVariables.icon_rotation
	icon_s_value.value = GlobalVariables.icon_size
	
	chromatic_a_s_value.value = GlobalVariables.chromatic_aberration_strength
	
	glitch_b_o_a_value.value = GlobalVariables.glitch_block_offset_amount
	glitch_p_o_a_value.value = GlobalVariables.glitch_pixel_offset_amount
	glitch_s_f_value.value = GlobalVariables.glitch_speed_factor
	
	spin_zoom_blur_c_m_value.button_pressed = GlobalVariables.spin_zoom_blur_change_mode
	spin_zoom_blur_s_value.value = GlobalVariables.spin_zoom_blur_strength
	
	tape_d_w_s_value.value = GlobalVariables.tape_distortion_wave_strength
	tape_d_w_sp_value.value = GlobalVariables.tape_distortion_wave_speed
	tape_d_w_f_value.value = GlobalVariables.tape_distortion_wave_frequency
	tape_d_w_t_value.value = float(GlobalVariables.tape_distortion_wave_thickness)
	tape_d_b_s_value.value = GlobalVariables.tape_distortion_block_strength
	tape_d_b_sp_value.value = GlobalVariables.tape_distortion_block_speed
	tape_d_b_f_value.value = GlobalVariables.tape_distortion_block_frequency

	scanlines_d_value.value = GlobalVariables.scanlines_darkness
	scanlines_a_l_value.value = GlobalVariables.scanlines_amount_of_lines
	scanlines_i_s_value.button_pressed = GlobalVariables.scanlines_interlaced_scan
	scanlines_s_value.value = GlobalVariables.scanlines_speed

	lens_d_s_value.value = GlobalVariables.lens_distortion_strength
	lens_d_z_value.value = GlobalVariables.lens_distortion_zoom
	lens_d_b_value.button_pressed = GlobalVariables.lens_distortion_border
	lens_d_b_c_value.color = GlobalVariables.lens_distortion_border_color
	lens_d_c_a_s_value.value = GlobalVariables.lens_distortion_chromatic_aberration_strength

	gradient_o_c_1_value.color = GlobalVariables.gradient_overlay_color_1
	gradient_o_c_2_value.color = GlobalVariables.gradient_overlay_color_2
	gradient_o_d_value.value = float(GlobalVariables.gradient_overlay_direction)
	gradient_o_o_value.value = GlobalVariables.gradient_overlay_opacity
	
	vignette_c_value.color = GlobalVariables.vignette_color
	vignette_s_value.value = GlobalVariables.vignette_size
	vignette_sh_value.value = GlobalVariables.vignette_sharpness
	
	bloom_a_value.value = GlobalVariables.bloom_amount
	bloom_b_m_value.select(GlobalVariables.bloom_blend_mode)
	
	grain_s_value.button_pressed = GlobalVariables.grain_static
	grain_o_value.value = float(GlobalVariables.grain_opacity)
	
	title_pos_reaction_s_value.value = GlobalVariables.title_position_reaction_strength
	title_s_reaction_s_value.value = GlobalVariables.title_size_reaction_strength
	bg_s_s_reaction_s_value.value = GlobalVariables.background_shader_speed_reaction_strength
	bg_i_s_reaction_s_value.value = GlobalVariables.background_image_size_reaction_strength
	shake_a_reaction_s_value.value = GlobalVariables.shake_amplitude_reaction_strength
	shake_f_reaction_s_value.value = GlobalVariables.shake_frequency_reaction_strength
	icon_p_reaction_s_value.value = GlobalVariables.icon_position_reaction_strength
	icon_s_reaction_s_value.value = GlobalVariables.icon_size_reaction_strength
	icon_r_reaction_s_value.value = GlobalVariables.icon_rotation_reaction_strength
	c_a_s_reaction_s_value.value = GlobalVariables.chromatic_aberration_strength_reaction_strength
	glitch_b_o_reaction_s_value.value = GlobalVariables.glitch_block_offset_reaction_strength
	glitch_p_o_reaction_s_value.value = GlobalVariables.glitch_pixel_offset_reaction_strength
	s_z_b_s_reaction_s_value.value = GlobalVariables.spin_zoom_blur_strength_reaction_strength
	vignette_s_reaction_s_value.value = GlobalVariables.vignette_size_reaction_strength
	bloom_a_reaction_s_value.value = GlobalVariables.bloom_amount_reaction_strength
	audio_r_m_db_value.value = float(GlobalVariables.audio_reaction_min_db_level)
	audio_r_smoothing_a_value.value = float(GlobalVariables.audio_reaction_smoothing_amount)
	
	var difference: int = Time.get_ticks_msec() - start_time
	MainUtils.logger("UI values set in " + str(difference) + " ms.")

func refresh_preset_list() -> void:
	preset_value.clear()
	
	var preset_iterable: int = 0
	for preset: String in GlobalVariables.presets_in_selector:
		preset_value.add_item(GlobalVariables.presets_in_selector[preset_iterable], preset_iterable)
		preset_iterable += 1
	preset_value.select(GlobalVariables.presets_in_selector.find(GlobalVariables.preset_name))
	
	MainUtils.logger("Preset list updated.")

#region CUSTOMIZE BUILT-IN SIGNAL FUNCTIONS ##################################

func _on_preset_value_item_selected(index: int) -> void:
	GlobalVariables.preset_name = GlobalVariables.presets_in_selector[index]
	GlobalVariables.load_preset(GlobalVariables.preset_name)
	
	if GlobalVariables.title_font not in GlobalVariables.title_fonts_in_selector:
		MainUtils.logger("Could not find font \"" + GlobalVariables.title_font + "\" in preset.", true)
		GlobalVariables.title_font = "Calibri"
	title_f_value.select(GlobalVariables.title_fonts_in_selector.find(GlobalVariables.title_font))
	
	bg_t_value.select(GlobalVariables.BACKGROUND_TYPES_IN_SELECTOR.find(GlobalVariables.background_type))
	
	set_ui_values()
	
	MainUtils.update_visualizer.emit()

func _on_save_preset_button_pressed() -> void:
	if not save_preset_container.visible:
		ui_anim_player.play("save_in")
		MainUtils.saving_preset.emit()
	else:
		ui_anim_player.play("save_out")

func _on_waveform_a_value_value_changed(value: float) -> void:
	GlobalVariables.number_of_stems = int(value)
	
	# Changes visibility based on amount of waveforms visible.
	var number_of_options: Array[bool] = [true, false, false, false]
	
	for waveform: int in value:
		number_of_options[waveform] = true
	
	waveform_1_colors.visible = number_of_options[0]
	waveform_2_colors.visible = number_of_options[1]
	waveform_3_colors.visible = number_of_options[2]
	waveform_4_colors.visible = number_of_options[3]
	
	bg_1_colors.visible = number_of_options[0]
	bg_2_colors.visible = number_of_options[1]
	bg_3_colors.visible = number_of_options[2]
	bg_4_colors.visible = number_of_options[3]
	
	MainUtils.update_visualizer.emit()

func _on_vertical_l_value_toggled(toggled_on: bool) -> void:
	GlobalVariables.vertical_layout = toggled_on
	
	MainUtils.update_visualizer.emit()

func _on_include_d_value_toggled(toggled_on: bool) -> void:
	GlobalVariables.include_dividers = toggled_on
	
	MainUtils.update_visualizer.emit()

func _on_title_value_text_changed(new_text: String) -> void:
	GlobalVariables.title = new_text
	
	MainUtils.update_visualizer.emit()

func _on_title_f_value_item_selected(index: int) -> void:
	GlobalVariables.title_font = GlobalVariables.title_fonts_in_selector[index]
	
	MainUtils.update_visualizer.emit()

func _on_title_f_b_value_toggled(toggled_on: bool) -> void:
	GlobalVariables.title_font_bold = toggled_on
	
	MainUtils.update_visualizer.emit()

func _on_title_f_i_value_toggled(toggled_on: bool) -> void:
	GlobalVariables.title_font_italic = toggled_on
	
	MainUtils.update_visualizer.emit()

func _on_title_p_x_value_value_changed(value: float) -> void:
	GlobalVariables.title_position.x = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_title_p_y_value_value_changed(value: float) -> void:
	GlobalVariables.title_position.y = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_title_c_value_color_changed(color: Color) -> void:
	GlobalVariables.title_color = color
	
	MainUtils.update_visualizer.emit()

func _on_title_si_value_value_changed(value: float) -> void:
	GlobalVariables.title_size = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_title_s_c_value_color_changed(color: Color) -> void:
	GlobalVariables.title_shadow_color = color
	
	MainUtils.update_visualizer.emit()

func _on_title_s_x_value_value_changed(value: float) -> void:
	GlobalVariables.title_shadow_position.x = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_title_s_y_value_value_changed(value: float) -> void:
	GlobalVariables.title_shadow_position.y = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_title_o_c_value_color_changed(color: Color) -> void:
	GlobalVariables.title_outline_color = color
	
	MainUtils.update_visualizer.emit()

func _on_title_o_s_value_value_changed(value: float) -> void:
	GlobalVariables.title_outline_size = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_waveform_1_colors_color_changed(color: Color) -> void:
	GlobalVariables.waveform_colors[0] = color
	
	MainUtils.update_visualizer.emit()

func _on_waveform_2_colors_color_changed(color: Color) -> void:
	GlobalVariables.waveform_colors[1] = color
	
	MainUtils.update_visualizer.emit()

func _on_waveform_3_colors_color_changed(color: Color) -> void:
	GlobalVariables.waveform_colors[2] = color
	
	MainUtils.update_visualizer.emit()

func _on_waveform_4_colors_color_changed(color: Color) -> void:
	GlobalVariables.waveform_colors[3] = color
	
	MainUtils.update_visualizer.emit()

func _on_waveform_t_value_value_changed(value: float) -> void:
	GlobalVariables.waveform_thickness = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_waveform_h_value_value_changed(value: float) -> void:
	GlobalVariables.waveform_height = value
	
	MainUtils.update_visualizer.emit()

func _on_waveform_aa_value_toggled(toggled_on: bool) -> void:
	GlobalVariables.waveform_antialiasing = toggled_on
	
	MainUtils.update_visualizer.emit()

func _on_divider_c_value_color_changed(color: Color) -> void:
	GlobalVariables.divider_colors[0] = color
	
	MainUtils.update_visualizer.emit()

func _on_divider_c_value_2_color_changed(color: Color) -> void:
	GlobalVariables.divider_colors[1] = color
	
	MainUtils.update_visualizer.emit()

func _on_divider_c_value_3_color_changed(color: Color) -> void:
	GlobalVariables.divider_colors[2] = color
	
	MainUtils.update_visualizer.emit()

func _on_divider_t_value_value_changed(value: float) -> void:
	GlobalVariables.divider_thickness = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_bg_t_value_item_selected(index: int) -> void:
	GlobalVariables.background_type = GlobalVariables.BACKGROUND_TYPES_IN_SELECTOR[index]
	
	MainUtils.update_visualizer.emit()

func _on_c_f_main_c_value_color_changed(color: Color) -> void:
	GlobalVariables.current_flow_main_color = color
	
	MainUtils.update_visualizer.emit()

func _on_c_f_background_c_value_color_changed(color: Color) -> void:
	GlobalVariables.current_flow_background_color = color
	
	MainUtils.update_visualizer.emit()

func _on_c_f_filled_value_toggled(toggled_on: bool) -> void:
	GlobalVariables.current_flow_filled = toggled_on
	
	MainUtils.update_visualizer.emit()

func _on_c_f_uv_s_value_value_changed(value: float) -> void:
	GlobalVariables.current_flow_uv_scale = value
	
	MainUtils.update_visualizer.emit()

func _on_c_f_iterations_value_value_changed(value: float) -> void:
	GlobalVariables.current_flow_iterations = value
	
	MainUtils.update_visualizer.emit()

func _on_c_f_wave_t_value_value_changed(value: float) -> void:
	GlobalVariables.current_flow_wave_thickness = value
	
	MainUtils.update_visualizer.emit()

func _on_c_f_speed_value_value_changed(value: float) -> void:
	GlobalVariables.current_flow_speed = value
	
	MainUtils.update_visualizer.emit()

func _on_d_w_color_value_color_changed(color: Color) -> void:
	GlobalVariables.domain_warping_color = color
	
	MainUtils.update_visualizer.emit()

func _on_d_w_color_m_value_toggled(toggled_on: bool) -> void:
	GlobalVariables.domain_warping_color_mix = toggled_on
	
	MainUtils.update_visualizer.emit()

func _on_d_w_invert_c_value_toggled(toggled_on: bool) -> void:
	GlobalVariables.domain_warping_invert_colors = toggled_on
	
	MainUtils.update_visualizer.emit()

func _on_d_w_hue_s_value_value_changed(value: float) -> void:
	GlobalVariables.domain_warping_hue_shift = value
	
	MainUtils.update_visualizer.emit()

func _on_d_w_oct_value_value_changed(value: float) -> void:
	GlobalVariables.domain_warping_octaves = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_d_w_freq_f_value_value_changed(value: float) -> void:
	GlobalVariables.domain_warping_frequency_factor = value
	
	MainUtils.update_visualizer.emit()

func _on_d_w_amp_value_value_changed(value: float) -> void:
	GlobalVariables.domain_warping_amplitude = value
	
	MainUtils.update_visualizer.emit()

func _on_d_w_freq_i_value_value_changed(value: float) -> void:
	GlobalVariables.domain_warping_frequency_increment = value
	
	MainUtils.update_visualizer.emit()

func _on_d_w_amp_d_value_value_changed(value: float) -> void:
	GlobalVariables.domain_warping_amplitude_decrement = value
	
	MainUtils.update_visualizer.emit()

func _on_d_w_speed_value_value_changed(value: float) -> void:
	GlobalVariables.domain_warping_speed = value
	
	MainUtils.update_visualizer.emit()

func _on_e_main_c_value_color_changed(color: Color) -> void:
	GlobalVariables.echoes_main_color = color
	
	MainUtils.update_visualizer.emit()

func _on_e_background_c_value_color_changed(color: Color) -> void:
	GlobalVariables.echoes_background_color = color
	
	MainUtils.update_visualizer.emit()

func _on_e_fractal_uv_value_toggled(toggled_on: bool) -> void:
	GlobalVariables.echoes_fractal_uv = toggled_on
	
	MainUtils.update_visualizer.emit()

func _on_e_change_o_value_toggled(toggled_on: bool) -> void:
	GlobalVariables.echoes_change_origin = toggled_on
	
	MainUtils.update_visualizer.emit()

func _on_e_iterations_value_value_changed(value: float) -> void:
	GlobalVariables.echoes_iterations = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_e_uv_s_value_value_changed(value: float) -> void:
	GlobalVariables.echoes_uv_scale = value
	
	MainUtils.update_visualizer.emit()

func _on_e_vector_s_1_value_value_changed(value: float) -> void:
	GlobalVariables.echoes_vector_scale_1 = value
	
	MainUtils.update_visualizer.emit()

func _on_e_iterator_f_1_value_value_changed(value: float) -> void:
	GlobalVariables.echoes_iterator_factor_1 = value
	
	MainUtils.update_visualizer.emit()

func _on_e_uv_l_f_value_value_changed(value: float) -> void:
	GlobalVariables.echoes_uv_length_factor = value
	
	MainUtils.update_visualizer.emit()

func _on_e_vector_s_2_value_value_changed(value: float) -> void:
	GlobalVariables.echoes_vector_scale_2 = value
	
	MainUtils.update_visualizer.emit()

func _on_e_iterator_f_2_value_value_changed(value: float) -> void:
	GlobalVariables.echoes_iterator_factor_2 = value
	
	MainUtils.update_visualizer.emit()

func _on_e_time_s_value_value_changed(value: float) -> void:
	GlobalVariables.echoes_time_scale = value
	
	MainUtils.update_visualizer.emit()

func _on_e_iterator_f_3_value_value_changed(value: float) -> void:
	GlobalVariables.echoes_iterator_factor_3 = value
	
	MainUtils.update_visualizer.emit()

func _on_e_distance_s_value_value_changed(value: float) -> void:
	GlobalVariables.echoes_distance_scale = value
	
	MainUtils.update_visualizer.emit()

func _on_e_pulse_f_value_value_changed(value: float) -> void:
	GlobalVariables.echoes_pulse_frequency = value
	
	MainUtils.update_visualizer.emit()

func _on_e_line_t_value_value_changed(value: float) -> void:
	GlobalVariables.echoes_line_thickness = value
	
	MainUtils.update_visualizer.emit()

func _on_e_iterator_f_4_value_value_changed(value: float) -> void:
	GlobalVariables.echoes_iterator_factor_4 = value
	
	MainUtils.update_visualizer.emit()

func _on_e_assignment_m_1_value_value_changed(value: float) -> void:
	GlobalVariables.echoes_assignment_mode_1 = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_e_thickness_v_value_value_changed(value: float) -> void:
	GlobalVariables.echoes_thickness_variation = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_e_assignment_m_2_value_value_changed(value: float) -> void:
	GlobalVariables.echoes_assignment_mode_2 = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_e_thin_l_value_toggled(toggled_on: bool) -> void:
	GlobalVariables.echoes_thin_lines = toggled_on
	
	MainUtils.update_visualizer.emit()

func _on_e_assignment_m_3_value_toggled(toggled_on: bool) -> void:
	GlobalVariables.echoes_assignment_mode_3 = toggled_on
	
	MainUtils.update_visualizer.emit()

func _on_e_assignment_m_4_value_toggled(toggled_on: bool) -> void:
	GlobalVariables.echoes_assignment_mode_4 = toggled_on
	
	MainUtils.update_visualizer.emit()

func _on_e_fractal_d_value_toggled(toggled_on: bool) -> void:
	GlobalVariables.echoes_fractal_distance = toggled_on
	
	MainUtils.update_visualizer.emit()

func _on_e_speed_value_value_changed(value: float) -> void:
	GlobalVariables.echoes_speed = value
	
	MainUtils.update_visualizer.emit()

func _on_bg_img_path_button_pressed() -> void:
	bg_img_p_file_dialog.popup()

func _on_bg_img_p_file_dialog_file_selected(path: String) -> void:
	GlobalVariables.image_path = path

func _on_bg_img_s_value_value_changed(value: float) -> void:
	GlobalVariables.image_size = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_bg_img_o_value_value_changed(value: float) -> void:
	GlobalVariables.image_opacity = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_bg_img_b_value_value_changed(value: float) -> void:
	GlobalVariables.image_blur = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_i_line_c_value_color_changed(color: Color) -> void:
	GlobalVariables.isolines_line_color = color
	
	MainUtils.update_visualizer.emit()

func _on_i_background_c_value_color_changed(color: Color) -> void:
	GlobalVariables.isolines_background_color = color
	
	MainUtils.update_visualizer.emit()

func _on_i_filled_value_toggled(toggled_on: bool) -> void:
	GlobalVariables.isolines_filled = toggled_on
	
	MainUtils.update_visualizer.emit()

func _on_i_line_t_value_value_changed(value: float) -> void:
	GlobalVariables.isolines_line_thickness = value
	
	MainUtils.update_visualizer.emit()

func _on_i_thickness_v_value_value_changed(value: float) -> void:
	GlobalVariables.isolines_thickness_variation = value
	
	MainUtils.update_visualizer.emit()

func _on_i_line_a_value_value_changed(value: float) -> void:
	GlobalVariables.isolines_line_amount = value
	
	MainUtils.update_visualizer.emit()

func _on_i_uv_s_value_value_changed(value: float) -> void:
	GlobalVariables.isolines_uv_scale = value
	
	MainUtils.update_visualizer.emit()

func _on_i_speed_value_value_changed(value: float) -> void:
	GlobalVariables.isolines_speed = value
	
	MainUtils.update_visualizer.emit()

func _on_s_g_color_1_value_color_changed(color: Color) -> void:
	GlobalVariables.simple_gradient_color_1 = color
	
	MainUtils.update_visualizer.emit()

func _on_s_g_color_2_value_color_changed(color: Color) -> void:
	GlobalVariables.simple_gradient_color_2 = color
	
	MainUtils.update_visualizer.emit()

func _on_s_g_direction_value_value_changed(value: float) -> void:
	GlobalVariables.simple_gradient_direction = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_bg_1_colors_color_changed(color: Color) -> void:
	GlobalVariables.background_colors[0] = color
	
	MainUtils.update_visualizer.emit()

func _on_bg_2_colors_color_changed(color: Color) -> void:
	GlobalVariables.background_colors[1] = color
	
	MainUtils.update_visualizer.emit()

func _on_bg_3_colors_color_changed(color: Color) -> void:
	GlobalVariables.background_colors[2] = color
	
	MainUtils.update_visualizer.emit()

func _on_bg_4_colors_color_changed(color: Color) -> void:
	GlobalVariables.background_colors[3] = color
	
	MainUtils.update_visualizer.emit()

func _on_t_color_value_color_changed(color: Color) -> void:
	GlobalVariables.tides_wave_color = color
	
	MainUtils.update_visualizer.emit()

func _on_t_tint_value_color_changed(color: Color) -> void:
	GlobalVariables.tides_tint = color
	
	MainUtils.update_visualizer.emit()

func _on_t_color_m_value_toggled(toggled_on: bool) -> void:
	GlobalVariables.tides_color_mix = toggled_on
	
	MainUtils.update_visualizer.emit()

func _on_t_invert_c_value_toggled(toggled_on: bool) -> void:
	GlobalVariables.tides_invert_colors = toggled_on
	
	MainUtils.update_visualizer.emit()

func _on_t_hue_s_value_value_changed(value: float) -> void:
	GlobalVariables.tides_hue_shift = value
	
	MainUtils.update_visualizer.emit()

func _on_t_iterations_value_value_changed(value: float) -> void:
	GlobalVariables.tides_iterations = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_t_speed_value_value_changed(value: float) -> void:
	GlobalVariables.tides_speed = value
	
	MainUtils.update_visualizer.emit()

func _on_shader_brightness_value_value_changed(value: float) -> void:
	GlobalVariables.shader_brightness = value
	
	MainUtils.update_visualizer.emit()

func _on_shader_blur_value_value_changed(value: float) -> void:
	GlobalVariables.shader_blur = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_bg_shake_a_value_value_changed(value: float) -> void:
	GlobalVariables.background_shake_amplitude = value
	
	MainUtils.update_visualizer.emit()

func _on_bg_shake_f_value_value_changed(value: float) -> void:
	GlobalVariables.background_shake_frequency = value
	
	MainUtils.update_visualizer.emit()

func _on_icon_e_value_toggled(toggled_on: bool) -> void:
	GlobalVariables.icon_enabled = toggled_on
	
	MainUtils.update_visualizer.emit()

func _on_icon_path_button_pressed() -> void:
	icon_p_file_dialog.popup()

func _on_icon_p_file_dialog_file_selected(path: String) -> void:
	GlobalVariables.icon_path = path

func _on_icon_c_value_color_changed(color: Color) -> void:
	GlobalVariables.icon_color = color
	
	MainUtils.update_visualizer.emit()

func _on_icon_r_value_value_changed(value: float) -> void:
	GlobalVariables.icon_rotation = value
	
	MainUtils.update_visualizer.emit()

func _on_icon_s_value_value_changed(value: float) -> void:
	GlobalVariables.icon_size = value
	
	MainUtils.update_visualizer.emit()

func _on_post_p_t_value_item_selected(index: int) -> void:
	GlobalVariables.post_processing_type = GlobalVariables.POST_PROCESSING_TYPES_IN_SELECTOR[index]
	
	MainUtils.update_visualizer.emit()

func _on_chromatic_a_s_value_value_changed(value: float) -> void:
	GlobalVariables.chromatic_aberration_strength = value
	
	MainUtils.update_visualizer.emit()

func _on_glitch_b_o_a_value_value_changed(value: float) -> void:
	GlobalVariables.glitch_block_offset_amount = value
	
	MainUtils.update_visualizer.emit()

func _on_glitch_p_o_a_value_value_changed(value: float) -> void:
	GlobalVariables.glitch_pixel_offset_amount = value
	
	MainUtils.update_visualizer.emit()

func _on_glitch_s_f_value_value_changed(value: float) -> void:
	GlobalVariables.glitch_speed_factor = value
	
	MainUtils.update_visualizer.emit()

func _on_spin_zoom_blur_c_m_value_toggled(toggled_on: bool) -> void:
	GlobalVariables.spin_zoom_blur_change_mode = toggled_on
	
	MainUtils.update_visualizer.emit()

func _on_spin_zoom_blur_s_value_value_changed(value: float) -> void:
	GlobalVariables.spin_zoom_blur_strength = value
	
	MainUtils.update_visualizer.emit()

func _on_tape_d_w_s_value_value_changed(value: float) -> void:
	GlobalVariables.tape_distortion_wave_strength = value
	
	MainUtils.update_visualizer.emit()

func _on_tape_d_w_sp_value_value_changed(value: float) -> void:
	GlobalVariables.tape_distortion_wave_speed = value
	
	MainUtils.update_visualizer.emit()

func _on_tape_d_w_f_value_value_changed(value: float) -> void:
	GlobalVariables.tape_distortion_wave_frequency = value
	
	MainUtils.update_visualizer.emit()

func _on_tape_d_w_t_value_value_changed(value: float) -> void:
	GlobalVariables.tape_distortion_wave_thickness = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_tape_d_b_s_value_value_changed(value: float) -> void:
	GlobalVariables.tape_distortion_block_strength = value
	
	MainUtils.update_visualizer.emit()

func _on_tape_d_b_sp_value_value_changed(value: float) -> void:
	GlobalVariables.tape_distortion_block_speed = value
	
	MainUtils.update_visualizer.emit()

func _on_tape_d_b_f_value_value_changed(value: float) -> void:
	GlobalVariables.tape_distortion_block_frequency = value
	
	MainUtils.update_visualizer.emit()

func _on_scanlines_d_value_value_changed(value: float) -> void:
	GlobalVariables.scanlines_darkness = value
	
	MainUtils.update_visualizer.emit()

func _on_scanlines_a_l_value_value_changed(value: float) -> void:
	GlobalVariables.scanlines_amount_of_lines = value
	
	MainUtils.update_visualizer.emit()

func _on_scanlines_i_s_value_toggled(toggled_on: bool) -> void:
	GlobalVariables.scanlines_interlaced_scan = toggled_on
	
	MainUtils.update_visualizer.emit()

func _on_scanlines_s_value_value_changed(value: float) -> void:
	GlobalVariables.scanlines_speed = value
	
	MainUtils.update_visualizer.emit()

func _on_lens_d_s_value_value_changed(value: float) -> void:
	GlobalVariables.lens_distortion_strength = value
	
	MainUtils.update_visualizer.emit()

func _on_lens_d_z_value_value_changed(value: float) -> void:
	GlobalVariables.lens_distortion_zoom = value
	
	MainUtils.update_visualizer.emit()

func _on_lens_d_b_value_toggled(toggled_on: bool) -> void:
	GlobalVariables.lens_distortion_border = toggled_on
	
	MainUtils.update_visualizer.emit()

func _on_lens_d_b_c_value_color_changed(color: Color) -> void:
	GlobalVariables.lens_distortion_border_color = color
	
	MainUtils.update_visualizer.emit()

func _on_lens_d_c_a_s_value_value_changed(value: float) -> void:
	GlobalVariables.lens_distortion_chromatic_aberration_strength = value
	
	MainUtils.update_visualizer.emit()

func _on_gradient_o_c_1_value_color_changed(color: Color) -> void:
	GlobalVariables.gradient_overlay_color_1 = color
	
	MainUtils.update_visualizer.emit()

func _on_gradient_o_c_2_value_color_changed(color: Color) -> void:
	GlobalVariables.gradient_overlay_color_2 = color
	
	MainUtils.update_visualizer.emit()

func _on_gradient_o_d_value_value_changed(value: float) -> void:
	GlobalVariables.gradient_overlay_direction = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_gradient_o_o_value_value_changed(value: float) -> void:
	GlobalVariables.gradient_overlay_opacity = value
	
	MainUtils.update_visualizer.emit()

func _on_vignette_c_value_color_changed(color: Color) -> void:
	GlobalVariables.vignette_color = color
	
	MainUtils.update_visualizer.emit()

func _on_vignette_s_value_value_changed(value: float) -> void:
	GlobalVariables.vignette_size = value
	
	MainUtils.update_visualizer.emit()

func _on_vignette_sh_value_value_changed(value: float) -> void:
	GlobalVariables.vignette_sharpness = value
	
	MainUtils.update_visualizer.emit()

func _on_bloom_a_value_value_changed(value: float) -> void:
	GlobalVariables.bloom_amount = value
	
	MainUtils.update_visualizer.emit()

func _on_bloom_bm_value_item_selected(index: int) -> void:
	GlobalVariables.bloom_blend_mode = index
	
	MainUtils.update_visualizer.emit()

func _on_grain_s_value_toggled(toggled_on: bool) -> void:
	GlobalVariables.grain_static = toggled_on
	
	MainUtils.update_visualizer.emit()

func _on_grain_o_value_value_changed(value: float) -> void:
	GlobalVariables.grain_opacity = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_audio_r_c_value_item_selected(index: int) -> void:
	GlobalVariables.audio_reaction_control = GlobalVariables.AUDIO_REACTION_CONTROLS_IN_SELECTOR[index]
	
	MainUtils.update_visualizer.emit()

func _on_title_pos_reaction_s_value_value_changed(value: float) -> void:
	GlobalVariables.title_position_reaction_strength = value
	
	MainUtils.update_visualizer.emit()

func _on_title_s_reaction_s_value_value_changed(value: float) -> void:
	GlobalVariables.title_size_reaction_strength = value
	
	MainUtils.update_visualizer.emit()

func _on_bg_s_s_reaction_s_value_value_changed(value: float) -> void:
	GlobalVariables.background_shader_speed_reaction_strength = value
	
	MainUtils.update_visualizer.emit()

func _on_bg_i_s_reaction_s_value_value_changed(value: float) -> void:
	GlobalVariables.background_image_size_reaction_strength = value
	
	MainUtils.update_visualizer.emit()

func _on_shake_a_reaction_s_value_value_changed(value: float) -> void:
	GlobalVariables.shake_amplitude_reaction_strength = value
	
	MainUtils.update_visualizer.emit()

func _on_shake_f_reaction_s_value_value_changed(value: float) -> void:
	GlobalVariables.shake_frequency_reaction_strength = value
	
	MainUtils.update_visualizer.emit()

func _on_icon_p_reaction_s_value_value_changed(value: float) -> void:
	GlobalVariables.icon_position_reaction_strength = value
	
	MainUtils.update_visualizer.emit()

func _on_icon_s_reaction_s_value_value_changed(value: float) -> void:
	GlobalVariables.icon_size_reaction_strength = value
	
	MainUtils.update_visualizer.emit()

func _on_icon_r_reaction_s_value_value_changed(value: float) -> void:
	GlobalVariables.icon_rotation_reaction_strength = value
	
	MainUtils.update_visualizer.emit()

func _on_c_a_s_reaction_s_value_value_changed(value: float) -> void:
	GlobalVariables.chromatic_aberration_strength_reaction_strength = value
	
	MainUtils.update_visualizer.emit()

func _on_glitch_b_o_reaction_s_value_value_changed(value: float) -> void:
	GlobalVariables.glitch_block_offset_reaction_strength = value
	
	MainUtils.update_visualizer.emit()

func _on_glitch_p_o_reaction_s_value_value_changed(value: float) -> void:
	GlobalVariables.glitch_pixel_offset_reaction_strength = value
	
	MainUtils.update_visualizer.emit()

func _on_s_z_b_s_reaction_s_value_value_changed(value: float) -> void:
	GlobalVariables.spin_zoom_blur_strength_reaction_strength = value
	
	MainUtils.update_visualizer.emit()

func _on_vignette_s_reaction_s_value_value_changed(value: float) -> void:
	GlobalVariables.vignette_size_reaction_strength = value
	
	MainUtils.update_visualizer.emit()

func _on_bloom_a_reaction_s_value_value_changed(value: float) -> void:
	GlobalVariables.bloom_amount_reaction_strength = value
	
	MainUtils.update_visualizer.emit()

func _on_audio_r_s_value_item_selected(index: int) -> void:
	GlobalVariables.spectrum_data_source = GlobalVariables.SPECTRUM_DATA_SOURCES_IN_SELECTOR[index]
	
	MainUtils.update_visualizer.emit()

func _on_audio_r_m_db_value_value_changed(value: float) -> void:
	GlobalVariables.audio_reaction_min_db_level = int(value)
	
	MainUtils.update_visualizer.emit()

func _on_audio_r_smoothing_a_value_value_changed(value: float) -> void:
	GlobalVariables.audio_reaction_smoothing_amount = int(value)
	
	MainUtils.update_visualizer.emit()

#endregion ##################################
