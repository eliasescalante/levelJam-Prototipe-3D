extends CanvasLayer
class_name HUD

@onready var time_label: Label = $TimeLabel

func update_time(seconds: int) -> void:
	# Formatea el entero a 2 dígitos (ej: 09, 08... 00)
	time_label.text = "%02d" % seconds

func show_game_over() -> void:
	time_label.text = "00"
	# Podés agregar animaciones o mostrar menús adicionales aquí
