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

extends WorldEnvironment

# This script handles bloom.

#region BLOOM VARIABLES ##################################

const MAX_STRENGTH_IN_UI: float = 10.0
const DEFAULT_INTENSITY: float = 0.8

var glow_bloom_level: float

#endregion ##################################

func _ready() -> void:
	MainUtils.update_visualizer.connect(update_bloom)
	update_bloom()

func _process(_delta: float) -> void:
	if MainUtils.audio_playing:
		bloom_reaction(MainUtils.cur_mag, GlobalVariables.bloom_amount_reaction_strength * 0.5)
	else:
		environment.set_glow_bloom(glow_bloom_level)
		environment.set_glow_intensity(DEFAULT_INTENSITY)

func update_bloom() -> void:
	if GlobalVariables.bloom_amount or GlobalVariables.bloom_amount_reaction_strength:
		environment.set_glow_enabled(true)
		if GlobalVariables.bloom_amount_reaction_strength:
			set_process(true)
	else:
		environment.set_glow_enabled(false)
		set_process(false)
	
	if environment.is_glow_enabled():
		glow_bloom_level = GlobalVariables.bloom_amount / MAX_STRENGTH_IN_UI * DEFAULT_INTENSITY
		environment.set_glow_bloom(glow_bloom_level)
		environment.set_glow_intensity(DEFAULT_INTENSITY)
		environment.set_glow_blend_mode(GlobalVariables.bloom_blend_mode as Environment.GlowBlendMode)

func bloom_reaction(mag: float, strength: float) -> void:
	mag = clampf(mag, 0.0, 1.0)
	
	environment.set_glow_intensity(DEFAULT_INTENSITY)
	
	# `glow_bloom` has to be > 0 for reaction at 0 `bloom_amount` to work.
	# Here, a very small value is being set to it for reaction to work.
	if GlobalVariables.bloom_amount == 0.0:
		environment.set_glow_bloom(mag / 1.0 * DEFAULT_INTENSITY * 0.05)
	else:
		environment.set_glow_bloom(glow_bloom_level)
	
	environment.glow_intensity += mag * strength
