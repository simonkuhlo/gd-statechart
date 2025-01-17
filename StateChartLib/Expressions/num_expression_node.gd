@icon("res://StateChartLib/Icons/NumericExpression.svg")
extends ExpressionNode
class_name NumericalExpressionNode

@export var value:float:
	set(new_value):
		set_value(new_value)
	get():
		return get_value()

func get_value():
	return value

func set_value(new_value):
	value = new_value
	super.set_value(new_value)
