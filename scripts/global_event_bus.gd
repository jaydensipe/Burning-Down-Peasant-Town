extends Node

signal objective_burned_down(objective: BurnableObjective)
func signal_objective_burned_down(objective: BurnableObjective):
	objective_burned_down.emit(objective)
	
signal victory_achieved()
func signal_victory_achieved():
	victory_achieved.emit()
	
signal transmit_player_position
func signal_transmit_player_position(global_position: Vector3):
	transmit_player_position.emit(global_position)
	
signal player_death
func signal_player_death():
	player_death.emit()

