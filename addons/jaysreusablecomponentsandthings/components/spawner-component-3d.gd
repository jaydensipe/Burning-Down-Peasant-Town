extends Node3D
class_name SpawnerComponent

@export var scene: PackedScene
@export_group("Spawn Config")
@export var delete_timer: bool = false
@export_range(0, 60, 1, "suffix:s") var delete_time: float = 0.0
@export var spawn_delay_timer: bool = false
@export_range(0, 60, 1, "suffix:s") var spawn_delay_time: float = 0.0
var _can_spawn: bool = true

# Logic used from https://github.com/uheartbeast/Galaxy-Defiance. Thank you!
func spawn_at_location(global_spawn_position: Vector3 = global_position, parent: Node = get_tree().current_scene) -> Node:
	assert(scene is PackedScene, "Error: The scene export was never set on this spawner component.")
	if !(_can_spawn): return
	
	var instance = scene.instantiate()
	parent.add_child(instance)
	instance.global_position = global_spawn_position
	
	if (spawn_delay_timer):
		_can_spawn = false
		get_tree().create_timer(spawn_delay_time).timeout.connect(func(): _can_spawn = true)
	
	if (delete_timer):
		get_tree().create_timer(delete_time).timeout.connect(func(): instance.queue_free())
	
	return instance
