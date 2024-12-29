@icon("res://StateChartLib/Icons/ExpressionManager.svg")
@tool
extends Node
class_name ExpressionManager

const PROPERTY_PREFIX := "_"


@export_group("Settings")
# TODO Change to custom Resource
@export var predefined_expressions:Dictionary
var expressions: Array[ExpressionNode] = []
#@export_group("", "")

func _ready() -> void:
	_all_children_to_properties()

func _add_predefined_expressions() -> void:
	#TODO
	pass

func _all_children_to_properties() -> void:
	expressions.clear()
	for child in get_children():
		if child is ExpressionNode:
			expressions.append(child)
	notify_property_list_changed()

func _get_property_list() -> Array[Dictionary]:
	var props: Array[Dictionary] = []
	props.append({
		"name": "Expressions",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_CATEGORY
	})
	
	for expression in expressions:
		props.append({
			"name": PROPERTY_PREFIX + expression.name,
			"type": typeof(expression.value),
			"usage": PROPERTY_USAGE_DEFAULT,
		})
	return props

func _get(property: StringName) -> Variant:
	if is_inside_tree():
		if property.begins_with(PROPERTY_PREFIX):
			var expression_name := property.substr(1)
			var expression := find_child(expression_name, true, false) as ExpressionNode
			if expression:
				return expression.value
	return null

func _set(property: StringName, value: Variant) -> bool:
	if is_inside_tree():
		if property.begins_with(PROPERTY_PREFIX):
			var expression_name := property.substr(1)
			var expression := find_child(expression_name, true, false) as ExpressionNode
			if expression:
				if expression.has_method("set") or "value" in expression:
					expression.value = value
					return true
				else:
					push_warning("Expression '%s' doesn't have a 'value' property." % expression_name)
			else:
				push_warning("Expression '%s' not found." % expression_name)
	return false
