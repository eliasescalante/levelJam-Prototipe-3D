extends Area3D

@export var escena_victoria: PackedScene



func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugador"):
		if escena_victoria:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().change_scene_to_packed(escena_victoria)
		else:
			print("Falta asignar la escena de victoria en el Inspector.")
