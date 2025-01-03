@icon("res://StateChartLib/Icons/StrExpression.svg")
extends ExpressionNode
class_name StringExpressionNode

@export var value:StringName = "":
	set(new_value):
		set_value(new_value)
	get():
		return get_value()

func get_value():
	return value

func set_value(new_value):
	value = new_value
	super.set_value(new_value)
