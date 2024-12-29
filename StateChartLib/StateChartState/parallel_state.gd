@icon("res://StateChartLib/Icons/ParallelState.svg")
@tool
extends ParentState
class_name ParallelState

## Called when State gets activated
func activate() -> void:
	super.activate()
	for child_state in child_states:
		child_state.activate()

## Called when State gets deactivated
func deactivate() -> void:
	super.deactivate()
	for child_state in child_states:
		child_state.deactivate()

func on_tick():
	super.on_tick()
	if active:
		for child_state:StateChartState in child_states:
			child_state.on_tick()
