extends VBoxContainer

@export var expression_manager:ExpressionManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for child in get_children():
		child.queue_free()
	for expression in expression_manager.expressions:
		var new_label = Label.new()
		new_label.text = str(expression.name + ": " + str(expression.value))
		add_child(new_label)
