extends Weapon3D

@onready var damage_component: DamageComponent = $DamageComponent
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D
@onready var spawner_component: SpawnerComponent = $SpawnerComponent
@onready var ray_cast_3d: RayCast3D = $RayCast3D

func _ready() -> void:
	stopped_shooting.connect(func():
		gpu_particles_3d.emitting = false
		)

func _physics_process(delta: float) -> void:
	super(delta)
	
func shoot() -> void:
	super()
	
	gpu_particles_3d.emitting = true
	
	if (ray_cast_3d.is_colliding()):
		spawner_component.spawn_at_location(ray_cast_3d.get_collision_point())
		
	var collision = damage_component.get_overlapping_bodies()
	if (len(collision) <= 0): return
	
	collision = collision[0]
	if !(collision is BurnableEntity): return
	
	var burnable = collision as BurnableEntity
	burnable.health_component.health -= damage_component.damage
	
	
	
