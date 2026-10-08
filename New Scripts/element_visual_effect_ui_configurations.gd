# Oscillody
# Copyright (C) 2025-present Akosmo

# element_visual_effect_ui_configurations.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ElementVisualEffectUIConfigurations
extends ElementUIConfigurations

var _bloom_visibility: bool = false
var _chromatic_aberration_visibility: bool = false
var _glitch_visibility: bool = false
var _grain_visibility: bool = false
var _lens_distortion_visibility: bool = false
var _scanlines_visibility: bool = false
var _spin_zoom_blur_visibility: bool = false
var _tape_distortion_visibility: bool = false
var _vignette_visibility: bool = false

var _reaction_visibility: bool = false

var _bloom_reaction_visibility: bool = false
var _chromatic_aberration_reaction_visibility: bool = false
var _glitch_reaction_visibility: bool = false
var _grain_reaction_visibility: bool = false
var _lens_distortion_reaction_visibility: bool = false
var _scanlines_reaction_visibility: bool = false
var _spin_zoom_blur_reaction_visibility: bool = false
var _tape_distortion_reaction_visibility: bool = false
var _vignette_reaction_visibility: bool = false

func enable_visual_effect_visibility(p_visual_effect: ElementVisualEffect.VisualEffectType) -> void:
	_bloom_visibility = false
	_chromatic_aberration_visibility = false
	_glitch_visibility = false
	_grain_visibility = false
	_lens_distortion_visibility = false
	_scanlines_visibility = false
	_spin_zoom_blur_visibility = false
	_tape_distortion_visibility = false
	_vignette_visibility = false
	
	match p_visual_effect:
		ElementVisualEffect.VisualEffectType.BLOOM:
			_bloom_visibility = true
		ElementVisualEffect.VisualEffectType.CHROMATIC_ABERRATION:
			_chromatic_aberration_visibility = true
		ElementVisualEffect.VisualEffectType.GLITCH:
			_glitch_visibility = true
		ElementVisualEffect.VisualEffectType.GRAIN:
			_grain_visibility = true
		ElementVisualEffect.VisualEffectType.LENS_DISTORTION:
			_lens_distortion_visibility = true
		ElementVisualEffect.VisualEffectType.SCANLINES:
			_scanlines_visibility = true
		ElementVisualEffect.VisualEffectType.SPIN_ZOOM_BLUR:
			_spin_zoom_blur_visibility = true
		ElementVisualEffect.VisualEffectType.TAPE_DISTORTION:
			_tape_distortion_visibility = true
		ElementVisualEffect.VisualEffectType.VIGNETTE:
			_vignette_visibility = true
	
	ElementManager.notify_property_node_visibility_changed()

func set_reaction_visibility(p_visual_effect: ElementVisualEffect.VisualEffectType, p_value: bool) -> void:
	_reaction_visibility = false
	
	_bloom_reaction_visibility = false
	_chromatic_aberration_reaction_visibility = false
	_glitch_reaction_visibility = false
	_grain_reaction_visibility = false
	_lens_distortion_reaction_visibility = false
	_scanlines_reaction_visibility = false
	_spin_zoom_blur_reaction_visibility = false
	_tape_distortion_reaction_visibility = false
	_vignette_reaction_visibility = false
	
	if not p_value:
		ElementManager.notify_property_node_visibility_changed()
		return
	
	_reaction_visibility = true
	
	match p_visual_effect:
		ElementVisualEffect.VisualEffectType.BLOOM:
			_bloom_reaction_visibility = true
		ElementVisualEffect.VisualEffectType.CHROMATIC_ABERRATION:
			_chromatic_aberration_reaction_visibility = true
		ElementVisualEffect.VisualEffectType.GLITCH:
			_glitch_reaction_visibility = true
		ElementVisualEffect.VisualEffectType.GRAIN:
			_grain_reaction_visibility = true
		ElementVisualEffect.VisualEffectType.LENS_DISTORTION:
			_lens_distortion_reaction_visibility = true
		ElementVisualEffect.VisualEffectType.SCANLINES:
			_scanlines_reaction_visibility = true
		ElementVisualEffect.VisualEffectType.SPIN_ZOOM_BLUR:
			_spin_zoom_blur_reaction_visibility = true
		ElementVisualEffect.VisualEffectType.TAPE_DISTORTION:
			_tape_distortion_reaction_visibility = true
		ElementVisualEffect.VisualEffectType.VIGNETTE:
			_vignette_reaction_visibility = true
	
	ElementManager.notify_property_node_visibility_changed()

