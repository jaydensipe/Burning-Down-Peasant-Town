extends CharacterBody3D
class_name Enemy

@onready var health_component: HealthComponent = $HealthComponent
@onready var burnable_component: BurnableComponent = $BurnableComponent
@onready var character_movement_3d: CharacterMovement3D = $CharacterMovement3D
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

func _ready() -> void:
	health_component.death.connect(func():
		burnable_component.burning = true
	)
	
