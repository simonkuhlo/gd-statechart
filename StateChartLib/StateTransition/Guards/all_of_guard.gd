@icon("res://StateChartLib/Icons/AllOfGuard.svg")
@tool
extends ParentGuard
class_name AllOfGuard

func is_statisfied() -> bool:
	for child_guard in child_guards:
		if !child_guard.is_statisfied():
			return false
	return true
