extends Weapon3D

@onready var damage_component: DamageComponent = $FireAttack/DamageComponent
@onready var gpu_particles_3d: GPUParticles3D = $FireAttack/GPUParticles3D
@onready var ray_cast_3d: RayCast3D = $FireAttack/RayCast3D
@onready var decal_spawner_component: SpawnerComponent = $FireAttack/DecalSpawnerComponent
@onready var projectile_spawner_component: SpawnerComponent = $AlternateAttack/ProjectileSpawnerComponent
@onready var projectile_spawn_location: Marker3D = $AlternateAttack/ProjectileSpawnLocation
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_chart: StateChart = $StateChart

func _ready() -> void:
	stopped_shooting.connect(func():
		state_chart.send_event("primary_to_idle")
	)

func _physics_process(delta: float) -> void:
	super(delta)
	
func shoot() -> void:
	super()
	state_chart.send_event("idle_to_primary")
	
func alternate_fire() -> void:
	super()
	state_chart.send_event("idle_to_alternate")

func _on_idle_state_entered() -> void:
	gpu_particles_3d.emitting = false

func _on_primary_attacking_state_physics_processing(delta: float) -> void:
	gpu_particles_3d.emitting = true
	
	if (ray_cast_3d.is_colliding()):
		decal_spawner_component.spawn_at_location(ray_cast_3d.get_collision_point())
		
	var collision = damage_component.get_overlapping_bodies()
	if (len(collision) <= 0): return
	
	collision = collision[0]
	if !(collision.is_in_group("burnable")): return
	
	collision.health_component.apply_health(damage_component.damage, collision.health_component.HEALTH_TYPES.DAMAGE)


func _on_alternate_state_entered() -> void:
	projectile_spawner_component.spawn_at_location_with_transform(projectile_spawn_location.global_transform)
	
	animation_player.animation_finished.connect(func(_animation_name): state_chart.send_event("alternate_to_idle"))
	
