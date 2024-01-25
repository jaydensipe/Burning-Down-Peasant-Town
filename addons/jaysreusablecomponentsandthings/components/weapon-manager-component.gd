extends Node3D
class_name WeaponContainerComponent3D

var current_weapon: Weapon3D = null
@export var wielder: Node3D
@export var starting_weapon: Weapon3D

func _ready() -> void:
	if (is_instance_valid(starting_weapon)):
		current_weapon = starting_weapon

