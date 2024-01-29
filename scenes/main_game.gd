extends Node
class_name Main

@onready var level_manager: LevelManager = $LevelManager
@onready var main_menu: MainMenu = $MainMenu
@onready var how_to_play: Control = $MainMenu/HowToPlay
@onready var music_audio_stream_player: AudioStreamPlayer = $MusicAudioStreamPlayer

const RETRY_SCREEN = preload("res://ui/retry_screen.tscn")
const VICTORY_SCREEN = preload("res://ui/victory_screen.tscn")

func _ready():
	_init_game()
	_init_ui()
	
func _init_game() -> void:
	GlobalEventBus.objective_burned_down.connect(func(objective: BurnableObjective):
		GlobalGameInformation.burnable_objectives.erase(objective)
		
		if (GlobalGameInformation.burnable_objectives.is_empty()):
			GlobalEventBus.signal_victory_achieved()
			
			var current_map: Map = level_manager.get_child(0) as Map
			current_map.countdown = false
			
			var victory_screen: VictoryScreen = VICTORY_SCREEN.instantiate()
			add_child(victory_screen)
			victory_screen.time_label.text = "Time: " + current_map.timer_label.text
			
			await victory_screen.next_map_button.pressed
			level_manager.load_next_level(level_manager.DELETE_TYPE.QUEUE_FREE)
	)
	
	GlobalEventBus.player_death.connect(func():
		var current_map: Map = level_manager.get_child(0) as Map
		current_map.countdown = false
		
		var retry_screen: RetryScreen = RETRY_SCREEN.instantiate()
		add_child(retry_screen)
		
		await retry_screen.retry_button.pressed
		
		level_manager.load_level_by_index(level_manager.current_level_index, level_manager.DELETE_TYPE.QUEUE_FREE)
	)
	
	GlobalEventBus.victory_achieved.connect(func():
		for burnable in get_tree().get_nodes_in_group("burnable"):
			if (is_instance_valid(burnable.health_component)):
				burnable.health_component.apply_health(10000, burnable.health_component.HEALTH_TYPES.DAMAGE)
		
	)
	
func _on_level_manager_level_loaded() -> void:
	GlobalGameInformation.burnable_objectives = get_tree().get_nodes_in_group("burn_objective")
	
func _init_ui() -> void:
	how_to_play.back_button.pressed.connect(func():
		get_tree().create_tween().tween_property(main_menu, "position:x", 0, 0.3).set_trans(Tween.TRANS_CIRC)
	)
	
	main_menu.play_button.pressed.connect(func(): 
		remove_child(main_menu)
		level_manager.load_level_by_index(0)
		
		music_audio_stream_player.play()
	)
	
	main_menu.quit_button.pressed.connect(func():
		get_tree().quit()
	)
	
	main_menu.how_to_play_button.pressed.connect(func():
		get_tree().create_tween().tween_property(main_menu, "position:x", -1920, 0.3).set_trans(Tween.TRANS_SINE)
	)
