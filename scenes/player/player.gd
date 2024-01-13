extends CharacterBody3D

@export var move_stats: MoveStats
@onready var camera_3d: FPSCameraComponent3D = $Camera3D

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var direction: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = move_stats.jump_height
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * move_stats.acceleration)
	if is_on_floor():
		if direction:
			velocity.x = direction.x * move_stats.speed
			velocity.z = direction.z * move_stats.speed
		else:
			velocity.x = move_toward(velocity.x, delta, move_stats.speed)
			velocity.z = move_toward(velocity.z, delta, move_stats.speed)
	else:
		velocity.x = lerp(velocity.x, direction.x * move_stats.speed, delta * move_stats.air_acceleration)
		velocity.z = lerp(velocity.z, direction.z * move_stats.speed, delta * move_stats.air_acceleration)

	animate_camera()
	move_and_slide()
	
func animate_camera() -> void:
	if (Input.is_action_pressed("move_right")):
		camera_3d.rotate_camera_right()
	elif Input.is_action_pressed("move_left"):
		camera_3d.rotate_camera_left()
	else:
		camera_3d.reset_rotation()
