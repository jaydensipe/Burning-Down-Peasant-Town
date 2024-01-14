extends Node3D
class_name WeaponManagerComponent

@export var starting_weapon: Weapon3D
var current_weapon = null

func _ready() -> void:
	if (is_instance_valid(starting_weapon)):
		current_weapon = starting_weapon

