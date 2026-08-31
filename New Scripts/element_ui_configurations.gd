# Oscillody
# Copyright (C) 2025-present Akosmo

# element_ui_configurations.gd is part of Oscillody.
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
class_name ElementUIConfigurations
extends Resource
## Abstract Resource for [ElementProperty].
##
## This class holds necessary data to set up [ElementProperty]. It contains every property an [Element] type
## can have, and helpful data to set up [Control] nodes used to control the value of those properties.

## The possible [Control] nodes that can be used to control property values.
enum ControlNode {
	## Uses [Button].
	BUTTON,
	## Uses [CheckButton].
	CHECK_BUTTON,
	## Uses [ColorPicketButton].
	COLOR_PICKER_BUTTON,
	## Uses [LineEdit].
	LINE_EDIT,
	## Uses [SpinBox], or [CustomHSlider] if
	## [method SettingsManager.are_sliders_enabled] is [code]true[/code].
	NUMERICAL,
	## Uses [OptionButton].
	OPTION_BUTTON,
	## Uses [TextEdit].
	TEXT_EDIT
}

## The dictionary key for [ControlNode].
const CONTROL_NODE: StringName = &"control_node"
## The dictionary key for the property's default value, used when reseting.
const DEFAULT_VALUE: StringName = &"default_value"

## The dictionary key for the minimum value in a [constant ControlNode.NUMERICAL] [Control] node.
const MINIMUM: StringName = &"minimum"
## The dictionary key for the maximum value in a [constant ControlNode.NUMERICAL] [Control] node.
const MAXIMUM: StringName = &"maximum"
## The dictionary key for the step value in a [constant ControlNode.NUMERICAL] [Control] node.
const STEP: StringName = &"step"
## The dictionary key for the rounded value in a [constant ControlNode.NUMERICAL] [Control] node.
const ROUNDED: StringName = &"rounded"

## The dictionary key for the available options for [constant ControlNode.OPTION_BUTTON] node.
const OPTIONS: StringName = &"options"

#var _property_configurations: Dictionary[StringName, Dictionary]:
	#get = get_property_configurations

## Returns an updated list of all the property configurations.
@abstract func get_property_configurations() -> Dictionary[StringName, Dictionary]
