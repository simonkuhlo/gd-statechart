@icon("res://StateChartLib/Icons/TransitionGuard.svg")
@tool
extends TransitionGuard
class_name StringExpressionGuard

@export var expression:StringExpressionNode
@export var compare_value:String


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
