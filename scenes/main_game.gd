extends Node
@onready var level_manager: LevelManager = $LevelManager
@onready var main_menu: MainMenu = $MainMenu
@onready var how_to_play: Control = $MainMenu/HowToPlay
const RETRY_SCREEN = preload("res://ui/retry_screen.tscn")

func _ready():
	GlobalEventBus.player_death.connect(func():
		add_child(RETRY_SCREEN.instantiate())
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	)
	
	GlobalEventBus.objective_burned_down.connect(func(objective: BurnableProp):
		GlobalGameInformation.burnable_objectives.erase(objective)
		
		if (GlobalGameInformation.burnable_objectives.is_empty()):
			level_manager.load_next_level(level_manager.DELETE_TYPE.QUEUE_FREE)
	)
	
	_init_ui()
	
	
func _on_level_manager_level_loaded() -> void:
	GlobalGameInformation.burnable_objectives = get_tree().get_nodes_in_group("burn_objective")
	
func _init_ui() -> void:
	how_to_play.back_button.pressed.connect(func():
		get_tree().create_tween().tween_property(main_menu, "position:x", 0, 0.3).set_trans(Tween.TRANS_SINE)
	)
	main_menu.play_button.pressed.connect(func(): 
		remove_child(main_menu)
		level_manager.load_level_by_index(0)
	)
	
	main_menu.quit_button.pressed.connect(func():
		get_tree().quit()
	)
	
	main_menu.how_to_play_button.pressed.connect(func():
		get_tree().create_tween().tween_property(main_menu, "position:x", -1920, 0.3).set_trans(Tween.TRANS_SINE)
	)
	
	
	
	GlobalEventBus.retry_pressed.connect(func():
		level_manager.load_level_by_index(level_manager.current_level_index, level_manager.DELETE_TYPE.QUEUE_FREE)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	)

