extends CharacterBody2D

var speed = 50

@onready var health_component = $health_component
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	health_component.died.connect(on_died)

func _process(delta):
	var direction = get_direction_to_player()
	velocity = speed * direction
	move_and_slide()
	if direction.x != 0 || direction.y != 0:
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	
	var face_sign = sign(direction.x)
	if face_sign != 0:
		animated_sprite_2d.scale.x = face_sign

func get_direction_to_player():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player != null: 
		return (player.global_position - global_position).normalized()
	return Vector2.ZERO

func on_died():
	queue_free()
