extends Area3D

@export var duracion_invisibilidad := 5.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.has_method("hacer_invisible"):
		body.hacer_invisible(duracion_invisibilidad)
		queue_free()
