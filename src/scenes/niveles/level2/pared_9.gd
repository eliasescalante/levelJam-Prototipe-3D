extends MeshInstance3D


@export var transparencia : float = 0.3
@export var fade_speed: float = 8.0

var target: float = 1.0
var material: StandardMaterial3D

func _ready() -> void:
	var base_mat = get_surface_override_material(0)
	if not base_mat:
		base_mat = material_override
	
	if base_mat:
		material = base_mat.duplicate() as StandardMaterial3D
		material_override = material
		set_surface_override_material(0, material)
	
	var area = $Area3D
	print(area)
	if area:
		area.body_entered.connect(_on_area_3d_body_entered)
		area.body_entered.connect(_on_area_3d_body_exited)

func _process(delta: float) -> void:
	if material:
		material.albedo_color.a = move_toward(material.albedo_color.a, target, fade_speed * delta)
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugador"):
		print("entro el jugador")
		target = transparencia

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("jugador"):
		pass
		#print("el jugador salio")
		#target = 1.0
