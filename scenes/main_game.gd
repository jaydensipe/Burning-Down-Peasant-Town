extends Node
@onready var current_map: Node3D = $CurrentMap

@onready var navigation_region_3d: NavigationRegion3D = $NavigationRegion3D

func _ready():
	GlobalEventBus.objective_burned_down.connect(func():
		print("objective burned down")
	)
