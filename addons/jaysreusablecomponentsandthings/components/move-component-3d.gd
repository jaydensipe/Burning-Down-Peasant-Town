extends Node
class_name MoveComponent3D

@export var actor: Node3D
@export var velocity: Vector3

func _physics_process(delta: float) -> void:
	actor.global_translate(velocity * delta)
