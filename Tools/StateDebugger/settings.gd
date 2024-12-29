extends Control

var update_after_ticks:float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_update_count_text_submitted(new_text):
	update_after_ticks = new_text.to_float()
