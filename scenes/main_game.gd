extends Node

@onready var level_manager: LevelManager = $LevelManager

func _ready():
	GlobalEventBus.objective_burned_down.connect(func(objective: BurnableProp):
		GlobalGameInformation.burnable_objectives.erase(objective)
		
		if (GlobalGameInformation.burnable_objectives.is_empty()):
			level_manager.load_next_level(level_manager.DELETE_TYPE.QUEUE_FREE)
	)

func _on_level_manager_level_loaded() -> void:
	GlobalGameInformation.burnable_objectives = get_tree().get_nodes_in_group("burn_objective")
