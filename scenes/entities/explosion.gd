extends Area3D
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D

func _on_body_entered(body: Node3D) -> void:
	if !(body.is_in_group("player")): return
	
	var player = body as Player
	var vector = body.global_transform.origin - global_transform.origin
	var direction := vector.normalized()
	var distance_squared := vector.length_squared()
	var velocity := direction * 10.0/distance_squared
	
	player.character_movement_3d.character.velocity += Vector3(velocity.normalized().x * 15.0, 5.0, velocity.normalized().z * 15.0)
