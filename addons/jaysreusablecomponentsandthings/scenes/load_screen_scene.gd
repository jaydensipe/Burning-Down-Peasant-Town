extends Control
class_name LoadScreen

@export var tooltips: Array[String] = []
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var loading_label: Label = $LoadingLabel
@onready var press_any_key_label: Label = $PressAnyKeyLabel
@onready var tooltip_label: Label = $TooltipLabel

signal press_any_key_pressed

func _ready() -> void:
	tooltip_label.text = tooltips.pick_random()
	
	SceneLoaderManager.scene_loaded.connect(func():
		loading_label.hide()
		press_any_key_label.show()
	)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			press_any_key_pressed.emit()
			
func _process(delta: float) -> void:
	progress_bar.value = SceneLoaderManager.load_progress[0] * 100.0
