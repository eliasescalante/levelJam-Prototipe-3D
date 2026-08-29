extends Node3D

@onready var hud: HUD = $Hud

func _ready() -> void:
	# Conectamos las señales del GameManager al HUD
	#GameManager.time_updated.connect(hud.update_time)
	#GameManager.time_out.connect(_on_game_over)
	pass

func _on_game_over() -> void:
	hud.show_game_over()
	# Lógica adicional: pausar el juego, deshabilitar al personaje, etc.
