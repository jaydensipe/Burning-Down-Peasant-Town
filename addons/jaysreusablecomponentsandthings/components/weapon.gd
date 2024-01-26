extends Node3D
class_name Weapon3D

var can_attack: bool = true
@export var weapon_name: String
@export var weapon_description: String

signal stopped_shooting
signal alternate_stopped_shooting

func _physics_process(delta: float) -> void:
	if (!can_attack): 
		stopped_shooting.emit()
		alternate_stopped_shooting.emit()
		return
	
	if (Input.is_action_just_pressed("shoot")):
		shoot()
	
	if (Input.is_action_just_pressed("alternate_fire")):
		alternate_fire()
		
	if (Input.is_action_just_released("shoot")):
		stopped_shooting.emit()
		
	if (Input.is_action_just_released("alternate_fire")):
		alternate_stopped_shooting.emit()


func shoot() -> void:
	pass
	
func alternate_fire() -> void:
	pass
