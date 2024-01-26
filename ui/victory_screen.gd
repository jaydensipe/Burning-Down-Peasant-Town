extends Control
class_name VictoryScreen

@onready var next_map_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NextMapButton
@onready var time_label: Label = $PanelContainer/MarginContainer/VBoxContainer/TimeLabel

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _on_next_map_button_pressed() -> void:
		queue_free()
