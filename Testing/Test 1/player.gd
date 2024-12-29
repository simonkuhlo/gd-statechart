extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var state_chart:StateChart
@export var anim_player:AnimationPlayer
@export var texture_marker:Marker2D

@export_group("Expressions")
@export var stats:ExpressionManager
@export var movement_info:ExpressionManager

func _physics_process(delta):
	movement_info._PlayerIsGrounded = is_on_floor()
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		movement_info._PlayerDirection = direction

	if Input.is_action_just_pressed("jump"):
		state_chart.send_event("want_jump")
	if Input.is_action_just_pressed("dash"):
		state_chart.send_event("want_dash")
	move_and_slide()

func _on_airborne_physics_processing(delta):
	velocity += get_gravity() * delta

func _on_jumping_activated():
	velocity.y = -stats._JumpStrength

func _on_grounded_activated():
	pass

func _on_normal_physics_processing(delta):
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		texture_marker.scale.x = abs(texture_marker.scale.x) * direction
		anim_player.play("walk")
		velocity.x = direction * stats._Speed
	else:
		anim_player.play("idle")
		velocity.x = move_toward(velocity.x, 0, stats._Speed)

var current_dash_direction:int = 1

func _on_dashing_physics_processing(delta):
	if current_dash_direction:
		velocity.x = current_dash_direction * stats._Speed * stats._DashStrength

func _on_dashing_activated():
	current_dash_direction = 1 if movement_info._DirToMouse == "right" else -1
