extends Control

func _on_retry_button_pressed() -> void:
	GlobalEventBus.signal_retry_pressed()
	queue_free()
