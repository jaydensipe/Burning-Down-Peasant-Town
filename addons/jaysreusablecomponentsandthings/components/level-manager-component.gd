@tool
extends Node
class_name LevelManager

enum DELETE_TYPE {
	QUEUE_FREE,
	REMOVE_CHILD,
}
@export var current_level_index: int = 0
@export var levels: Array[Level] = []

signal level_loaded

func _ready() -> void:
	var level_path: String = levels[current_level_index].level.resource_path
	ResourceLoader.load_threaded_request(level_path)
	
	var level = ResourceLoader.load_threaded_get(level_path)
	add_child(level.instantiate())
	
	level_loaded.emit()
	
func load_level_by_index(index: int, delete_type: DELETE_TYPE) -> void:
	_load_level(index, delete_type)
	
func load_next_level(delete_type: DELETE_TYPE) -> void:
	_load_level(delete_type)
	
func _load_level(index: int = current_level_index, delete_type: DELETE_TYPE = DELETE_TYPE.QUEUE_FREE) -> void:
	match delete_type:
		DELETE_TYPE.QUEUE_FREE:
			get_child(0).queue_free()
		DELETE_TYPE.REMOVE_CHILD:
			remove_child(get_child(0))
		_:
			printerr("Type not specified for LevelManagerComponent.")
		
	var level_path: String = levels[current_level_index + 1].level.resource_path if index == current_level_index else levels[index]
	ResourceLoader.load_threaded_request(level_path)
	
	var level = ResourceLoader.load_threaded_get(level_path)
	add_child(level.instantiate())
	
	level_loaded.emit()
