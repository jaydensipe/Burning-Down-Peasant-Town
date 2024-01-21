extends Enemy
class_name Peasant

@onready var state_chart: StateChart = $StateChart

var _current_burning_prop: BurnableProp = null

func _ready() -> void:
	super()
	
	health_component.death.connect(func():
		if (is_instance_valid(_current_burning_prop)):
			_current_burning_prop.being_serviced = false 
	)
	
func _on_looking_state_physics_processing(delta: float) -> void:
	if (get_tree().get_nodes_in_group("burning").is_empty()): return # TODO: Pick random point instead
	
	var closest_entity = _get_closest_burning_entity()
	if (closest_entity.is_equal_approx(Vector3.ZERO)): return
	
	navigation_agent_3d.target_position = closest_entity
	state_chart.send_event("look_to_pursue")
	
func _on_looking_state_entered() -> void:
	print("entering looking")
	NavigationServer3D.agent_set_avoidance_callback(navigation_agent_3d.get_rid(), func(): return null)

func _get_closest_burning_entity():
	var burning_entites := get_tree().get_nodes_in_group("burning")
	var closest_distance = 10000.0
	var closest_entity_pos = Vector3.ZERO
	
	for entity: BurnableProp in burning_entites:
		if (entity.being_serviced): continue
		
		var pos = global_position.distance_squared_to(entity.global_position)
		if (pos < closest_distance):
			_current_burning_prop = entity
			closest_entity_pos = entity.global_position
	
	return closest_entity_pos


func _on_pursuing_state_physics_processing(delta: float) -> void:
	if (!is_instance_valid(_current_burning_prop)): 
		state_chart.send_event("pursue_to_look")
		return
		
	if (_current_burning_prop.being_serviced):
		state_chart.send_event("pursue_to_look")
	
	if (character_movement_3d.character.is_on_floor()):
		character_movement_3d.move_to_direction(navigation_agent_3d.get_next_path_position() - global_position, delta)


func _on_navigation_agent_3d_target_reached() -> void:
	state_chart.send_event("pursue_to_watering")
	
func _on_watering_state_physics_processing(delta: float) -> void:
	if !(is_instance_valid(_current_burning_prop) or _current_burning_prop.burnable_component.burning): state_chart.send_event("watering_to_looking")
	
	_current_burning_prop.being_serviced = true
	_current_burning_prop.health_component.apply_health(1.0, _current_burning_prop.health_component.HEALTH_TYPES.HEALTH)
	


	
