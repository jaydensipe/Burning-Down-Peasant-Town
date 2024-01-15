extends Area3D
class_name DamageComponent

@export var damage: float = 0.0

func _ready() -> void:
	area_entered.connect(_process_damage)

func _process_damage(area: Area3D):
	if !(area is HitboxComponent3D): return
	
	area.hit.emit(self)
