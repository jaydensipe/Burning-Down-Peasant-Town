extends Camera3D
class_name FPSCameraComponent3D

@export var character: CharacterBody3D
@export var viewmodel_container: Node3D

@export_group("View Config")
@export var mouse_sensitivity: float = 0.005
@export var viewmodel_origin = Vector3(0.0, 0.0, 0.0)

# Camera controller settings and code used from: https://github.com/Btan2/Q_Move/. Thank you!
enum BOB_TYPE { VB_COS, VB_SIN, VB_COS2, VB_SIN2 }

@export_group("Bob Config")
@export var enable_bob: bool = true
@export var bob_mode: BOB_TYPE = BOB_TYPE.VB_SIN
@export var bob_amount: float = 0.012            
@export var bob_up: float = 0.5            
@export var bob_cycle: float = 0.6         
var _bob_times: Array = [0,0,0]
var Q_bobtime: float = 0.0
var Q_bob: float = 0.0

var bobRight : float = 0.0
var bobForward : float = 0.0
var bobUp : float = 0.0


@export_group("Idle Config")
@export var enable_idle: bool = true
@export var idle_scale: float = 1.6      
var iyaw_cycle: float = 1.5       
var iroll_cycle: float = 1.0     
var ipitch_cycle: float = 2.0    
var iyaw_level: float = 0.1       
var iroll_level: float = 0.2         
var ipitch_level: float = 0.15      
var idleRight : float = 0.0
var idleForward : float = 0.0
var idleUp : float =  0.0

var swayPos : Vector3 = Vector3.ZERO
var swayRot : Vector3 = Vector3.ZERO
var swayPos_offset : float = 0.12     # default: 0.12
var swayPos_max : float = 0.5       # default: 0.1
var swayPos_speed : float = 9.0       # default: 9.0
var swayRot_angle : float = 5.0      # default: 5.0   (old default: Vector3(5.0, 5.0, 2.0))
var swayRot_max : float = 15.0       # default: 15.0  (old default: Vector3(12.0, 12.0, 4.0))
var swayRot_speed : float = 5.0     # default: 10.0

var shakecam = false
var shaketime : float = 0.0
var shakelength = 0.0
var deltaTime : float = 0.0
var v_dmg_time : float = 0.0
var v_dmg_roll : float = 0.0
var v_dmg_pitch : float = 0.0

@export_group("Roll Config")
@export var enable_roll: bool = true
@export var roll_amount: float = 15.0          
@export var roll_speed: float = 300.0    
	 
const kick_time: float = 0.5         
const kick_amount: float = 0.6       

var idle_time: float = 0.0
var mouse_move: Vector2 = Vector2.ZERO
var mouse_rotation_x: float = 0.0
var y_offset: float = 1.25          

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	swayPos = viewmodel_origin

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_move = event.relative * 0.1
		mouse_rotation_x -= event.relative.y * mouse_sensitivity
		mouse_rotation_x = clamp(mouse_rotation_x, -90, 90)
		character.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		
func add_bob():
	bobRight = calc_bob(0.75, bob_mode, 0, bobRight)
	bobUp = calc_bob(1.50, bob_mode, 1, bobUp)
	bobForward = calc_bob(1.00, bob_mode, 2, bobForward)
	
var cl_bob : float = 0.01             # default: 0.01
var cl_bobup : float = 0.5            # default: 0.5
var cl_bobcycle : float = 0.8         # default: 0.8

func calc_bob (freqmod: float, mode, bob_i: int, bob: float):
	var cycle : float
	var vel : Vector3
	
	
	_bob_times[bob_i] += deltaTime * freqmod
	cycle = _bob_times[bob_i] - int( _bob_times[bob_i] / cl_bobcycle ) * cl_bobcycle
	cycle /= cl_bobcycle
	
	if cycle < cl_bobup:
		cycle = PI * cycle / cl_bobup
	else:
		cycle = PI + PI * ( cycle - cl_bobup)/( 1.0 - cl_bobup)
	
	vel = character.velocity
	bob = sqrt(vel[0] * vel[0] + vel[2] * vel[2]) * cl_bob
	
	if mode == BOB_TYPE.VB_SIN:
		bob = bob * 0.3 + bob * 0.7 * sin(cycle)
	elif mode == BOB_TYPE.VB_COS:
		bob = bob * 0.3 + bob * 0.7 * cos(cycle)
	elif mode == BOB_TYPE.VB_SIN2:
		bob = bob * 0.3 + bob * 0.7 * sin(cycle) * sin(cycle)
	elif mode == BOB_TYPE.VB_COS2:
		bob = bob * 0.3 + bob * 0.7 * cos(cycle) * cos(cycle)
	bob = clamp(bob, -7, 4)
	
	return bob

func _process(delta: float) -> void:
	deltaTime = delta
	
	# Set points of origin
	rotation_degrees = Vector3(mouse_rotation_x, 0, 0)
	transform.origin = Vector3(0, y_offset, 0)
	viewmodel_container.transform.origin = viewmodel_origin
	viewmodel_container.rotation_degrees = Vector3.ZERO
	
	# Apply velocity roll
	if (enable_roll): velocity_roll()
	
	view_model_sway()
	
	if character.velocity.length() <= 0.1:
		_bob_times = [0,0,0]
		Q_bobtime = 0.0
		
		if (enable_idle):
			add_idle()
			view_idle()
		
		view_model_idle()
	else:
		idle_time = 0.0
		add_bob()
		view_model_bob()
		
		if (enable_bob): 
			view_bob_classic()
			

	# Apply damage/fall kicks
	if v_dmg_time > 0.0:
		rotation_degrees.z += v_dmg_time / kick_time * v_dmg_roll
		rotation_degrees.x += v_dmg_time / kick_time * v_dmg_pitch
		v_dmg_time -= delta
	
	# Apply shake
	if shakecam:
		shake(1)


