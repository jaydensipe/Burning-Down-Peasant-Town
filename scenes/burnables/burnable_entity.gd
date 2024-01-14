extends Node3D
class_name BurnableEntity

@export var burnable_component: BurnableComponent
@export var health_component: HealthComponent
@onready var fire_particles: PackedScene = preload("res://assets/fire_particles.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_component.death.connect(func():
		print("death")
		burnable_component.start_burn()
		add_child(fire_particles.instantiate())
	)
