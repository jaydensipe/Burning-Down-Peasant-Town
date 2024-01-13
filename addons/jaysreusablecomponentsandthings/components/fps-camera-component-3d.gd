extends Camera3D
class_name FPSCameraComponent3D

@export var actor: Node3D

@export_group("FPS Settings")
@export var mouse_sensitivity: float = 0.005
@export var rotation_amount: float = 2
@export var rotation_return_time: float = 0.1

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		actor.rotate_y(-event.relative.x * mouse_sensitivity)
		rotate_x(-event.relative.y * mouse_sensitivity)
		rotation.x = clamp(rotation.x, -PI/2, PI/2)

func rotate_camera_left():
	rotation.z = lerp_angle(rotation.z, deg_to_rad(rotation_amount), rotation_return_time)

func rotate_camera_right():
	rotation.z = lerp_angle(rotation.z, deg_to_rad(rotation_amount * -1), rotation_return_time)
	
func reset_rotation():
	rotation.z = lerp_angle(rotation.z, deg_to_rad(0), rotation_return_time)
