extends Node
class_name BurnableComponent


const FIRE = preload("res://addons/jaysreusablecomponentsandthings/assets/fire/fire.tscn")
var burning: bool = false:
	set(value):
		burning = value
		
		if (value):
			burn_timer.start()
			started_burn.emit()
			
			if (use_3d_burn_effects):
				_default_burn_vfx_3d()
		else:
			burn_timer.stop()
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

func _default_burn_vfx_3d() -> void:
	var material: StandardMaterial3D = mesh.get_surface_override_material(0)
	get_tree().create_tween().tween_property(material, "albedo_color", burn_hue, initial_discolor_time)
	var f = FIRE.instantiate()
	f.transform.scaled(Vector3(10.0, 10.0, 10.0))
	owner.add_child(f)
	
func _default_burn_vfx_2d() -> void:
	pass
	

func _burn() -> void:
	finished_burn.emit()
	
	actor.queue_free()