func view_model_bob():
	for i in range(3):
		viewmodel_container.transform.origin[i] += bobRight * 0.25 * transform.basis.x[i]
		viewmodel_container.transform.origin[i] += bobUp * 0.125 * transform.basis.y[i]
		viewmodel_container.transform.origin[i] += bobForward * 0.06125 * transform.basis.z[i]

func view_model_sway():
	var pos : Vector3
	var rot : Vector3
	
	if mouse_move == null:
		mouse_move = mouse_move.lerp(Vector2.ZERO, 1 * deltaTime)
		return
	
	pos = Vector3.ZERO
	pos.x = clamp(-mouse_move.x * swayPos_offset, -swayPos_max, swayPos_max)
	pos.y = clamp(mouse_move.y * swayPos_offset, -swayPos_max, swayPos_max)
	swayPos = lerp(swayPos, pos, swayPos_speed * deltaTime)
	viewmodel_container.transform.origin += swayPos
	
	rot = Vector3.ZERO
	rot.x = clamp(-mouse_move.y * swayRot_angle, -swayRot_max, swayRot_max)
	rot.z = clamp(mouse_move.x * swayRot_angle, -swayRot_max/3, swayRot_max/3)
	rot.y = clamp(-mouse_move.x * swayRot_angle, -swayRot_max, swayRot_max)
	swayRot = lerp(swayRot, rot, swayRot_speed * deltaTime)

var idlePos_scale = 0.1                         #default: 0.1
var idleRot_scale = 0.5                         #default: 0.5
var idlePos_cycle = Vector3(2.0, 4.0, 0)        #default: Vector3(2.0, 4.0, 0) 
var idlePos_level = Vector3(0.02, 0.045, 0)     #default: Vector3(0.02, 0.045, 0) 
var idleRot_cycle = Vector3(1.0, 0.5, 1.25)     #default: Vector3(1.0, 0.5, 1.25)
var idleRot_level = Vector3(-1.5, 2, 1.5)       #default: Vector3(-1.5, 2, 1.5)

func view_model_idle():
	for i in range(3):
		viewmodel_container.transform.origin[i] += idlePos_scale * sin(idle_time * idlePos_cycle[i]) * idlePos_level[i]
		viewmodel_container.rotation_degrees[i] += idleRot_scale * sin(idle_time * idleRot_cycle[i]) * idleRot_level[i]
		
func velocity_roll() -> void:
	var side: float
	
	side = calc_roll(character.velocity, roll_amount, roll_speed) * 4
	rotation_degrees.z += side
	viewmodel_container.rotation_degrees.z += side

func calc_roll(velocity: Vector3, angle: float, speed: float) -> float:
	var s: float
	var side: float
	
	side = velocity.dot(-get_global_transform().basis.x)
	s = sign(side)
	side = abs(side)
	
	if (side < speed):
		side = side * angle / speed;
	else:
		side = angle;
	
	return side * s

func add_idle():
	idle_time += deltaTime
	idleRight = idle_scale * sin(idle_time * ipitch_cycle) * ipitch_level
	idleUp = idle_scale * sin(idle_time * iyaw_cycle) * iyaw_level
	idleForward = idle_scale * sin(idle_time * iroll_cycle) * iroll_level

func view_idle():
	rotation_degrees.x += idleUp
	rotation_degrees.y += idleRight
	rotation_degrees.z += idleForward

func view_bob_classic():
	transform.origin[1] += calc_bob_classic()

func calc_bob_classic():
	var vel : Vector3
	var cycle : float
	
	Q_bobtime += deltaTime
	cycle = Q_bobtime - int(Q_bobtime / bob_cycle) * bob_cycle
	cycle /= bob_cycle
	if cycle < bob_up:
		cycle = PI * cycle / bob_up
	else:
		cycle = PI + PI * (cycle - bob_up) / (1.0 - bob_up)
	
	vel = character.velocity
	Q_bob = sqrt(vel[0] * vel[0] + vel[2] * vel[2]) * bob_amount
	Q_bob = Q_bob * 0.3 + Q_bob * 0.7 * sin(cycle)
	Q_bob = clamp(Q_bob, -7.0, 4.0)
	
	return Q_bob

func trigger_shake(time: float):
	shakecam = true
	
	shaketime = 0.0
	shakelength = time
	await get_tree().create_timer(time).timeout
	
	shakecam = false

func shake(easing: int):
	var cycle = Vector3(33, 44, 36)
	var v_level = Vector3(-1.5, 2, 1.25)
	var s_scale : float
	
	shaketime += deltaTime 
	
	easing = clamp(easing, 0, 2)
	if easing == 0: # No shake easing
		s_scale = 1.0
	elif easing == 1: # Ease off scaling towards the end of the shake
		var diff = shakelength - shaketime
		s_scale = diff if diff <= 1.0 else 1.0
	elif easing == 2: # Ease off scaling throughout the entire shake
		s_scale = 1.0 - shaketime/shakelength
	
	for i in range(3):
		rotation_degrees[i] += s_scale * sin(shaketime * cycle[i]) * v_level[i]
