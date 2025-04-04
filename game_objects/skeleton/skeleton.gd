extends CharacterBody2D

var speed = 50


func _process(delta):
	var direction = get_direction_to_player()
	velocity = speed * direction
	move_and_slide()

func get_direction_to_player():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player != null: 
		return (player.global_position - global_position).normalized()
	return Vector2.ZERO


func _on_area_2d_area_entered(area):
	queue_free() 