func get_configurations() -> Dictionary[StringName, Dictionary]:
	var ret: Dictionary[StringName, Dictionary] = {
		ElementVisualEffect.SN_ELEMENT_NAME: {
			CONTROL_NODE: ControlNode.LINE_EDIT,
		},
		ElementVisualEffect.SN_ELEMENT_TYPE: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			DEFAULT_VALUE: ElementVisualEffect.ElementType.EMPTY,
			OPTIONS: ElementVisualEffect.ELEMENT_TYPES
		},
		ElementVisualEffect.SN_ELEMENT_LAYER: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			MINIMUM: 0.0,
			MAXIMUM: ElementManager.get_element_count() - 1.0,
			STEP: 1.0,
			ROUNDED: true
		},
		ElementVisualEffect.SN_ELEMENT_VISIBILITY: {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: true
		},
		ElementVisualEffect.SN_VISUAL_EFFECT_TYPE: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			OPTIONS: ElementVisualEffect.VISUAL_EFFECT_TYPES
		},
		ElementVisualEffect.SN_BLOOM_OPACITY: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _bloom_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 2.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_BLOOM_RADIUS: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 1.0,
			VISIBLE: _bloom_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 6.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_BLOOM_BLEND_MODE: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			DEFAULT_VALUE: ElementVisualEffect.BloomBlendMode.LINEAR_DODGE,
			VISIBLE: _bloom_visibility,
			OPTIONS: ElementVisualEffect.BLOOM_BLEND_MODES
		},
		ElementVisualEffect.SN_CHROMATIC_ABERRATION_AMOUNT: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _chromatic_aberration_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_GLITCH_BLOCK_OFFSET_AMOUNT: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _glitch_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_GLITCH_BLOCK_SPEED: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.2,
			VISIBLE: _glitch_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_GLITCH_LINE_OFFSET_AMOUNT: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _glitch_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_GLITCH_LINE_SPEED: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.2,
			VISIBLE: _glitch_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_GRAIN_OPACITY: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _grain_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_GRAIN_BLEND_MODE: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			DEFAULT_VALUE: ElementVisualEffect.GrainBlendMode.SOFT_LIGHT,
			VISIBLE: _grain_visibility,
			OPTIONS: ElementVisualEffect.GRAIN_BLEND_MODES
		},
		ElementVisualEffect.SN_GRAIN_STATIC: {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: false,
			VISIBLE: _grain_visibility
		},
		ElementVisualEffect.SN_GRAIN_BLUR: {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: true,
			VISIBLE: _grain_visibility
		},
		ElementVisualEffect.SN_LENS_DISTORTION_AMOUNT: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _lens_distortion_visibility,
			MINIMUM: -1.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_LENS_DISTORTION_ZOOM_FACTOR: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 1.0,
			VISIBLE: _lens_distortion_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 2.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_LENS_DISTORTION_BORDER: {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: true,
			VISIBLE: _lens_distortion_visibility
		},
		ElementVisualEffect.SN_LENS_DISTORTION_BORDER_COLOR: {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.BLACK,
			VISIBLE: _lens_distortion_visibility
		},
		ElementVisualEffect.SN_LENS_DISTORTION_CHROMATIC_ABERRATION_AMOUNT: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _lens_distortion_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_SCANLINES_OPACITY: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _scanlines_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_SCANLINES_INTERLACED_SCAN: {
			CONTROL_NODE: ControlNode.CHECK_BUTTON,
			DEFAULT_VALUE: false,
			VISIBLE: _scanlines_visibility
		},
		ElementVisualEffect.SN_SCANLINES_SCALE: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.2,
			VISIBLE: _scanlines_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_SCANLINES_SPEED: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.2,
			VISIBLE: _scanlines_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_SPIN_ZOOM_BLUR_AMOUNT: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _spin_zoom_blur_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_SPIN_ZOOM_BLUR_MODE: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			DEFAULT_VALUE: ElementVisualEffect.SpinZoomBlurMode.SPIN,
			VISIBLE: _spin_zoom_blur_visibility,
			OPTIONS: ElementVisualEffect.SPIN_ZOOM_BLUR_MODES
		},
		ElementVisualEffect.SN_TAPE_DISTORTION_WAVE_OFFSET_AMOUNT: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _tape_distortion_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_TAPE_DISTORTION_WAVE_AMOUNT: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.2,
			VISIBLE: _tape_distortion_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_TAPE_DISTORTION_WAVE_THICKNESS: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.2,
			VISIBLE: _tape_distortion_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_TAPE_DISTORTION_WAVE_SPEED: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.2,
			VISIBLE: _tape_distortion_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_TAPE_DISTORTION_BLOCK_OFFSET_AMOUNT: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _tape_distortion_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_TAPE_DISTORTION_BLOCK_AMOUNT: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.4,
			VISIBLE: _tape_distortion_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_TAPE_DISTORTION_BLOCK_SPEED: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.2,
			VISIBLE: _tape_distortion_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_VIGNETTE_SIZE: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _vignette_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_VIGNETTE_COLOR: {
			CONTROL_NODE: ControlNode.COLOR_PICKER_BUTTON,
			DEFAULT_VALUE: Color.BLACK,
			VISIBLE: _vignette_visibility
		},
		ElementVisualEffect.SN_VIGNETTE_SHARPNESS: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.05,
			VISIBLE: _vignette_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementVisualEffect.SN_VIGNETTE_CURVE: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.05,
			VISIBLE: _vignette_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.05,
			ROUNDED: false
		},
		ElementVisualEffect.SN_VIGNETTE_SHAPE: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			DEFAULT_VALUE: ElementVisualEffect.VignetteShape.ELLIPSE,
			VISIBLE: _vignette_visibility,
			OPTIONS: ElementVisualEffect.VIGNETTE_SHAPES
		},
		ElementVisualEffect.SN_VIGNETTE_FALLOFF_FUNCTION: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			DEFAULT_VALUE: ElementVisualEffect.VignetteFalloffFunction.LINEAR,
			VISIBLE: _vignette_visibility,
			OPTIONS: ElementVisualEffect.VIGNETTE_FALLOFF_FUNCTIONS
		},
		ElementVisualEffect.SN_AUDIO_SOURCE: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			OPTIONS: AudioManager.get_streams().keys()
		},
		ElementVisualEffect.SN_BEGIN_FREQUENCY: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 20.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: 20.0,
			MAXIMUM: 60.0,
			STEP: 5.0,
			ROUNDED: true
		},
		ElementVisualEffect.SN_END_FREQUENCY: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 80.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: 60.0,
			MAXIMUM: 150.0,
			STEP: 5.0,
			ROUNDED: true
		},
		ElementVisualEffect.SN_MINIMUM_DECIBELS: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: -25.0,
			VISIBLE: _reaction_visibility,
			MINIMUM: -100.0,
			MAXIMUM: -10.0,
			STEP: 5.0,
			ROUNDED: true
		},
		ElementVisualEffect.SN_SMOOTHING_TYPE: {
			CONTROL_NODE: ControlNode.OPTION_BUTTON,
			DEFAULT_VALUE: ElementVisualEffect.ReactiveSmoothingType.DECAY,
			VISIBLE: _reaction_visibility,
			OPTIONS: ElementVisualEffect.SMOOTHING_TYPES
		},
		ElementVisualEffect.SN_SMOOTHING_AMOUNT: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.5,
			VISIBLE: _reaction_visibility,
			MINIMUM: 0.1,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_BLOOM_OPACITY_REACTION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _bloom_reaction_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_CHROMATIC_ABERRATION_AMOUNT_REACTION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _chromatic_aberration_reaction_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_GLITCH_BLOCK_OFFSET_AMOUNT_REACTION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _glitch_reaction_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_GLITCH_BLOCK_SPEED_REACTION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _glitch_reaction_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_GLITCH_LINE_OFFSET_AMOUNT_REACTION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _glitch_reaction_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_GLITCH_LINE_SPEED_REACTION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _glitch_reaction_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_LENS_DISTORTION_AMOUNT_REACTION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _lens_distortion_reaction_visibility,
			MINIMUM: -1.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_LENS_DISTORTION_ZOOM_FACTOR_REACTION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _lens_distortion_reaction_visibility,
			MINIMUM: -1.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_SCANLINES_SPEED_REACTION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _scanlines_reaction_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_SPIN_ZOOM_BLUR_AMOUNT_REACTION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _spin_zoom_blur_reaction_visibility,
			MINIMUM: 0.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		},
		ElementVisualEffect.SN_VIGNETTE_SIZE_REACTION: {
			CONTROL_NODE: ControlNode.NUMERICAL,
			DEFAULT_VALUE: 0.0,
			VISIBLE: _vignette_reaction_visibility,
			MINIMUM: -1.0,
			MAXIMUM: 1.0,
			STEP: 0.1,
			ROUNDED: false
		}
	}
	
	return ret
