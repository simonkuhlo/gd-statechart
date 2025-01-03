@icon("res://StateChartLib/Icons/AnyExpression.svg")
extends Node
class_name ExpressionNode

## Not implemented yet.
signal expression_value_changed(new_value)

func get_value():
	push_error("Tried to call interface function. Forgot to overwrite?")

func set_value(new_value):
	expression_value_changed.emit(new_value)
