extends Area3D
class_name HitboxComponent3D

@export var health_component: HealthComponent

signal hit(damage_component)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hit.connect(func(damage_component: DamageComponent): health_component.health -= damage_component.damage)
