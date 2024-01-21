extends KnockbackComponent3D
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D

func _on_body_entered(body: Node3D) -> void:
	if (body is Enemy):
		if (body is Peasant):
			x_scale = 5.0
			y_scale = 0.0
			z_scale = 5.0
			override_y = 8.0
		if (body is Guard):
			x_scale = 1.0
			y_scale = 0.0
			z_scale = 1.0
			override_y = 2.0
		
		body.health_component.apply_health(50, body.health_component.HEALTH_TYPES.DAMAGE)
		knockback(body.character_movement_3d.character)
		
	if (body is Player):
		x_scale = 15.0
		y_scale = 0.0
		z_scale = 15.0
		override_y = 4.0
		knockback(body.character_movement_3d.character)
