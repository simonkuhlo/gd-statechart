extends Node
class_name TransitionQueue

signal transition_ready(transition:StateTransition)

## Array of Transitions this State currently has
var queued_transitions: Array[TransitionQueueItem] = []

func queue_transition(transition:StateTransition):
	for queue_item in queued_transitions:
		if transition == queue_item.transition:
			if transition.delay_seconds < queue_item.timer.time_left:
				_remove_queue_item(queue_item)
			else:
				return
	_add_queue_item(TransitionQueueItem.new(transition))


func _add_queue_item(queue_item:TransitionQueueItem):
	queue_item.connect("transition_ready", _on_transition_ready)
	queued_transitions.append(queue_item)
	add_child(queue_item)

func _remove_queue_item(queue_item:TransitionQueueItem):
	queued_transitions.erase(queue_item)
	queue_item.queue_free()

func clear_transitions():
	for queue_item in queued_transitions:
		_remove_queue_item(queue_item)

func _on_transition_ready(queue_item:TransitionQueueItem):
	emit_signal("transition_ready", queue_item.transition)
	clear_transitions()
