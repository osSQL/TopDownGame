extends CharacterBody2D

var max_speed = 125
var acceleration = 0.15

func _process(delta):
	var direction = movement_vector().normalized()
	var targer_velocity = max_speed *  direction
	
	velocity = velocity.lerp(targer_velocity,acceleration)
	move_and_slide()
	


func movement_vector():
	var  movement_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var  movement_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(movement_x,movement_y)
	
