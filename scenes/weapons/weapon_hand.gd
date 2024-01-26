extends Weapon3D

@onready var damage_component: DamageComponent = $FireAttack/DamageComponent
@onready var gpu_particles_3d: GPUParticles3D = $FireAttack/GPUParticles3D
@onready var ray_cast_3d: RayCast3D = $FireAttack/RayCast3D
@onready var decal_spawner_component: SpawnerComponent3D = $FireAttack/DecalSpawnerComponent
@onready var projectile_spawner_component: SpawnerComponent3D = $AlternateAttack/ProjectileSpawnerComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_chart: StateChart = $StateChart
@onready var audio_fire_ignite: AudioStreamPlayer = $AudioFireIgnite
@onready var audio_fire_loop: AudioStreamPlayer = $AudioFireLoop
@onready var omni_light_3d: OmniLight3D = $FireAttack/OmniLight3D

func _ready() -> void:
	stopped_shooting.connect(func():
		state_chart.send_event("primary_to_idle")
	)

func _physics_process(delta: float) -> void:
	super(delta)
	
func shoot() -> void:
	super()
	
	state_chart.send_event("idle_to_primary")

func _on_primary_state_entered() -> void:
	if !(Input.is_action_pressed("shoot")):
		state_chart.send_event("primary_to_idle")
		return
		
	var wielder: Player = (get_parent() as WeaponContainerComponent3D).wielder as Player
	get_tree().create_tween().tween_property(wielder.character_movement_3d.move_stats, "speed", wielder.character_movement_3d.move_stats.speed - 1.5, 0.5)

	gpu_particles_3d.emitting = true
	audio_fire_ignite.play()

func _on_primary_state_exited() -> void:
	gpu_particles_3d.emitting = false
	audio_fire_loop.stop()
	omni_light_3d.hide()
	
	var wielder: Player = (get_parent() as WeaponContainerComponent3D).wielder as Player
#	# temporary locked at 4.0
	get_tree().create_tween().tween_property(wielder.character_movement_3d.move_stats, "speed", clampf(wielder.character_movement_3d.move_stats.speed + 1.5, 2.5, 4.0), 0.5)
	
func _on_primary_state_physics_processing(delta: float) -> void:
	if (ray_cast_3d.is_colliding()):
		decal_spawner_component.spawn_at_location(ray_cast_3d.get_collision_point())
		
	if (!audio_fire_loop.playing):
		omni_light_3d.show()
		audio_fire_loop.play()
		
	var collision = damage_component.get_overlapping_bodies()
	if (len(collision) <= 0): return
	
	collision = collision[0]
	if !(collision.is_in_group("burnable")): return
	
	collision.health_component.apply_health(damage_component.damage, collision.health_component.HEALTH_TYPES.DAMAGE)
	
func alternate_fire() -> void:
	super()
	
	state_chart.send_event("idle_to_alternate")
	

func _on_alternate_state_entered() -> void:
	projectile_spawner_component.spawn_at_location_with_transform()
	animation_player.animation_finished.connect(func(_animation_name): state_chart.send_event("alternate_to_idle"))
