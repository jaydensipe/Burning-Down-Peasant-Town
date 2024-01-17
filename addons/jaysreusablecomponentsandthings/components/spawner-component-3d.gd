extends Node3D
class_name SpawnerComponent

@export var scene: PackedScene
@export_group("Spawn Config")
@export var spawn_delay_timer: bool = false
@export_range(0, 60, 0.1, "suffix:s") var spawn_delay_time: float = 0.0
@export var delete_timer: bool = false
@export_range(0, 60, 0.1, "suffix:s") var delete_time: float = 0.0
var _can_spawn: bool = true

@export_subgroup("Randomization")
@export var randomize_x: bool = false
@export var randomize_y: bool = false
@export var randomize_z: bool = false

# Logic used from https://github.com/uheartbeast/Galaxy-Defiance. Thank you!
func spawn_at_location(global_spawn_position: Vector3 = global_position, parent: Node = get_tree().current_scene) -> Node:
	assert(scene is PackedScene, "Error: The scene export was never set on this spawner component.")
	if !(_can_spawn): return
	
	var instance = scene.instantiate()
	parent.add_child(instance)
	if (randomize_x):
		instance.global_rotation_degrees = Vector3(randf_range(0, 360), 0.0, 0.0)
	if (randomize_y):
		instance.global_rotation_degrees = Vector3(0.0, randf_range(0, 360), 0.0)
	if (randomize_z):
		instance.global_rotation_degrees = Vector3(0.0, 0.0, randf_range(0, 360))
	
	instance.global_position = global_spawn_position
	
	if (spawn_delay_timer):
		_can_spawn = false
		get_tree().create_timer(spawn_delay_time).timeout.connect(func(): _can_spawn = true)
	
	if (delete_timer):
		get_tree().create_timer(delete_time).timeout.connect(func(): instance.queue_free())
	
	return instance
	
func spawn_at_location_with_transform(global_spawn_transform: Transform3D = global_transform, parent: Node = get_tree().current_scene):
	assert(scene is PackedScene, "Error: The scene export was never set on this spawner component.")
	if !(_can_spawn): return
	
	var instance = scene.instantiate()
	parent.add_child(instance)
	if (randomize_x):
		instance.global_rotation_degrees = Vector3(randf_range(0, 360), 0.0, 0.0)
	if (randomize_y):
		instance.global_rotation_degrees = Vector3(0.0, randf_range(0, 360), 0.0)
	if (randomize_z):
		instance.global_rotation_degrees = Vector3(0.0, 0.0, randf_range(0, 360))
	
	instance.global_transform = global_spawn_transform
	
	if (spawn_delay_timer):
		_can_spawn = false
		get_tree().create_timer(spawn_delay_time).timeout.connect(func(): _can_spawn = true)
	
	if (delete_timer):
		get_tree().create_timer(delete_time).timeout.connect(func(): instance.queue_free())
	
	return instance
