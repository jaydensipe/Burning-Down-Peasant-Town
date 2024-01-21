extends Node

signal player_death
func signal_player_death():
	player_death.emit()

signal objective_burned_down(objective: BurnableProp)
func signal_objective_burned_down(objective: BurnableProp):
	objective_burned_down.emit(objective)
	
signal transmit_player_position
func signal_transmit_player_position(global_position: Vector3):
	transmit_player_position.emit(global_position)
	
signal retry_pressed
func signal_retry_pressed():
	retry_pressed.emit()
