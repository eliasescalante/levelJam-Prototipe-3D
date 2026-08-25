extends Camera3D

@export var target: Node3D
@export var distance := 10.0
@export var smoothness := 5.0

# Ángulo acumulado en Y (0, 90, 180, 270...)
var target_rotation_y := 0.0

func _ready() -> void:
	rotation_degrees.x = -45.0

func _unhandled_input(event: InputEvent) -> void:
	# Podés cambiar "ui_focus_next" por una acción personalizada en el Input Map (ej: "rotate_camera")
	if event.is_action_pressed("ui_focus_next"):
		target_rotation_y += 90.0
		if target_rotation_y >= 360.0:
			target_rotation_y -= 360.0

func _physics_process(delta: float) -> void:
	if not target:
		return

	# Transición suave de rotación en Y
	var current_rad := rotation.y
	var target_rad := deg_to_rad(target_rotation_y)
	rotation.y = lerp_angle(current_rad, target_rad, smoothness * delta)

	# Posicionar la cámara orbitando al jugador
	var rot_basis := Basis(Vector3.UP, rotation.y)
	var offset := rot_basis * Vector3(0, distance, distance)
	var target_position := target.global_position + offset

	global_position = global_position.lerp(target_position, smoothness * delta)
