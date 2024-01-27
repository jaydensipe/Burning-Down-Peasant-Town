extends KnockbackComponent3D

@onready var omni_light_3d: OmniLight3D = $OmniLight3D
@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D
@onready var explosion_audio_stream_player_3d: AudioStreamPlayer3D = $ExplosionAudioStreamPlayer3D

func _ready() -> void:
	AudioManager.play_audio_at_position_3d(explosion_audio_stream_player_3d, global_position)
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(omni_light_3d, "omni_range", 0.0, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(omni_light_3d, "light_energy", 0.0, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
		
func _on_body_entered(body: Node3D) -> void:
	if (body is Enemy):
		if (body is Peasant):
			x_scale = 5.0
			y_scale = 0.0
			z_scale = 5.0
			override_y = 7.0
		if (body is Knight):
			x_scale = 1.0
			y_scale = 0.0
			z_scale = 1.0
			override_y = 3.0
		
		body.health_component.apply_health(50.0, body.health_component.HEALTH_TYPES.DAMAGE)
		knockback(body.character_movement_3d.character)
		
	if (body is Player):
		x_scale = 15.0
		y_scale = 0.0
		z_scale = 15.0
		override_y = 4.0
		knockback(body.character_movement_3d.character)
