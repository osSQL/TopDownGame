extends CharacterBody2D

@onready var health_component = $health_component
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var movement_component = $MovementComponent

@export var death_scene: AnimatedSprite2D
func _ready():
	health_component.died.connect(on_died)

func _process(delta):
	var direction = movement_component.get_direction()
	movement_component.move_to_player(self)
	
	if direction.x != 0 || direction.y != 0:
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	
	var face_sign = sign(direction.x)
	if face_sign != 0:
		animated_sprite_2d.scale.x = face_sign



func on_died():	
	
	queue_free()
