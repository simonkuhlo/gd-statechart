@icon("res://StateChartLib/Icons/TransitionGuard.svg")
@tool
extends TransitionGuard
class_name ParentGuard


## Private variable, use "child_guards"
var _cached_child_guards:Array[TransitionGuard] = []

## Array of Guards this State currently has
var child_guards: Array[TransitionGuard]:
	get:
		if _cached_child_guards.is_empty():
			_add_all_child_guards()
		return _cached_child_guards

func _edit_state_chart(new_state_chart) -> void:
	super._edit_state_chart(new_state_chart)
	for child in child_guards:
		child.state_chart = new_state_chart

## Get all current guards of this Transition
func _add_all_child_guards() -> void:
	for child in get_children():
		if child is TransitionGuard:
			_cached_child_guards.append(child)

## Called when the Node enters the SceneTree
func _ready() -> void:
	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exiting_tree)
	child_order_changed.connect(_on_tree_changed)
	update_configuration_warnings()

## Called when this node gets a new Child
func _on_child_entered_tree(node) -> void:
	if node is TransitionGuard:
		_add_child_guard(node)
	update_configuration_warnings()

## Called when this node loses a Child
func _on_child_exiting_tree(node) -> void:
	if node is TransitionGuard:
		_remove_child_guard(node)
	update_configuration_warnings()

## Called when SceneTree has changed
func _on_tree_changed() -> void:
	update_configuration_warnings()

## Add a new guard 
func _add_child_guard(guard:TransitionGuard):
	_cached_child_guards.append(guard)
	update_configuration_warnings()
	
## Remove a guard 
func _remove_child_guard(guard:TransitionGuard):
	_cached_child_guards.erase(guard)
	update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if child_guards.is_empty():
		warnings.append("This parent guard has no child guards.")
	return warnings
