extends CharacterBody3D

@onready var ani : AnimatedSprite3D = $AnimatedSprite3D

func _ready() -> void:
	ani.play("idle")
