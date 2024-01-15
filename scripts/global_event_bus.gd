extends Node

signal burning_started
func signal_burning_started(burnable_entity: BurnableEntity):
	emit_signal("burning_started", burnable_entity)
