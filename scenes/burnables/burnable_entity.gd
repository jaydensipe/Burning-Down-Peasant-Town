extends Node3D
class_name BurnableProp

var being_serviced: bool = false
@export var health_component: HealthComponent
@export var burnable_component: BurnableComponent
@onready var label_3d: Label3D = $Label3D
@onready var house: MeshInstance3D = $House
func _physics_process(delta: float) -> void:
	label_3d.text = str(burnable_component.burn_timer.wait_time) if burnable_component.burn_timer.is_stopped() else str(burnable_component.burn_timer.time_left)
	
func _ready() -> void:
	health_component.death.connect(func():
		burnable_component.burning = true
		add_to_group("burning")
	)
	
	burnable_component.finished_burn.connect(func():
		GlobalEventBus.signal_objective_burned_down(self)
	)
	
	health_component.healed_to_full.connect(func():
		burnable_component.burning = false
		remove_from_group("burning")
	)

