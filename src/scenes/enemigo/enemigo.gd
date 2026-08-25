extends Area3D

@onready var rango_vision: Area3D = $RangoVision

func _physics_process(_delta: float) -> void:
	# 1. Comprobación de colisión física directa con este Area3D
	for body in get_overlapping_bodies():
		if _debe_matar_a(body):
			matar_jugador()
			return

	# 2. Comprobación dentro del rango/cono de visión
	if rango_vision:
		for body in rango_vision.get_overlapping_bodies():
			if _debe_matar_a(body):
				matar_jugador()
				return

func _debe_matar_a(body: Node) -> bool:
	if not body:
		return false
		
	# Buscamos el nodo raíz del jugador si colisiona una sub-forma
	var jugador: Node = body
	if not jugador.is_in_group("jugador"):
		if body.get_parent() and body.get_parent().is_in_group("jugador"):
			jugador = body.get_parent()
		else:
			return false
		
	# Si el jugador es invisible, ignoramos la colisión
	if "es_invisible" in jugador and jugador.es_invisible:
		return false
		
	return true

func matar_jugador() -> void:
	print("¡Jugador detectado por enemigo estático! Reiniciando...")
	get_tree().reload_current_scene()
