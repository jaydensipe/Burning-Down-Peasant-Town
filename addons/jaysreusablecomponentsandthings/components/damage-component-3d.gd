extends Area3D
class_name DamageComponent

@export var damage: float = 0.0

func _ready() -> void:
	area_entered.connect(_process_damage)

func _process_damage(hitbox: HitboxComponent3D):
	if !(hitbox is HitboxComponent3D): return
	
	hitbox.hit.emit(self)
