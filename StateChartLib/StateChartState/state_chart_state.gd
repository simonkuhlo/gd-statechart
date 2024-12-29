@icon("res://StateChartLib/Icons/StateInterface.svg")
@tool
extends Node
class_name StateChartState

## Emitted when State wants to transition
signal state_transition(transition:StateTransition)

## Emitted when State gets activated
signal activated()

## Emitted when active and processing (once per frame)
signal processing(delta)

## Emitted when active and physics_processing (once per physics_tick)
signal physics_processing(delta)

## Emitted when State gets deactivated
signal deactivated()

## Wether the state is cuerrently active or not
var active:bool = false

var _state_chart:StateChart
## Reference to the parent StateChart
var state_chart:StateChart:
	set(new_state_chart):
		_edit_state_chart(new_state_chart)
	get:
		return _state_chart

func _edit_state_chart(new_state_chart) -> void:
	_state_chart = new_state_chart
	for transition in transitions:
		transition.state_chart = state_chart

## Private variable, use "transitions"
var _cached_transitions:Array[StateTransition] = []

## Array of Transitions this State currently has
var transitions: Array[StateTransition]:
	get:
		if _cached_transitions.is_empty():
			_add_all_transitions()
		return _cached_transitions

var transition_queue:TransitionQueue

## Called when the Node enters the SceneTree
func _ready() -> void:
	if !Engine.is_editor_hint():
		transition_queue = TransitionQueue.new()
		add_child(transition_queue)
		transition_queue.connect("transition_ready", _on_transition_ready)
	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exiting_tree)
	child_order_changed.connect(_on_tree_changed)
	if Engine.is_editor_hint():
		update_configuration_warnings()

## Called when this node gets a new Child
func _on_child_entered_tree(node) -> void:
	if node is StateTransition:
		_add_transition(node)
	update_configuration_warnings()

## Called when this node loses a Child
func _on_child_exiting_tree(node) -> void:
	if node is StateTransition:
		_remove_transition(node)
	update_configuration_warnings()

## Called when SceneTree has changed
func _on_tree_changed() -> void:
	update_configuration_warnings()

## Called when the StateChart received an event
func on_event_received(event:StringName) -> void:
	for transition:StateTransition in transitions:
		transition.on_event_received(event)

## Called every StateChart tick
func on_tick() -> void:
	if active:
		_try_transitions()

## Called when active and processing (once per frame)
func on_processing(delta) -> void:
	if active:
		emit_signal("processing", delta)

## Called when active and physics_processing (once per physics tick)
func on_physics_processing(delta) -> void:
	if active:
		emit_signal("physics_processing", delta)

## Called when State gets activated
func activate() -> void:
	active = true
	emit_signal("activated")

## Called when State gets deactivated
func deactivate() -> void:
	transition_queue.clear_transitions()
	active = false
	emit_signal("deactivated")

## Called when a child transition signals that the transition is possible
func _on_transition_possible(transition:StateTransition) -> void:
	if active:
		transition_queue.queue_transition(transition)

func _on_transition_ready(transition:StateTransition) -> void:
	if active:
		emit_signal("state_transition", transition)

## Try all transitions that don't have a specific Trigger
func _try_transitions() -> void:
	for transition:StateTransition in transitions:
		if !transition.trigger:
			transition.try_transition()

## Get all current Transitions of this State
func _add_all_transitions() -> void:
	for child in get_children():
		if child is StateTransition:
			_add_transition(child)

## Add a new transition to this state
func _add_transition(transition:StateTransition) -> void:
	if !Engine.is_editor_hint():
		transition.connect("transition_possible", _on_transition_possible)
	_cached_transitions.append(transition)
	update_configuration_warnings()

## Add a new transition to this state
func _remove_transition(transition:StateTransition) -> void:
	if !Engine.is_editor_hint():
		transition.disconnect("transition_possible", _on_transition_possible)
	_cached_transitions.erase(transition)
	update_configuration_warnings()
