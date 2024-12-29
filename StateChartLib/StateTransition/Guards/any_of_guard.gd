@icon("res://StateChartLib/Icons/TransitionGuard.svg")
@tool
extends ParentGuard
class_name AnyOfGuard

func is_statisfied() -> bool:
	for child_guard in child_guards:
		if child_guard.is_statisfied():
			return true
	return false
