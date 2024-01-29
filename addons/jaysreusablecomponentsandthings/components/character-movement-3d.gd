extends Node3D
class_name CharacterMovement3D

@export var character: CharacterBody3D
@export var move_stats: MoveStats

var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _direction: Vector3 = Vector3.ZERO
var _input_dir: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not character.is_on_floor():
		character.velocity.y -= _gravity * delta
	
	if (move_stats.apply_acceleration):
		_direction = lerp(_direction, (character.transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized(), delta * move_stats.acceleration)		
	else:
		_direction = (character.transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized()
		
	if character.is_on_floor():
		if _direction:
			character.velocity.x = _direction.x * move_stats.speed
			character.velocity.z = _direction.z * move_stats.speed
		else:
			character.velocity.x = move_toward(character.velocity.x, 0, move_stats.speed)
			character.velocity.z = move_toward(character.velocity.z, 0, move_stats.speed)
	elif move_stats.apply_air_acceleration:
		character.velocity.x = lerp(character.velocity.x, _direction.x * move_stats.speed, delta * move_stats.air_acceleration)
		character.velocity.z = lerp(character.velocity.z, _direction.z * move_stats.speed, delta * move_stats.air_acceleration)
		
	character.move_and_slide()
	

		
func apply_player_input_direction(input_direction: Vector2):
	_input_dir = input_direction
	
func jump():
	if character.is_on_floor():
		character.velocity.y = move_stats.jump_height
	
func move_to_direction(direction: Vector3, delta: float):
	direction = direction.normalized()
	
	character.velocity = character.velocity.lerp(direction * move_stats.speed, move_stats.acceleration * delta)
	character.move_and_slide()
