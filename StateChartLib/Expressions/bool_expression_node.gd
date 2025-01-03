@icon("res://StateChartLib/Icons/BoolExpression.svg")
extends ExpressionNode
class_name BoolExpressionNode

@export var value:bool:
	set(new_value):
		set_value(new_value)
	get():
		return get_value()

func get_value():
	return value

func set_value(new_value):
	value = new_value
	super.set_value(new_value)
