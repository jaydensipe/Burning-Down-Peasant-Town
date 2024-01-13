extends Node
class_name BurnableComponent

@export var actor: Node
@export var burn_stats: BurnStats

func start_burn() -> void:
	#TODO: Add burning shader
	get_tree().create_timer(randf_range(burn_stats.burn_min_time, burn_stats.burn_max_time)).timeout.connect(_burn)
	
func _burn() -> void:
	actor.queue_free()
