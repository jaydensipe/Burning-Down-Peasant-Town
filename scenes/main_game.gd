extends Node

@onready var navigation_region_3d: NavigationRegion3D = $NavigationRegion3D

func _ready() -> void:
	GlobalEventBus.burning_started.connect(func(burnable_entity: BurnableEntity):
		print("hello")
		)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
