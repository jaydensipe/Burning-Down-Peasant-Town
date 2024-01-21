extends Node

var burnable_objectives: Array[Node] = []
var player_pos: Vector3 = Vector3.ZERO

func _ready() -> void:
	GlobalEventBus.transmit_player_position.connect(func(global_position: Vector3):
		player_pos = global_position
	)
	
func _physics_process(delta: float) -> void:
	pass
