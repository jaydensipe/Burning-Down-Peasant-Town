extends Node3D
class_name BurnableObjective

var being_serviced: bool = false
@export var health_component: HealthComponent
@export var burnable_component: BurnableComponent
@onready var texture_progress_bar: TextureProgressBar = $SubViewport/TextureProgressBar
@onready var circle_sprite_3d: Sprite3D = $CircleSprite3D

func _physics_process(delta: float) -> void:
	texture_progress_bar.value = burnable_component.burn_timer.wait_time - burnable_component.burn_timer.time_left
	
func _ready() -> void:
	texture_progress_bar.max_value = burnable_component.burn_timer.wait_time
	
	health_component.death.connect(func():
		burnable_component.burning = true
		add_to_group("burning")
	)
	
	health_component.healed_to_full.connect(func():
		circle_sprite_3d.hide()
		
		burnable_component.burning = false
		remove_from_group("burning")
	)
	
	burnable_component.started_burn.connect(func():
		circle_sprite_3d.show()
	)
	
	burnable_component.finished_burn.connect(func():
		GlobalEventBus.signal_objective_burned_down(self)
	)

