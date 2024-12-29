extends Node2D

var direction_to_mouse = "left"
@export var movement_info:ExpressionManager

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var object_pos = self.global_position
	look_at(mouse_pos)
	if mouse_pos.x < object_pos.x:
		if ! direction_to_mouse == "left":
			direction_to_mouse = "left"
			movement_info._DirToMouse = direction_to_mouse
	elif mouse_pos.x > object_pos.x:
		if ! direction_to_mouse == "right":
			direction_to_mouse = "right"
			movement_info._DirToMouse = direction_to_mouse
