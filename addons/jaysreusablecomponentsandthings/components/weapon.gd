extends Node3D
class_name Weapon3D

@export var weapon_name: String
@export var weapon_description: String

signal stopped_shooting

func _physics_process(delta: float) -> void:
	if (Input.is_action_pressed("shoot")):
		shoot()
		
	if (Input.is_action_just_released("shoot")):
		stopped_shooting.emit()

func shoot() -> void:
	pass
