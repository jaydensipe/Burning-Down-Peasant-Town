extends Enemy
class_name Peasant

var _current_burning_objective: BurnableObjective = null
@onready var state_chart: StateChart = $StateChart
@onready var bucket: MeshInstance3D = $rig/Skeleton3D/Bucket/Bucket
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var spawner_component_3d: SpawnerComponent3D = $SpawnerComponent3D
@onready var death_audio_stream_player_3d: AudioStreamPlayer3D = $DeathAudioStreamPlayer3D
@onready var gossip_audio_stream_player_3d: AudioStreamPlayer3D = $GossipAudioStreamPlayer3D
@onready var hurt_audio_stream_player_3d: AudioStreamPlayer3D = $HurtAudioStreamPlayer3D

func _ready() -> void:
	super()
	
	health_component.health_changed.connect(func(health: float):
		if !(hurt_audio_stream_player_3d.playing):
			hurt_audio_stream_player_3d.play()
	)
	
	burnable_component.finished_burn.connect(func():
		AudioManager.play_audio_at_position_3d(death_audio_stream_player_3d, global_position)
	)
	
	burnable_component.finished_burn.connect(func():
		if (is_instance_valid(_current_burning_objective)):
				_current_burning_objective.being_serviced = false
	)
	
	spawner_component_3d.spawn_at_location(global_position)
	gossip_audio_stream_player_3d.play()
	
func _on_look_state_physics_processing(delta: float) -> void:
	if !(is_on_floor()):
		state_chart.send_event("look_to_fall")
		return
		
	var burning_objectives: Array[Node] = get_tree().get_nodes_in_group("burning")
	if (burning_objectives.is_empty()): return
	
	var closest_distance: float = 10000.0
	for objective: BurnableObjective in burning_objectives:
		if (objective.being_serviced): continue
		if !(objective.burnable_component.burning): continue
		
		var pos: float = global_position.distance_squared_to(objective.global_position)
		if (pos < closest_distance):
			closest_distance = pos
			_current_burning_objective = objective
	
	if !(is_instance_valid(_current_burning_objective)): return
	
	navigation_agent_3d.target_position = _current_burning_objective.global_position
	state_chart.send_event("look_to_pursue")
	
func _on_walk_random_state_entered() -> void:
	navigation_agent_3d.target_position = Vector3(randf_range(global_position.x - 5.0, global_position.x + 5.0), 0.0, randf_range(global_position.z - 5.0, global_position.z + 5.0))
	
func _on_walk_random_state_physics_processing(delta: float) -> void:
		if (navigation_agent_3d.is_target_reached()):
			navigation_agent_3d.target_position = Vector3(randf_range(global_position.x - 5.0, global_position.x + 5.0), 0.0, randf_range(global_position.z - 5.0, global_position.z + 5.0))
		
		look_at(navigation_agent_3d.target_position)
		rotation.x = 0
		rotation.z = 0
	
		character_movement_3d.move_to_direction(navigation_agent_3d.get_next_path_position() - global_position, delta)

func _on_pursue_state_entered() -> void:
	navigation_agent_3d.target_reached.connect(_goto_watering_from_pursue)
	gossip_audio_stream_player_3d.play()

func _on_pursue_state_exited() -> void:
	navigation_agent_3d.target_reached.disconnect(_goto_watering_from_pursue)
	
func _goto_watering_from_pursue() -> void:
	state_chart.send_event("pursue_to_watering")

func _on_pursue_state_physics_processing(delta: float) -> void:
	if (!is_instance_valid(_current_burning_objective) or _current_burning_objective.being_serviced): 
		state_chart.send_event("pursue_to_look")
		return
		
	if !(is_on_floor()):
		state_chart.send_event("pursue_to_fall")
		return
		
	look_at(_current_burning_objective.global_position)
	rotation.x = 0
	rotation.z = 0
	
	character_movement_3d.move_to_direction(navigation_agent_3d.get_next_path_position() - global_position, delta)

func _on_fall_state_physics_processing(delta: float) -> void:
	if (is_on_floor()):
		state_chart.send_event("fall_to_look")
		return

func _on_fall_state_entered() -> void:
	bucket.hide()
	
func _on_fall_state_exited() -> void:
	bucket.show()
	
func _on_watering_state_physics_processing(delta: float) -> void:
	if !(is_instance_valid(_current_burning_objective) and _current_burning_objective.burnable_component.burning): 
		state_chart.send_event("watering_to_look")
		return
		
	if !(is_on_floor()):
		state_chart.send_event("watering_to_fall")
		return
	
	_current_burning_objective.being_serviced = true
	
func _on_watering_state_entered() -> void:
	if (is_instance_valid(_current_burning_objective)):
			_current_burning_objective.being_serviced = true
	
	animation_player.animation_finished.connect(func(_animation_name): 
		_current_burning_objective.health_component.apply_health(200.0, _current_burning_objective.health_component.HEALTH_TYPES.HEALTH)	
	)


func _on_watering_state_exited() -> void:
	if (is_instance_valid(_current_burning_objective)):
			_current_burning_objective.being_serviced = false








