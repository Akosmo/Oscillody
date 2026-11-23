# Oscillody
# Copyright (C) 2025-present Akosmo

# tooltip_manager.gd is part of Oscillody.
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

signal tooltip_updated(p_visible: bool, p_text: String)

func notify_tooltip(p_visible: bool, p_property_container: BasicPropertyContainer) -> void:
	if p_visible:
		tooltip_updated.emit(p_visible, _get_tooltip_text(p_property_container))
	else:
		tooltip_updated.emit(p_visible, "")

func _get_tooltip_text(p_property_container: BasicPropertyContainer) -> String:
	var ret: String = ""
	var property_range: String = ""
	if (
		p_property_container.get_control_node() == BasicPropertyContainer.ControlNode.NUMERICAL and
		p_property_container.get_property_key() != Element.SN_ELEMENT_LAYER
	):
		var property_min: String = str(p_property_container.spin_box.get_min())
		var property_max: String = str(p_property_container.spin_box.get_max())
		if p_property_container.spin_box.is_using_rounded_values():
			property_min = property_min.replace(".0", "")
			property_max = property_max.replace(".0", "")
		property_range = "Range: " + property_min + " to " + property_max
	
	match p_property_container.get_property_key():
		FileManager.SN_PRESET:
			ret = "Selects a visualizer preset."
		FileManager.SN_MASTER:
			ret = "Sets an imported audio to be audible. Resetting this property clears all imported files."
		Element.SN_ELEMENT_NAME:
			ret = "Sets the name of the Element."
		Element.SN_ELEMENT_TYPE:
			ret = "Sets the type of the Element."
		Element.SN_ELEMENT_LAYER:
			ret = "Sets the layer of the Element. The higher the value, the closer the Element is to the \
foreground."
		Element.SN_ELEMENT_VISIBILITY:
			ret = "Sets the visibility of the Element."
		ElementAnalyzer.SN_ANALYZER_TYPE:
			ret = "Sets the type of the analyzer. Waveform displays audio in the time domain, while Spectrum \
displays audio in the frequency domain."
		ElementAnalyzer.SN_ANALYZER_BEGIN_X_POSITION:
			ret = "Sets the beginning position of the analyzer in the horizontal axis."
		ElementAnalyzer.SN_ANALYZER_BEGIN_Y_POSITION:
			ret = "Sets the beginning position of the analyzer in the vertical axis."
		ElementAnalyzer.SN_ANALYZER_END_X_POSITION:
			ret = "Sets the ending position of the analyzer in the horizontal axis."
		ElementAnalyzer.SN_ANALYZER_END_Y_POSITION:
			ret = "Sets the ending position of the analyzer in the vertical axis."
		ElementAnalyzer.SN_ANALYZER_HEIGHT:
			ret = "Sets the height of the analyzer."
		ElementAnalyzer.SN_WAVEFORM_SAMPLE_HISTORY_LENGTH:
			ret = "Sets the length of the sample history of the waveform. The longer the history, the longer \
old audio data stays on the screen, giving the impression of a longer waveform."
		ElementAnalyzer.SN_WAVEFORM_THICKNESS:
			ret = "Sets the thickness of the waveform."
		ElementAnalyzer.SN_WAVEFORM_COLOR:
			ret = "Sets the color of the waveform."
		ElementAnalyzer.SN_WAVEFORM_ANTIALIASING:
			ret = "Sets the anti-aliasing of the waveform. If enabled, the waveform appears smooth."
		ElementImage.SN_IMAGE_PATH:
			ret = "Sets the file path of the image."
		ElementImage.SN_IMAGE_STRETCH_MODE:
			ret = "Sets the stretch mode of the image. \"Cover\" covers everything, \
by stretching the image so that its shortest side fits the boundaries. \"Center\" just fits the image \
without clipping any part outside. \"Detect\" chooses \"Cover\" if the image's ratio is the same \
as the visualizer. Otherwise, \"Center\" will be chosen. All modes keep ratio and center the image."
		ElementImage.SN_IMAGE_X_POSITION:
			ret = "Sets the position of the image in the horizontal axis."
		ElementImage.SN_IMAGE_Y_POSITION:
			ret = "Sets the position of the image in the vertical axis."
		ElementImage.SN_IMAGE_ROTATION:
			ret = "Sets the rotation of the image, in degrees."
		ElementImage.SN_IMAGE_SCALE:
			ret = "Sets the scale of the image."
		ElementImage.SN_IMAGE_COLOR:
			ret = "Sets the color multiplier of the image, where each color channel ranges from 0.0 to 1.0."
		ElementImage.SN_IMAGE_BLUR:
			ret = "Sets the blur amount of the image."
		ElementImage.SN_IMAGE_ROTATION_REACTION:
			ret = "Sets the amount of audio reaction for the rotation of the image."
		ElementImage.SN_IMAGE_SCALE_REACTION:
			ret = "Sets the amount of audio reaction for the scale of the image."
		ElementReactive.SN_BEGIN_FREQUENCY:
			ret = "Sets the beginning frequency for audio reaction, in hertz. From this frequency, the loudest \
audio magnitude is used for audio reaction."
		ElementReactive.SN_END_FREQUENCY:
			ret = "Sets the ending frequency for audio reaction, in hertz. Up to this frequency, the loudest \
audio magnitude is used for audio reaction."
		ElementReactive.SN_MINIMUM_DECIBELS:
			ret = "Sets the minimum amplitude for audio reaction, in decibels. Only audio magnitude above this \
value is used for audio reaction."
		ElementReactive.SN_SMOOTHING_TYPE:
			ret = "Sets the type of smoothing used for audio reaction. With Decay, values change instantly if \
the new magnitude value is louder than the old magnitude value, and decays linearly otherwise. With \
Interpolation, values interpolate from the old magnitude value to the new magnitude value."
		ElementReactive.SN_SMOOTHING_AMOUNT:
			ret = "Sets the amount of smoothing applied for audio reaction."
		ElementShader.SN_SHADER_TYPE:
			ret = "Sets the type of the shader."
		ElementShader.SN_CURRENT_FLOW_WAVE_COLOR:
			ret = "Sets the main color of this shader."
		ElementShader.SN_CURRENT_FLOW_BACKGROUND_COLOR:
			ret = "Sets the background color of this shader."
		ElementShader.SN_CURRENT_FLOW_ITERATIONS:
			ret = "Sets the number of internal iterations of this shader."
		ElementShader.SN_CURRENT_FLOW_UV_SCALE:
			ret = "Sets the internal scale of this shader."
		ElementShader.SN_CURRENT_FLOW_FILLED:
			ret = "Sets the noise of this shader to be filled."
		ElementShader.SN_CURRENT_FLOW_WAVE_THICKNESS:
			ret = "Sets the wave thickness of this shader."
		ElementShader.SN_DOMAIN_WARPING_COLOR:
			ret = "Sets the color of this shader."
		ElementShader.SN_DOMAIN_WARPING_COLOR_MIX:
			ret = "Makes the noise in this shader have different hues that when averaged, \
results in the selected color."
		ElementShader.SN_DOMAIN_WARPING_INVERT_COLORS:
			ret = "Inverts the colors of this shader."
		ElementShader.SN_DOMAIN_WARPING_HUE_SHIFT:
			ret = "Shifts the hue of this shader."
		ElementShader.SN_DOMAIN_WARPING_OCTAVES:
			ret = "Sets the number of layered noises in this shader."
		ElementShader.SN_DOMAIN_WARPING_FREQUENCY_FACTOR:
			ret = "Sets the frequency multiplier of this shader."
		ElementShader.SN_DOMAIN_WARPING_AMPLITUDE:
			ret = "Sets the base amplitude of this shader."
		ElementShader.SN_DOMAIN_WARPING_FREQUENCY_INCREMENT:
			ret = "Sets the frequency increment of this shader."
		ElementShader.SN_DOMAIN_WARPING_AMPLITUDE_DECREMENT:
			ret = "Sets the amplidude decrement of this shader."
		ElementShader.SN_ECHOES_PULSE_COLOR:
			ret = "Sets the main color of this shader."
		ElementShader.SN_ECHOES_BACKGROUND_COLOR:
			ret = "Sets the background color of this shader."
		ElementShader.SN_ECHOES_ITERATIONS:
			ret = "Sets the number of internal iterations of this shader."
		ElementShader.SN_ECHOES_UV_SCALE:
			ret = "Sets the internal scale of this shader."
		ElementShader.SN_ECHOES_FRACTIONAL_UV:
			ret = "Sets the internal mapping of this shader to be more fractal-like."
		ElementShader.SN_ECHOES_SPLIT:
			ret = "Sets the origin mode of this shader."
		ElementShader.SN_ECHOES_ITERATOR_FACTOR:
			ret = "Sets the iterator factor of this shader."
		ElementShader.SN_ECHOES_PULSE_DURATION:
			ret = "Sets the duration of the pulses in this shader."
		ElementShader.SN_ECHOES_PULSE_OSCILLATION:
			ret = "Sets the frequency of oscillation of the pulses in this shader."
		ElementShader.SN_ECHOES_PULSE_THICKNESS:
			ret = "Sets the thickness of the pulses in this shader."
		ElementShader.SN_ECHOES_PULSE_MODE:
			ret = "Sets the pulse behavior in this shader."
		ElementShader.SN_ISOLINES_LINE_COLOR:
			ret = "Sets the main color of this shader."
		ElementShader.SN_ISOLINES_BACKGROUND_COLOR:
			ret = "Sets the background color of this shader."
		ElementShader.SN_ISOLINES_UV_SCALE:
			ret = "Sets the internal scale of this shader."
		ElementShader.SN_ISOLINES_FILLED:
			ret = "Sets the noise of this shader to be filled, resembling Perlin noise."
		ElementShader.SN_ISOLINES_LINE_THICKNESS:
			ret = "Sets the thickness of the lines in this shader."
		ElementShader.SN_ISOLINES_THICKNESS_VARIATION:
			ret = "Sets the amount of variation in thickness of the lines in this shader."
		ElementShader.SN_ISOLINES_LINE_AMOUNT:
			ret = "Sets the amount of lines in this shader. This number is not precise."
		ElementShader.SN_SIMPLE_GRADIENT_COLOR_1:
			ret = "Sets one of the colors of this shader."
		ElementShader.SN_SIMPLE_GRADIENT_COLOR_2:
			ret = "Sets one of the colors of this shader."
		ElementShader.SN_SIMPLE_GRADIENT_ORIGIN:
			ret = "Sets the origin of the first color in this shader."
		ElementShader.SN_TIDES_COLOR:
			ret = "Sets the color of this shader."
		ElementShader.SN_TIDES_TINT:
			ret = "Sets the tint color of this shader, overlaying on top of the first shader, blending \
similarly to linear dodge."
		ElementShader.SN_TIDES_COLOR_MIX:
			ret = "Makes the noise in this shader have different hues that when averaged, \
results in the selected color."
		ElementShader.SN_TIDES_INVERT_COLORS:
			ret = "Inverts the colors of this shader."
		ElementShader.SN_TIDES_HUE_SHIFT:
			ret = "Shifts the hue of this shader."
		ElementShader.SN_TIDES_ITERATIONS:
			ret = "Sets the number of internal iterations of this shader."
		ElementShader.SN_SHADER_SPEED:
			ret = "Sets the speed of the shader."
		ElementShader.SN_SHADER_TIME_OFFSET:
			ret = "Sets the time offset, used for shader movement. If two or more shaders have the same \
time offset and speed, they should overlap (make sure to resync in Settings)."
		ElementShader.SN_SHADER_BLEND_MODE:
			ret = "Sets the blend mode for this shader. It will blend with every layer that's behind it."
		ElementShader.SN_SHADER_MIRROR:
			ret = "Sets the mirroring axis of the shader."
		ElementShader.SN_SHADER_X_POSITION:
			ret = "Sets the position of the shader in the horizontal axis."
		ElementShader.SN_SHADER_Y_POSITION:
			ret = "Sets the position of the shader in the vertical axis."
		ElementShader.SN_SHADER_ROTATION:
			ret = "Sets the rotation of the shader, in degrees."
		ElementShader.SN_SHADER_SCALE:
			ret = "Sets the scale of the shader."
		ElementShader.SN_SHADER_BLUR:
			ret = "Sets the blur amount of the shader."
		ElementShader.SN_SHADER_BRIGHTNESS:
			ret = "Sets the brightness of the shader."
		ElementShader.SN_SHADER_SPEED_REACTION:
			ret = "Sets the amount of audio reaction for the speed of the shader."
		ElementShader.SN_SHADER_ROTATION_REACTION:
			ret = "Sets the amount of audio reaction for the rotation of the shader."
		ElementShader.SN_SHADER_SCALE_REACTION:
			ret = "Sets the amount of audio reaction for the scale of the shader."
		ElementShakable.SN_SHAKE_AMPLITUDE:
			ret = "Sets the amount of shaking for the Element."
		ElementShakable.SN_SHAKE_AMPLITUDE_COMPENSATION:
			ret = "If enabled, enough scaling will be applied to avoid showing past the borders of the \
Element. This property ignores any other scale property, applying the necessary scaling anyway."
		ElementShakable.SN_SHAKE_FREQUENCY:
			ret = "Sets the speed at which the Element will shake."
		ElementShakable.SN_SHAKE_SEED:
			ret = "Sets the seed of the noise used for shaking. If two or more Elements have the same \
seed, they will shake the same way (make sure to resync in Settings)."
		ElementShakable.SN_SHAKE_AMPLITUDE_REACTION:
			ret = "Sets the amount of audio reaction for the shake amplitude of the Element."
		ElementShakable.SN_SHAKE_FREQUENCY_REACTION:
			ret = "Sets the amount of audio reaction for the shake frequency of the Element."
		ElementText.SN_TEXT:
			ret = "Sets the text."
		ElementText.SN_TEXT_DYNAMIC:
			ret = "Allows special parsing of the text. {" + "time_position} and {" + "time_duration} \
(both with curly brackets) are replaced with their respective values, and <FLOAT_TIME_IN_SECONDS><TEXT> \
(both with angle brackets) create timed text. Example: <2.0><Hello>. Use multiple lines to create \
a text sequence, such as song lyrics."
		ElementText.SN_TEXT_FONT:
			ret = "Sets the text font."
		ElementText.SN_TEXT_BOLD:
			ret = "Sets the text font to bold."
		ElementText.SN_TEXT_ITALIC:
			ret = "Sets the text font to italic."
		ElementText.SN_TEXT_SIZE:
			ret = "Sets the text font size, in pixels."
		ElementText.SN_TEXT_X_POSITION:
			ret = "Sets the position of the text in the horizontal axis."
		ElementText.SN_TEXT_Y_POSITION:
			ret = "Sets the position of the text in the vertical axis."
		ElementText.SN_TEXT_ROTATION:
			ret = "Sets the rotation of the text, in degrees."
		ElementText.SN_TEXT_COLOR:
			ret = "Sets the color of the text."
		ElementText.SN_TEXT_SHADOW_X_POSITION:
			ret = "Sets the position of the shadow in the horizontal axis, in relation to the text, in pixels."
		ElementText.SN_TEXT_SHADOW_Y_POSITION:
			ret = "Sets the position of the shadow in the vertical axis, in relation to the text, in pixels."
		ElementText.SN_TEXT_SHADOW_SIZE:
			ret = "Sets the size of the shadow, in relation to the text, in pixels."
		ElementText.SN_TEXT_SHADOW_COLOR:
			ret = "Sets the color of the shadow."
		ElementText.SN_TEXT_OUTLINE_SIZE:
			ret = "Sets the size of the outline, in relation to the text, in pixels."
		ElementText.SN_TEXT_OUTLINE_COLOR:
			ret = "Sets the color of the outline."
		ElementText.SN_TEXT_LINE_SPACING:
			ret = "Sets the space between lines."
		ElementText.SN_TEXT_HORIZONTAL_ALIGNMENT:
			ret = "Sets the horizontal alignment."
		ElementText.SN_TEXT_ROTATION_REACTION:
			ret = "Sets the amount of audio reaction for the rotation of the text Element."
		ElementText.SN_TEXT_SCALE_REACTION:
			ret = "Sets the amount of audio reaction for the scale of the text Element."
		ElementVisualEffect.SN_VISUAL_EFFECT_TYPE:
			ret = "Sets the type of the visual effect."
		ElementVisualEffect.SN_BLOOM_OPACITY:
			ret = "Sets the opacity of this visual effect."
		ElementVisualEffect.SN_BLOOM_RADIUS:
			ret = "Sets the radius of this visual effect."
		ElementVisualEffect.SN_BLOOM_BLEND_MODE:
			ret = "Sets the blend mode of this visual effect."
		ElementVisualEffect.SN_CHROMATIC_ABERRATION_AMOUNT:
			ret = "Sets the amount of this visual effect."
		ElementVisualEffect.SN_GLITCH_BLOCK_OFFSET_AMOUNT:
			ret = "Sets the amount of block offset in this visual effect."
		ElementVisualEffect.SN_GLITCH_BLOCK_SPEED:
			ret = "Sets the speed in which blocks change in this visual effect."
		ElementVisualEffect.SN_GLITCH_LINE_OFFSET_AMOUNT:
			ret = "Sets the amount of line offset in this visual effect."
		ElementVisualEffect.SN_GLITCH_LINE_SPEED:
			ret = "Sets the speed in which lines change in this visual effect."
		ElementVisualEffect.SN_GRAIN_OPACITY:
			ret = "Sets the opacity of this visual effect."
		ElementVisualEffect.SN_GRAIN_BLEND_MODE:
			ret = "Sets the blend mode of this visual effect."
		ElementVisualEffect.SN_GRAIN_STATIC:
			ret = "Sets the noise of this visual effect to be static."
		ElementVisualEffect.SN_GRAIN_BLUR:
			ret = "Sets the noise in this visual effect to be interpolated."
		ElementVisualEffect.SN_LENS_DISTORTION_AMOUNT:
			ret = "Sets the amount of this visual effect."
		ElementVisualEffect.SN_LENS_DISTORTION_ZOOM_FACTOR:
			ret = "Sets the zoom factor of this effect."
		ElementVisualEffect.SN_LENS_DISTORTION_BORDER:
			ret = "Makes a colored border visible past the edges."
		ElementVisualEffect.SN_LENS_DISTORTION_BORDER_COLOR:
			ret = "Sets the color of the border."
		ElementVisualEffect.SN_LENS_DISTORTION_CHROMATIC_ABERRATION_AMOUNT:
			ret = "Sets the amount of chromatic aberration in this visual effect."
		ElementVisualEffect.SN_SCANLINES_OPACITY:
			ret = "Sets the opacity of this visual effect."
		ElementVisualEffect.SN_SCANLINES_INTERLACED_SCAN:
			ret = "Adds a wave distortion to the visualizer."
		ElementVisualEffect.SN_SCANLINES_SCALE:
			ret = "Sets the internal scale of this visual effect."
		ElementVisualEffect.SN_SCANLINES_SPEED:
			ret = "Sets the speed of this visual effect."
		ElementVisualEffect.SN_SPIN_ZOOM_BLUR_AMOUNT:
			ret = "Sets the amount of this visual effect."
		ElementVisualEffect.SN_SPIN_ZOOM_BLUR_MODE:
			ret = "Sets the blurring mode of this visual effect."
		ElementVisualEffect.SN_TAPE_DISTORTION_WAVE_OFFSET_AMOUNT:
			ret = "Sets the amount of wave offset in this visual effect."
		ElementVisualEffect.SN_TAPE_DISTORTION_WAVE_AMOUNT:
			ret = "Sets the amount of waves in this visual effect."
		ElementVisualEffect.SN_TAPE_DISTORTION_WAVE_THICKNESS:
			ret = "Sets the thickness of each wave in this visual effect."
		ElementVisualEffect.SN_TAPE_DISTORTION_WAVE_SPEED:
			ret = "Sets the speed of the waves in this visual effect."
		ElementVisualEffect.SN_TAPE_DISTORTION_BLOCK_OFFSET_AMOUNT:
			ret = "Sets the amount of block offset in this visual effect."
		ElementVisualEffect.SN_TAPE_DISTORTION_BLOCK_AMOUNT:
			ret = "Sets the amount of blocks in this visual effect."
		ElementVisualEffect.SN_TAPE_DISTORTION_BLOCK_SPEED:
			ret = "Sets the speed of the blocks in this visual effect."
		ElementVisualEffect.SN_VIGNETTE_SIZE:
			ret = "Sets the internal size of this visual effect."
		ElementVisualEffect.SN_VIGNETTE_COLOR:
			ret = "Sets the color of this visual effect."
		ElementVisualEffect.SN_VIGNETTE_SHARPNESS:
			ret = "Sets the sharpness of this visual effect."
		ElementVisualEffect.SN_VIGNETTE_CURVE:
			ret = "Sets the rounded shape of this visual effect."
		ElementVisualEffect.SN_VIGNETTE_SHAPE:
			ret = "Sets the general shape of this visual effect."
		ElementVisualEffect.SN_VIGNETTE_FALLOFF_FUNCTION:
			ret = "Sets the falloff function applied to the sharpness of this visual effect."
		ElementVisualEffect.SN_BLOOM_OPACITY_REACTION:
			ret = "Sets the amount of audio reaction for the opacity of this visual effect."
		ElementVisualEffect.SN_CHROMATIC_ABERRATION_AMOUNT_REACTION:
			ret = "Sets the amount of audio reaction for the amount of this visual effect."
		ElementVisualEffect.SN_GLITCH_BLOCK_OFFSET_AMOUNT_REACTION:
			ret = "Sets the amount of audio reaction for the amount of block offset of this visual effect."
		ElementVisualEffect.SN_GLITCH_BLOCK_SPEED_REACTION:
			ret = "Sets the amount of audio reaction for the speed of blocks in this visual effect."
		ElementVisualEffect.SN_GLITCH_LINE_OFFSET_AMOUNT_REACTION:
			ret = "Sets the amount of audio reaction for the amount of line offset of this visual effect."
		ElementVisualEffect.SN_GLITCH_LINE_SPEED_REACTION:
			ret = "Sets the amount of audio reaction for the speed of lines in this visual effect."
		ElementVisualEffect.SN_LENS_DISTORTION_AMOUNT_REACTION:
			ret = "Sets the amount of audio reaction for the amount of this visual effect."
		ElementVisualEffect.SN_LENS_DISTORTION_ZOOM_FACTOR_REACTION:
			ret = "Sets the amount of audio reaction for the zoom factor of this visual effect."
		ElementVisualEffect.SN_SCANLINES_SPEED_REACTION:
			ret = "Sets the amount of audio reaction for the speed of this visual effect."
		ElementVisualEffect.SN_SPIN_ZOOM_BLUR_AMOUNT_REACTION:
			ret = "Sets the amount of audio reaction for the amount of this visual effect."
		ElementVisualEffect.SN_TAPE_DISTORTION_WAVE_OFFSET_AMOUNT_REACTION:
			ret = "Sets the amount of audio reaction for the wave offset amount of this visual effect"
		ElementVisualEffect.SN_TAPE_DISTORTION_WAVE_SPEED_REACTION:
			ret = "Sets the amount of audio reaction for the wave speed of this visual effect"
		ElementVisualEffect.SN_TAPE_DISTORTION_BLOCK_OFFSET_AMOUNT_REACTION:
			ret = "Sets the amount of audio reaction for the block offset amount of this visual effect"
		ElementVisualEffect.SN_TAPE_DISTORTION_BLOCK_SPEED_REACTION:
			ret = "Sets the amount of audio reaction for the block speed of this visual effect"
		ElementVisualEffect.SN_VIGNETTE_SIZE_REACTION:
			ret = "Sets the amount of audio reaction for the size of this visual effect."
		ElementWithAudio.SN_AUDIO_SOURCE:
			ret = "Sets the source of audio data for the Element. The options consist of a list of the \
audio files imported in this session. The property can either be used to visualize audio with the analyzer \
Element, or to make other properties react to the bass frequencies of the selected audio."
		SettingsManager.SN_INPUT_DEVICE:
			ret = "Sets the input device used to capture audio data in real-time."
		SettingsManager.SN_OUTPUT_DEVICE:
			ret = "Sets the output device used to play back audio."
		SettingsManager.SN_EXPORT_RESOLUTION:
			ret = "Sets the resolution used for exported videos."
		SettingsManager.SN_FFMPEG_PATH:
			ret = "Sets the path of the FFmpeg executable necessary for video export. This button is disabled \
if the selected path is already selected. If necessary, click the reset button."
		SettingsManager.SN_DELETE_TEMPORARY_FILES:
			ret = "Makes Oscillody delete every temporary file generated during video export. Disabling this \
allows you to merge both files however you want."
		SettingsManager.SN_APP_THEME:
			ret = "Sets the appearance of Oscillody."
		SettingsManager.SN_SWITCH_TO_SLIDERS:
			ret = "[TO BE DEPRECATED] Sets all spin boxes to be sliders instead."
		SettingsManager.SN_SYNC_ELEMENT_SHAKE:
			ret = "Resyncs every Element currently shaking. Elements with the same seed should shake equally."
		SettingsManager.SN_SYNC_SHADER_TIME:
			ret = "Resets the time used for shader movement. Shaders with the same speed and time offset should \
overlap."
		SettingsManager.SN_DEBUG_PANEL:
			ret = "Displays a panel with real-time information about the application. Used for debugging."
		_:
			ret = ""
	
	if property_range.is_empty():
		return ret
	else:
		return ret + " " + property_range
