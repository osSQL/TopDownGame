extends CharacterBody2D

var speed = 50

@onready var health_component = $health_component



func _process(delta):
	var direction = get_direction_to_player()
	velocity = speed * direction
	move_and_slide()

func get_direction_to_player():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player != null: 
		return (player.global_position - global_position).normalized()
	return Vector2.ZERO
