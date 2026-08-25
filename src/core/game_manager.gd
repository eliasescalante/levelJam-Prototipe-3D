extends Node
# Sin class_name para evitar el conflicto de Autoload

signal time_updated(seconds_left: int)
signal time_out

@export var max_time: float = 30.0

var timer: Timer
var current_seconds: int = -1

func _ready() -> void:
	# Creamos e instanciamos el Timer dinámicamente
	timer = Timer.new()
	add_child(timer)
	
	timer.wait_time = max_time
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	
	start_timer()

func start_timer() -> void:
	timer.start()
	_update_time_signal()

func _process(_delta: float) -> void:
	if timer and not timer.is_stopped():
		_update_time_signal()

func _update_time_signal() -> void:
	var seconds: int = int(ceilf(timer.time_left))
	if seconds != current_seconds:
		current_seconds = seconds
		time_updated.emit(current_seconds)

func _on_timer_timeout() -> void:
	current_seconds = 0
	time_updated.emit(0)
	time_out.emit()
