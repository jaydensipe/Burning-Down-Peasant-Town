extends Node
class_name BurnableComponent

var burning: bool = false:
	set(value):
		burning = value
		
		if (value):
			burn_timer.start()
		else:
			burn_timer.stop()

@export var actor: Node
@export var burn_timer: Timer

func _ready() -> void:
	burn_timer.timeout.connect(func(): _burn())

func _burn() -> void:
	actor.queue_free()
