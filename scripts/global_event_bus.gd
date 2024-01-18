extends Node

signal objective_burned_down
func signal_objective_burned_down():
	objective_burned_down.emit()
