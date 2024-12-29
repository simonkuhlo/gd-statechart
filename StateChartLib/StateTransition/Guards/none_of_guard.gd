@icon("res://StateChartLib/Icons/NoneOfGuard.svg")
@tool
extends ParentGuard
class_name NoneOfGuard

func is_statisfied() -> bool:
	for child_guard in child_guards:
		if child_guard.is_statisfied():
			return false
	return true
