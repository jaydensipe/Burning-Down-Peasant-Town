extends CharacterBody3D
class_name Player

var victory_achieved: bool = false
@onready var health_component: HealthComponent = $HealthComponent
@onready var character_movement_3d: CharacterMovement3D = $CharacterMovement3D
@onready var fps_camera_component_3d: FPSCameraComponent3D = $FPSCameraComponent3D
@onready var spawn_effect_spawner_component_3d: SpawnerComponent3D = $SpawnEffectSpawnerComponent3D
@onready var weapon_container_component: WeaponContainerComponent3D = $FPSCameraComponent3D/WeaponContainerComponent
@onready var foot_step_audio_stream_player_3d: AudioStreamPlayer3D = $FootStepAudioStreamPlayer3D

func _ready() -> void:
	spawn_effect_spawner_component_3d.spawn_at_location(global_position)
	
	health_component.death.connect(func():
		weapon_container_component.current_weapon.hide()
		weapon_container_component.current_weapon.can_attack = false

		GlobalEventBus.signal_player_death()
	)
	
	fps_camera_component_3d.footstep.connect(func():
		if !(foot_step_audio_stream_player_3d.playing):
			foot_step_audio_stream_player_3d.play()
	)
	
	GlobalEventBus.victory_achieved.connect(func():
		victory_achieved = true
		
		weapon_container_component.current_weapon.hide()
		weapon_container_component.current_weapon.can_attack = false
	)
	
func _physics_process(delta: float) -> void:
	if (health_component.is_dead or victory_achieved): 
		character_movement_3d.apply_player_input_direction(Vector2.ZERO)
		return
	
	if (Input.is_action_just_pressed("jump")):
		character_movement_3d.jump()
		
	character_movement_3d.apply_player_input_direction(Input.get_vector("move_left", "move_right", "move_forward", "move_backward"))

	GlobalEventBus.signal_transmit_player_position(global_position)
