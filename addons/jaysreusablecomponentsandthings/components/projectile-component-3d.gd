extends Node3D
class_name ProjectileComponent3D

@export var actor: Node3D
@export var speed: float = 5.0

func _physics_process(delta: float) -> void:
	actor.global_translate(-actor.global_transform.basis.z * speed * delta)
