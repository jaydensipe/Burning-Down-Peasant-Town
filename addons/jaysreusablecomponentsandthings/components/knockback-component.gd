extends Area3D
class_name KnockbackComponent3D

@export var normalize_velocity: bool = true
@export var speed: float = 10.0
@export var x_scale: float = 0.0
@export var y_scale: float = 0.0
@export var z_scale: float = 0.0
@export var override_x: float = 0.0
@export var override_y: float = 0.0
@export var override_z: float = 0.0

func knockback(character: CharacterBody3D):
	var vector: Vector3 = character.global_transform.origin - global_transform.origin
	var direction:= vector.normalized()
	var distance_squared:= vector.length_squared()
	var velocity:= direction * speed/distance_squared
	
	var _x: float = 0.0
	var _y: float = 0.0
	var _z: float = 0.0
	if (override_x != 0.0):
		_x = override_x
	elif (normalize_velocity):
		_x = velocity.normalized().x * x_scale
		
	if (override_y != 0.0):
		_y = override_y
	elif (normalize_velocity):
		_y = velocity.normalized().y * y_scale
		
	if (override_z != 0.0):
		_z = override_z
	elif (normalize_velocity):
		_z = velocity.normalized().z * z_scale

	character.velocity += Vector3(_x, _y, _z)
