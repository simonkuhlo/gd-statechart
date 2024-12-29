@icon("res://StateChartLib/Icons/StateTransition.svg")
@tool
extends Node
class_name StateTransition

signal transition_possible(transition:StateTransition)

## The State this Transition leads to
@export var to:StateChartState:
	set(new_state):
		to = new_state
		update_configuration_warnings()

## The Event that should trigger this Transition
@export var trigger:StringName

## Delay in Seconds before transitioning
@export var delay_seconds:float

## Private variable, use "guards"
var _cached_guards:Array[TransitionGuard] = []

## Array of Guards this State currently has
@onready var guards: Array[TransitionGuard]:
	get:
		if _cached_guards.is_empty():
			_add_all_guards()
		return _cached_guards

var _state_chart:StateChart
## Reference to the parent StateChart
var state_chart:StateChart:
	set(new_state_chart):
		_edit_state_chart(new_state_chart)
	get:
		return _state_chart

func _edit_state_chart(new_state_chart) -> void:
	_state_chart = new_state_chart
	for guard in guards:
		guard.state_chart = state_chart


## Called when the Node enters the SceneTree
func _ready() -> void:
	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exiting_tree)
	child_order_changed.connect(_on_tree_changed)
	update_configuration_warnings()

## Called when this node gets a new Child
func _on_child_entered_tree(node) -> void:
	if node is TransitionGuard:
		_add_guard(node)
	update_configuration_warnings()

## Called when this node loses a Child
func _on_child_exiting_tree(node) -> void:
	if node is TransitionGuard:
		_remove_guard(node)
	update_configuration_warnings()

## Called when SceneTree has changed
func _on_tree_changed() -> void:
	update_configuration_warnings()

## Check if received Event is the same as the Trigger of this Transition
func on_event_received(event:StringName) -> void:
	if event == trigger:
		try_transition()

## Check all Guards if they are statisfied. If they are, signal that transition is possible
func try_transition() -> void:
	for guard:TransitionGuard in guards:
		if !guard.is_statisfied():
			return
	emit_signal("transition_possible", self)

## Get all current guards of this Transition
func _add_all_guards() -> void:
	for child in get_children():
		if child is TransitionGuard:
			_cached_guards.append(child)

## Add a new guard 
func _add_guard(guard:TransitionGuard):
	_cached_guards.append(guard)
	update_configuration_warnings()
	
## Remove a guard 
func _remove_guard(guard:TransitionGuard):
	_cached_guards.erase(guard)
	update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	if get_parent() is not StateChartState:
		warnings.append("This Node should only be the child of StateChartStates.")

	if to:
		if get_parent().get_parent() != to.get_parent():
			warnings.append("Trying to transition to a State that is not part of the same ParentState")
		if to == get_parent():
			warnings.append("Transitioning to own State.")
	else:
		warnings.append("Transition not configured: No State to transition to set.")
	return warnings
