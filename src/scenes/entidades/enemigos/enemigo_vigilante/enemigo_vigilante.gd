extends Area3D

@export var velocidad_rotacion: float = 1.0
@export var angulo_maximo_grados: float = 45.0

@onready var rango_vision: Area3D = $RangoVision
@onready var ray_cast: RayCast3D = $RayCast3D

var _tiempo: float = 0.0
var _rotacion_inicial_y: float = 0.0

func _ready() -> void:
	_rotacion_inicial_y = rotation.y
	
	if ray_cast:
		ray_cast.add_exception(self)

func _physics_process(delta: float) -> void:
	_tiempo += delta * velocidad_rotacion
	rotation.y = _rotacion_inicial_y + deg_to_rad(angulo_maximo_grados) * sin(_tiempo)

	for body in get_overlapping_bodies():
		if _puede_ver_a(body):
			matar_jugador()
			return

	if rango_vision:
		for body in rango_vision.get_overlapping_bodies():
			if _puede_ver_a(body):
				matar_jugador()
				return

func _obtener_jugador(body: Node) -> Node:
	if not body:
		return null
	if body.is_in_group("jugador"):
		return body
	if body.get_parent() and body.get_parent().is_in_group("jugador"):
		return body.get_parent()
	return null

func _puede_ver_a(body: Node) -> bool:
	var jugador = _obtener_jugador(body)
	if not jugador:
		return false
		
	if "es_invisible" in jugador and jugador.es_invisible:
		return false

	if ray_cast:
		ray_cast.global_position = global_position
		ray_cast.target_position = ray_cast.to_local(jugador.global_position)
		ray_cast.force_raycast_update()
		
		if ray_cast.is_colliding():
			var objeto_colisionado = ray_cast.get_collider()
			var jugador_detectado = _obtener_jugador(objeto_colisionado)
			
			if jugador_detectado != jugador:
				return false

	return true

func matar_jugador() -> void:
	print("¡Jugador detectado por el vigilante! Reiniciando...")
	get_tree().reload_current_scene()
