extends Node3D
class_name BurnableEntity

@export var burnable_component: BurnableComponent
@export var health_component: HealthComponent
@export var burn_timer: Timer
@onready var fire_particles: PackedScene = preload("res://assets/fire_particles.tscn")

var being_serviced: bool = false

func _ready() -> void:	
	health_component.death.connect(func():
		GlobalEventBus.signal_burning_started(self)
		add_to_group("burning")
	
		burn_timer.start()
	)
	
	burn_timer.timeout.connect(func():
		burnable_component.start_burn()
		add_child(fire_particles.instantiate())
	)
