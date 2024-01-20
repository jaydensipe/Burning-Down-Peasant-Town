extends Node

signal objective_burned_down(objective: BurnableProp)
func signal_objective_burned_down(objective: BurnableProp):
	objective_burned_down.emit(objective)
