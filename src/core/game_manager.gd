extends Node
# Sin class_name para evitar el conflicto de Autoload

signal time_updated(seconds_left: int)
signal time_out

@export var max_time: float = 30.0

var timer: Timer
var current_seconds: int = -1
var has_reached_goal: bool = false

func _ready() -> void:
	# Creamos e instanciamos el Timer dinámicamente
	timer = Timer.new()
	add_child(timer)
	
	timer.wait_time = max_time
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	
	start_timer()

func start_timer() -> void:
	has_reached_goal = false
	current_seconds = -1
	timer.start(max_time)
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
	
	# Si se agota el tiempo y no llegó a la meta, reinicia el nivel
	if not has_reached_goal:
		restart_level()

func restart_level() -> void:
	get_tree().reload_current_scene()
	start_timer()

# Llama a esta función cuando el jugador toque la meta
func reach_goal() -> void:
	has_reached_goal = true
	timer.stop()
