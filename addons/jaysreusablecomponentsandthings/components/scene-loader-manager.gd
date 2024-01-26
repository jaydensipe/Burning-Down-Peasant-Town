extends Node

const LOAD_SCREEN_SCENE = preload("res://addons/jaysreusablecomponentsandthings/scenes/load_screen_scene.tscn")

var load_progress: Array[int] = []
var _scene_path: String = ""

signal scene_loaded

func load_packed_scene(packed_scene: PackedScene):
	var load_scene: LoadScreen = LOAD_SCREEN_SCENE.instantiate()
	get_tree().root.add_child(load_scene)
	
# TODO: GET RID OF
	await get_tree().create_timer(1.0).timeout
	
	_scene_path = packed_scene.resource_path
	ResourceLoader.load_threaded_request(_scene_path)
	
	await load_scene.press_any_key_pressed
	
	get_tree().root.remove_child(load_scene)
	return ResourceLoader.load_threaded_get(_scene_path)
	
	
func _process(delta: float) -> void:
	var scene_load_status = ResourceLoader.load_threaded_get_status(_scene_path, load_progress)
	if (scene_load_status == ResourceLoader.THREAD_LOAD_LOADED):
		scene_loaded.emit()
