extends CharacterBody2D

@onready var health_component = $health_component
@onready var grace_period = $GracePeriod
@onready var progress_bar = $ProgressBar
@onready var ability_manager = $ability_manager
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var movement_component = $MovementComponent



var base_speed = 0
var enemies_colliding = 0

func _ready():
	base_speed = movement_component.max_speed
	health_component.died.connect(on_died)
	health_component.health_changed.connect(on_health_changed)
	Global.ability_upgrade_added.connect(on_ability_upgrade_added)
	health_update()

func _process(delta):
	var direction = movement_vector().normalized()
	
	velocity = movement_component.accelerate_to_direction(direction)
	move_and_slide()
	
	if direction.x != 0 || direction.y != 0:
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	
	var face_sign = sign(direction.x)
	if face_sign != 0:
		animated_sprite_2d.scale.x = face_sign


func movement_vector():
	var  movement_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var  movement_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(movement_x,movement_y)
	
func check_if_damaged():
	if enemies_colliding == 0 || !grace_period.is_stopped():
		return
	health_component.take_damage(1)
	grace_period.start()
	
	
func health_update():
	progress_bar.value = health_component.get_health_value()
	
func _on_player_hurt_box_area_entered(area):
	enemies_colliding += 1
	check_if_damaged()


func _on_player_hurt_box_area_exited(area):
	enemies_colliding -= 1
	
func on_died():
	queue_free()
	
func on_health_changed():
	health_update()
	
func _on_grace_period_timeout():
	check_if_damaged()
	
func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if  upgrade is NewAbility:
		var new_ability = upgrade as NewAbility
		ability_manager.add_child(new_ability.new_ability_scene.instantiate())
	
	elif upgrade.id == "move_speed":
		movement_component.max_speed = base_speed + (base_speed * current_upgrades["move_speed"]["quantity"] * 0.1)
		
