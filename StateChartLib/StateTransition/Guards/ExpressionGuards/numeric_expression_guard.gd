@icon("res://StateChartLib/Icons/TransitionGuard.svg")
@tool
extends TransitionGuard
class_name NumericExpressionGuard

@export var expression: NumericalExpressionNode
enum SYMBOL {
	IS,
	IS_NOT,
	GREATER,
	LESSER
}
@export var symbol: SYMBOL
@export var expression_value: float

func is_satisfied() -> bool:
	if not expression:
		push_warning("NumericExpressionGuard: No expression set")
		return false
	
	var current_value = expression.value
	
	match symbol:
		SYMBOL.IS:
			return is_equal_approx(current_value, expression_value)
		SYMBOL.IS_NOT:
			return not is_equal_approx(current_value, expression_value)
		SYMBOL.GREATER:
			return current_value > expression_value
		SYMBOL.LESSER:
			return current_value < expression_value
		_:
			push_warning("NumericExpressionGuard: Invalid symbol")
			return false

func _get_configuration_warning() -> String:
	if not expression:
		return "No NumericalExpressionNode set"
	return ""
