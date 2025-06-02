# Oscillody
# Copyright (C) 2025 Akosmo

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

#endregion ##################################

func _ready() -> void:
	MainUtils.update_visualizer.connect(update_bloom)
	update_bloom()

func _process(_delta: float) -> void:
	if GlobalVariables.bloom_amount_reaction_strength and GlobalVariables.bloom_amount:
		bloom_reaction(MainUtils.cur_mag, GlobalVariables.bloom_amount_reaction_strength * 0.5)

func update_bloom() -> void:
	if GlobalVariables.bloom_amount:
		set_process(true)
	else:
		set_process(false)
	environment.set_glow_enabled(GlobalVariables.bloom_amount)
	environment.set_glow_bloom(GlobalVariables.bloom_amount / MAX_STRENGTH_IN_UI * DEFAULT_INTENSITY)
	environment.set_glow_intensity(DEFAULT_INTENSITY)

func bloom_reaction(mag: float, strength: float) -> void:
	environment.set_glow_intensity(DEFAULT_INTENSITY)
	
	environment.glow_intensity += mag * strength
	
	if not MainUtils.audio_playing:
		environment.set_glow_intensity(DEFAULT_INTENSITY)
