extends CharacterBody3D

@onready var character_movement_3d: CharacterMovement3D = $CharacterMovement3D
@onready var fps_camera_component_3d: FPSCameraComponent3D = $FPSCameraComponent3D

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		character_movement_3d.jump()
		
	character_movement_3d.apply_player_input_direction(Input.get_vector("move_left", "move_right", "move_forward", "move_backward"))
