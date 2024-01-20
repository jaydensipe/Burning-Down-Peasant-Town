extends Area3D
@onready var spawner_component: SpawnerComponent = $SpawnerComponent

func _on_body_entered(body: Node3D) -> void:
	if (body is Player): return
	
	spawner_component.spawn_at_location(global_position)
	queue_free()
