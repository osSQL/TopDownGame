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

var is_dying: bool = false  # Флаг для предотвращения повторного вызова on_died()


func play_animation(animation_name: String):
	if animated_sprite_2d.sprite_frames and animated_sprite_2d.sprite_frames.has_animation(animation_name):
		animated_sprite_2d.play(animation_name)

func on_died():	
	if is_dying:
		return  # Предотвращаем повторный вызов on_died()
	is_dying = true  # Устанавливаем флаг "умирает"
	
	# Останавливаем все процессы движения и взаимодействия
	if movement_component:
		movement_component.queue_free()  # Удаляем компонент движения
	set_process(false)  # Останавливаем процесс
	set_physics_process(false)  # Останавливаем физический процесс
	
	# Воспроизводим анимацию смерти
	if animated_sprite_2d.sprite_frames and animated_sprite_2d.sprite_frames.has_animation("death"):
		animated_sprite_2d.play("death")
		await animated_sprite_2d.animation_finished  # Ждём завершения анимации
	
	
	# Если есть отдельная сцена для анимации смерти, создаем её
	if death_scene:
		var death_instance = death_scene.instance()
		death_instance.global_position = global_position
		get_parent().add_child(death_instance)
	
	# Удаляем объект после завершения анимации
	if is_instance_valid(self):  # Проверяем, что объект всё ещё существует
		queue_free()
