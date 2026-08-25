extends CharacterBody3D

@export var SPEED := 6.0
@export var JUMP_VELOCITY := 4.5
@export_flags_3d_physics var capa_dano_enemigos: int = 1 

@onready var camera_3d: Camera3D = get_viewport().get_camera_3d()
@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D

var es_invisible := false
var timer_invisibilidad: Timer

var ultima_direccion_y := 1.0 

func _ready() -> void:
	if animated_sprite_3d:
		animated_sprite_3d.modulate.a = 1.0
	
	timer_invisibilidad = Timer.new()
	timer_invisibilidad.wait_time = 5.0
	timer_invisibilidad.one_shot = false
	timer_invisibilidad.autostart = true
	timer_invisibilidad.timeout.connect(_alternar_invisibilidad)
	add_child(timer_invisibilidad)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_dir != Vector2.ZERO and camera_3d:
		var cam_basis := camera_3d.global_transform.basis
		var forward := -cam_basis.z
		forward.y = 0
		forward = forward.normalized()
		
		var right := cam_basis.x
		right.y = 0
		right = right.normalized()

		var direction := (right * input_dir.x - forward * input_dir.y).normalized()

		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		var target_angle := atan2(direction.x, direction.z)
		rotation.y = lerp_angle(rotation.y, target_angle, 0.15)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	_actualizar_animacion(input_dir)
	move_and_slide()

func _actualizar_animacion(input_dir: Vector2) -> void:
	if not animated_sprite_3d:
		return

	if input_dir == Vector2.ZERO:
		if animated_sprite_3d.sprite_frames.has_animation("idle"):
			animated_sprite_3d.play("idle")
		else:
			animated_sprite_3d.stop()
		return

	if input_dir.y != 0:
		ultima_direccion_y = input_dir.y

	if ultima_direccion_y < 0:
		if animated_sprite_3d.sprite_frames.has_animation("walk_back"):
			animated_sprite_3d.play("walk_back")
		elif animated_sprite_3d.sprite_frames.has_animation("back"):
			animated_sprite_3d.play("back")
	else:
		if animated_sprite_3d.sprite_frames.has_animation("walk_front"):
			animated_sprite_3d.play("walk_front")
		elif animated_sprite_3d.sprite_frames.has_animation("front"):
			animated_sprite_3d.play("front")

	if input_dir.x != 0:
		animated_sprite_3d.flip_h = (input_dir.x < 0)

func _alternar_invisibilidad() -> void:
	es_invisible = !es_invisible

	if es_invisible:
		if animated_sprite_3d:
			animated_sprite_3d.modulate.a = 0.1
		
		set_collision_layer_value(capa_dano_enemigos, false)
	else:
		if animated_sprite_3d:
			animated_sprite_3d.modulate.a = 1.0
		set_collision_layer_value(capa_dano_enemigos, true)
