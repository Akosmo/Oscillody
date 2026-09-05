# Oscillody
# Copyright (C) 2025-present Akosmo

# element_shake_utilities.gd is part of Oscillody.
# Unless specified otherwise, it is under the license below:

# Oscillody is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or any later version.

# Oscillody is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with Oscillody.
# If not, see <https://www.gnu.org/licenses/>.

class_name ElementShakeUtilities
extends RefCounted

var _noise: FastNoiseLite = FastNoiseLite.new()
var _seed: int = 0
var _noise_scroll: float

func _init() -> void:
	_noise.set_noise_type(FastNoiseLite.TYPE_SIMPLEX_SMOOTH)
	_noise.set_fractal_type(FastNoiseLite.FRACTAL_NONE)
	_noise.set_frequency(0.0005)

func reset_noise_scroll() -> void:
	_noise_scroll = 0.0

func get_noise_vector() -> Vector2:
	return Vector2(_noise.get_noise_2d(_noise_scroll, 0.0), _noise.get_noise_2d(0.0, _noise_scroll))

func set_seed(p_seed: int) -> void:
	_seed = p_seed
	_noise.set_seed(p_seed)

func increment_noise_scroll(p_multiplier: float) -> void:
	_noise_scroll += p_multiplier
