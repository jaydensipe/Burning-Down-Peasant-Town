extends Enemy
class_name Guard

@onready var state_chart: StateChart = $StateChart
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shape_cast_3d: ShapeCast3D = $rig/Skeleton3D/sword/sword/ShapeCast3D
@onready var guard: MeshInstance3D = $rig/Skeleton3D/guard
@onready var spawner_component_3d: SpawnerComponent3D = $SpawnerComponent3D

func _ready() -> void:
	super()
	
	spawner_component_3d.spawn_at_location(global_position)
	
func _on_pursue_state_physics_processing(delta: float) -> void:
	navigation_agent_3d.target_position = GlobalGameInformation.player_pos
	
	if (character_movement_3d.character.is_on_floor()):
		look_at(GlobalGameInformation.player_pos, Vector3.UP)
		rotation.x = 0
		rotation.z = 0
		
		character_movement_3d.move_to_direction(navigation_agent_3d.get_next_path_position() - global_position, delta)

func _on_navigation_agent_3d_target_reached() -> void:
	state_chart.send_event("pursue_to_swing")

func _on_swing_state_entered() -> void:
	animation_player.animation_finished.connect(func(_animation_name): 
		state_chart.send_event("swing_to_pursue"))

func _on_swing_state_physics_processing(delta: float) -> void:
	if (shape_cast_3d.is_colliding()):
		if !(shape_cast_3d.get_collider(0) is Player): return
		
		shape_cast_3d.get_collider(0).health_component.apply_health(50.0, health_component.HEALTH_TYPES.DAMAGE)
		
