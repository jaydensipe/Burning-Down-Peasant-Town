extends Node3D
class_name Map

var time: float = 0.0
var countdown: bool = true
@onready var remaining_houses: int = get_tree().get_nodes_in_group("burn_objective").size()
@onready var timer_label: RichTextLabel = $MapUI/TimerLabel
@onready var houses_remaining_label: RichTextLabel = $MapUI/HousesRemainingLabel
@onready var map_ui: Control = $MapUI

func _ready() -> void:
	GlobalEventBus.objective_burned_down.connect(func(objective):
		remaining_houses -= 1
	)
	
	GlobalEventBus.victory_achieved.connect(func():
		map_ui.hide()
	)

func _process(delta: float) -> void:
	if (!countdown): return
	
	time += delta
	timer_label.text = "%02d:%02d:%02d" % [fmod(time, 60 * 60) / 60, fmod(time, 60), fmod(time, 1) * 100]
	houses_remaining_label.text = "%02d" % [remaining_houses]
	
	
	
