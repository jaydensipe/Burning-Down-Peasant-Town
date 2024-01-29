extends Control
class_name LoadScreen

@export var loading_screens: Array[CompressedTexture2D] = []
@export var tooltips: Array[String] = []
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var loading_label: Label = $LoadingLabel
@onready var press_any_key_label: Label = $PressAnyKeyLabel
@onready var tooltip_label: Label = $TooltipLabel
@onready var loading_screen: Node2D = $LoadingScreen

signal press_any_key_pressed

func _ready() -> void:
	var loading_sprite: Sprite2D = Sprite2D.new()
	loading_sprite.texture = loading_screens.pick_random()
	loading_screen.add_child(loading_sprite)
	
	tooltip_label.text = tooltips.pick_random()
	
	SceneLoaderManager.scene_loaded.connect(func():
		loading_label.hide()
		press_any_key_label.show()
	)

func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton:
		if event.pressed:
			press_any_key_pressed.emit()
			
func _process(delta: float) -> void:
	progress_bar.value = SceneLoaderManager.load_progress[0] * 100.0
