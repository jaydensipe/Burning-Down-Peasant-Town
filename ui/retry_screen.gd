extends Control
class_name RetryScreen

@onready var retry_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/RetryButton

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_retry_button_pressed() -> void:
	queue_free()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
