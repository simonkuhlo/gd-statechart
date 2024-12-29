@icon("res://StateChartLib/Icons/ActiveStateGuard.svg")
@tool
extends TransitionGuard
class_name ActiveStateGuard

@export var state_to_watch:StateChartState:
	set(state):
		state_to_watch = state
		update_configuration_warnings()

func is_statisfied() -> bool:
	if state_to_watch.active:
		return true
	return false

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	#TODO: Warn if watching state is part of the same CompoundState parent
	
	if !state_to_watch:
		warnings.append("No State to watch set!")
	return warnings
