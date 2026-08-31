extends Node

var _window_size: Vector2i
var _subviewport_size: Vector2i

func _ready() -> void:
	_window_size = DisplayServer.window_get_size()

func _process(_delta: float) -> void:
	_window_size = DisplayServer.window_get_size()

func get_window_size() -> Vector2i:
	return _window_size

func set_subviewport_size(p_size: Vector2i) -> void:
	_subviewport_size = p_size

func get_subviewport_size() -> Vector2i:
	return _subviewport_size
