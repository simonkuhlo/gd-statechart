@icon("res://StateChartLib/Icons/TransitionGuard.svg")
@tool
extends TransitionGuard
class_name BooleanExpressionGuard

@export var expression:BoolExpressionNode
@export var compare_value: bool


func is_statisfied() -> bool:
	if not expression:
		push_warning("BooleanExpressionGuard: No expression set")
		return false
	var current_value = expression.value
	if current_value == compare_value:
		return true
	return false



func _get_configuration_warning() -> String:
	if not expression:
		return "No BooleanExpressionNode set"
	return ""
