extends CharacterBody3D

@export var SPEED := 2.0
@export var rango_vision_distancia := 6.0
@export var angulo_vision_grados := 45.0

@onready var rango_vision: Area3D = $RangoVision
@onready var cono_visor: CSGMesh3D = $ConoVisor

var direcciones_posibles := [Vector3.FORWARD, Vector3.BACK, Vector3.LEFT, Vector3.RIGHT]
var direccion_actual := Vector3.ZERO

func _ready() -> void:
	elegir_nueva_direccion()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity.x = direccion_actual.x * SPEED
	velocity.z = direccion_actual.z * SPEED

	# Rotación del cuerpo principal (el ConoVisor al ser hijo rota automáticamente a la par)
	if direccion_actual != Vector3.ZERO:
		var target_angle := atan2(direccion_actual.x, direccion_actual.z) + PI
		rotation.y = lerp_angle(rotation.y, target_angle, 0.15)

	move_and_slide()

	if is_on_wall():
		elegir_nueva_direccion()

	# Detección física directa
	for i in get_slide_collision_count():
		var col := get_slide_collision(i)
		var collider := col.get_collider() as Node
		if collider and _debe_matar_a(collider):
			matar_jugador()
			return

	_evaluar_deteccion_cono()

func elegir_nueva_direccion() -> void:
	var opciones := direcciones_posibles.duplicate()
	opciones.erase(direccion_actual)
	direccion_actual = opciones.pick_random()

func _evaluar_deteccion_cono() -> void:
	if not rango_vision:
		return

	for body in rango_vision.get_overlapping_bodies():
		if not _debe_matar_a(body):
			continue

		var dir_hacia_jugador := (body.global_position - global_position).normalized()
		dir_hacia_jugador.y = 0

		# Vector frontal del enemigo (-Z)
		var vector_frente := -global_transform.basis.z
		vector_frente.y = 0

		var angulo := rad_to_deg(vector_frente.angle_to(dir_hacia_jugador))

		if angulo <= angulo_vision_grados:
			matar_jugador()
			return

func _debe_matar_a(body: Node) -> bool:
	if not body:
		return false
		
	# Si lo que colisionó es una forma dentro del jugador, buscamos el cuerpo principal
	var jugador: Node = body
	if not jugador.is_in_group("jugador"):
		# Intentamos buscar si el padre pertenece al grupo jugador
		if body.get_parent() and body.get_parent().is_in_group("jugador"):
			jugador = body.get_parent()
		else:
			return false
		
	# Comprobamos la invisibilidad en el jugador
	if "es_invisible" in jugador and jugador.es_invisible:
		return false
		
	return true

func matar_jugador() -> void:
	print("¡Jugador en el cono de visión! Reiniciando...")
	get_tree().reload_current_scene()
