@tool
extends Node
class_name LevelManager

enum DELETE_TYPE {
	QUEUE_FREE,
	REMOVE_CHILD,
	NONE
}
@export var current_level_index: int = 0
@export var levels: Array[Level] = []

signal level_loaded
	
func load_level_by_index(index: int, delete_type: DELETE_TYPE = DELETE_TYPE.NONE) -> void:
	_load_level(delete_type, index, true)
	
func load_next_level(delete_type: DELETE_TYPE = DELETE_TYPE.QUEUE_FREE) -> void:
	_load_level(delete_type)
	
func _load_level(delete_type: DELETE_TYPE, index: int = current_level_index, by_index: bool = false) -> void:
	match delete_type:
		DELETE_TYPE.QUEUE_FREE:
			get_child(0).queue_free()
		DELETE_TYPE.REMOVE_CHILD:
			remove_child(get_child(0))
		DELETE_TYPE.NONE:
			pass
		_:
			printerr("Type not specified for LevelManagerComponent.")
	
	if (by_index):
		current_level_index = index
		
	var level: PackedScene = levels[index].level if by_index else levels[current_level_index + 1].level
	SceneLoaderManager.load_packed_scene(level)
	
	var scene: PackedScene = await SceneLoaderManager.load_packed_scene(level)
	add_child(scene.instantiate())
	print("ye")
	
	level_loaded.emit()
