extends Node
class_name SpawnManagerComponent

@export var scenes_to_spawn: Array[PackedScene] = []
@export var time_before_spawns: float = 1.0
@export var y_offset: float = 0.0
@onready var spawns: Array[Node] = get_children()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while(true):
		await get_tree().create_timer(time_before_spawns).timeout
		
		var eneny = scenes_to_spawn[0].instantiate() as CharacterBody3D
		get_parent().add_child(eneny)
		eneny.global_position = Vector3((spawns.pick_random() as Marker3D).global_position.x, (spawns.pick_random() as Marker3D).global_position.y + y_offset, (spawns.pick_random() as Marker3D).global_position.z)
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
