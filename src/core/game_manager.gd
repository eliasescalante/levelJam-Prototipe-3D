extends Node
# Sin class_name para evitar el conflicto de Autoload

signal time_updated(seconds_left: int)
signal time_out

@export var max_time: float = 30.0

var timer: Timer
var current_seconds: int = -1
var has_reached_goal: bool = false

func _ready() -> void:
	pass
