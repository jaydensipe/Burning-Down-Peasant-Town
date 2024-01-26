extends Node
class_name SpawnManagerComponent

@export var spawning: bool = false
@export var scenes_to_spawn: Array[WeightedPackedScene] = []
@export var time_before_spawns: float = 1.0
@export var y_offset: float = 0.0
@onready var _random_spawn_markers: Array[Node] = get_children()
@onready var _weighted_spawn_index: Array[int] = []

func _ready() -> void:
	_init_random_weighted_spawns()
	
	while(spawning):
		await get_tree().create_timer(time_before_spawns).timeout
		
		var enemy = scenes_to_spawn[_weighted_spawn_index.pick_random()].scene.instantiate()
		var spawn_location: Marker3D = _random_spawn_markers.pick_random()
		enemy.position = Vector3(spawn_location.global_position.x, spawn_location.global_position.y + y_offset, spawn_location.global_position.z)
		
		get_parent().add_child(enemy)
		
	
func _init_random_weighted_spawns():
	var index: int = 0
	for scene: WeightedPackedScene in scenes_to_spawn:
		for num: int in range(scene.spawn_chance):
			_weighted_spawn_index.append(index)
		index += 1
