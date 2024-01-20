extends Node
class_name HealthComponent

enum HEAL_TYPES {
	DAMAGE,
	HEALTH,
}
var is_dead = false
@export var max_health: float = 1.0
@export var _health: float = 1.0:
	set(value):
		_health = clampf(value, 0.0, max_health)
		
		# Sends signal when health value changes
		health_changed.emit(value)
		
		if (_health <= 0.0): 
			death.emit()

func _ready() -> void:
	max_health = _health
	
func is_dead_check() -> bool:
	return is_dead
	
func apply_health(health_offset: float, type: HEAL_TYPES):
	match type:
		HEAL_TYPES.DAMAGE:
			if (_health <= 0.0): return
			
			_health -= absi(health_offset)
		HEAL_TYPES.HEALTH:
			_health += absi(health_offset)
			if (_health == max_health):
				healed_to_full.emit()
		_:
			printerr("Type not specified for HealthComponent.")
	
func reset_health() -> void:
	_health = max_health

signal health_changed(health: float)
signal healed_to_full()
signal death()
