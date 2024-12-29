@icon("res://StateChartLib/Icons/CompoundState.svg")
@tool
extends ParentState
class_name CompoundState

signal state_switched(old_state, new_state)

@export var default_substate:StateChartState
var _current_state:StateChartState

func activate() -> void:
	_switch_state(default_substate)
	super.activate()

func on_tick() -> void:
	super.on_tick()
	if active:
		if _current_state:
			_current_state.on_tick()

## Called when the StateChart received an event
func on_event_received(event:StringName) -> void:
	super.on_event_received(event)
	if active:
		if _current_state:
			_current_state.on_event_received(event)

func on_processing(delta) -> void:
	super.on_processing(delta)
	if active:
		if _current_state:
			_current_state.on_processing(delta)

func on_physics_processing(delta) -> void:
	super.on_physics_processing(delta)
	if active:
		if _current_state:
			_current_state.on_physics_processing(delta)

func _switch_state(new_state:StateChartState) -> void:
	if new_state not in child_states:
		push_error("Trying to switch to a State that is not a child state of this ParentState")
		return
	var old_state:StateChartState = _current_state
	if _current_state:
		_current_state.deactivate()
	new_state.activate()
	_current_state = new_state
	emit_signal("state_switched", old_state, new_state)

func _on_transition(transition:StateTransition) -> void:
	_switch_state(transition.to)

func _add_child_state(child_state:StateChartState) -> StateChartState:
	if !Engine.is_editor_hint():
		child_state.connect("state_transition", _on_transition)
	return super._add_child_state(child_state)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	if !default_substate:
		warnings.append("No default Substate selected.")

	if !child_states:
		warnings.append("No child states found.")

	return warnings
