extends Tree

@export var root:Control
@onready var state_to_watch:StateChartState = root.state_to_watch

@export var settings:Control
var tick_counter:int = 1

func _ready():
	create_tree()

func _process(delta):
	if tick_counter >= settings.update_after_ticks:
		create_tree() #TODO Could be fine-tuned 
		tick_counter = 0
	tick_counter += 1

func create_tree():
	clear()
	var root:TreeItem = create_item()
	root.set_text(0, state_to_watch.name + " (" + str(state_to_watch.get_script().get_global_name()) + ")")
	if state_to_watch is ParentState:
		add_all_subchildren(state_to_watch, root)

func add_all_subchildren(state:ParentState, tree_parent:TreeItem):
	for child in state.get_children():
		if child is StateChartState:
			if !child.active:
				continue
			var new_tree_item = create_item(tree_parent)
			new_tree_item.set_expand_right(0, true)
			new_tree_item.set_text(0, child.name + " (" + str(child.get_script().get_global_name()) + ")")
			for transition in child.transition_queue.queued_transitions:
				if transition:
					var new_transition_tree_item = create_item(new_tree_item)
					new_transition_tree_item.set_text(0, transition.transition.name + " -> " + transition.transition.to.name + " [" + str(transition.timer.time_left).pad_decimals(2) + "]")
			if child is ParentState:
				add_all_subchildren(child, new_tree_item)
