extends Node
class_name HealthComponent

@export var health: int = 1:
	set(value):
		health = value
		
		# Sends signal when health value changes
		health_changed.emit()
		
		# Sends signal when health is 0
		if (health == 0): death.emit()
		
signal health_changed()
signal death()
