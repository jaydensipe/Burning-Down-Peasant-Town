extends CharacterBody3D

@onready var character_movement_3d: CharacterMovement3D = $CharacterMovement3D
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

func _physics_process(delta: float) -> void:
	navigation_agent_3d.target_position = GameManager.marker.global_position
	
	await get_tree().process_frame
	character_movement_3d.move_to_direction(navigation_agent_3d.get_next_path_position() - global_position, delta)
	
