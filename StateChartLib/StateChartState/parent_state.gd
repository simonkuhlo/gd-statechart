@icon("res://StateChartLib/Icons/StateInterface.svg")
@tool
extends StateChartState
class_name ParentState


var _cached_child_states: Array[StateChartState] = []
var child_states: Array[StateChartState]:
	get:
		if _cached_child_states.is_empty():
			_add_all_child_states()
		return _cached_child_states

func _ready() -> void:
	super._ready()

func _on_child_entered_tree(node) -> void:
	if node is StateChartState:
		_add_child_state(node)
	super._on_child_entered_tree(node)

func _on_child_exiting_tree(node) -> void:
	if node is StateChartState:
		_remove_child_state(node)
	super._on_child_entered_tree(node)

## Called when the StateChart received an event
func on_event_received(event:StringName) -> void:
	super.on_event_received(event)
	for child_state in child_states:
		if child_state.active:
			child_state.on_event_received(event)

func on_tick() -> void:
	super.on_tick()
	for child_state in child_states:
		child_state.on_tick()

func on_processing(delta) -> void:
	super.on_processing(delta)
	for child_state in child_states:
		child_state.on_processing(delta)

func on_physics_processing(delta) -> void:
	super.on_physics_processing(delta)
	for child_state in child_states:
		child_state.on_physics_processing(delta)

func _edit_state_chart(new_state_chart) -> void:
	super._edit_state_chart(new_state_chart)
	for child in child_states:
		child.state_chart = new_state_chart

func _add_all_child_states() -> void:
	for child in get_children():
		if child is StateChartState:
			_add_child_state(child)

func _add_child_state(child_state:StateChartState) -> StateChartState:
	_cached_child_states.append(child_state)
	if Engine.is_editor_hint():
		update_configuration_warnings()
	return child_state

func _remove_child_state(child_state:StateChartState) -> StateChartState:
	_cached_child_states.erase(child_state)
	if !Engine.is_editor_hint():
		update_configuration_warnings()
	return child_state

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if child_states.is_empty():
		warnings.append("No child states found.")
	return warnings
