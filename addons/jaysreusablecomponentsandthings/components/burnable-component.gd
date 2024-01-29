extends Node
class_name BurnableComponent


@onready var fire = preload("res://addons/jaysreusablecomponentsandthings/assets/fire/fire.tscn").instantiate()
var burning: bool = false:
	set(value):
		burning = value
		
		if (value):
			burn_timer.paused = false
			
			burn_timer.start()
			started_burn.emit()
			
			if (use_3d_burn_effects):
				_default_burn_vfx_3d()
		else:
			burn_timer.paused = true
			
			if (use_3d_burn_effects):
				_default_burn_vfx_3d(true)
				
@export var actor: Node
@export var burn_timer: Timer

@export_group("3D VFX Config")
@export var use_3d_burn_effects: bool = false
@export var mesh: MeshInstance3D
@export var burn_hue: Color
@export var initial_discolor_time: float = 1.0
@export_group("2D VFX Config")

signal started_burn()
signal finished_burn()

func _ready() -> void:
	burn_timer.timeout.connect(func(): _burn())

func _default_burn_vfx_3d(disable: bool = false) -> void:
	var material: StandardMaterial3D = mesh.get_active_material(0).duplicate()
	mesh.material_override = material
	
	if (disable):
		get_tree().create_tween().tween_property(material, "albedo_color", Color.WEB_GRAY, initial_discolor_time)
		
		actor.remove_child(fire)
	else:
		get_tree().create_tween().tween_property(material, "albedo_color", burn_hue, initial_discolor_time)
		fire.scale = (mesh.global_transform * mesh.mesh.get_aabb()).size * 0.6
		
		actor.add_child(fire)
	
func _default_burn_vfx_2d() -> void:
	pass

func _burn() -> void:
	finished_burn.emit()
	
	actor.queue_free()
