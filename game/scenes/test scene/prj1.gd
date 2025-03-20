extends Area2D

var speed: float = 300.0  # Скорость снаряда
var target_position: Vector2 = Vector2.ZERO  # Целевая позиция
var direction: Vector2 = Vector2.ZERO  # Направление движения
var is_moving: bool = false  # Флаг, указывающий, движется ли снаряд

func _physics_process(delta: float) -> void:
	if is_moving:
		# Двигаем снаряд в направлении цели
		var velocity = direction * speed
		var collision = move_and_collide(velocity * delta)
		
		# Если снаряд достиг цели или столкнулся с чем-то
		if collision or position.distance_to(target_position) < 5:
			is_moving = false
			queue_free()  # Удаляем снаряд после достижения цели

func set_target(target: Vector2) -> void:
	target_position = target
	direction = (target_position - global_position).normalized()
	is_moving = true
	rotation = direction.angle()  # Поворачиваем снаряд в направлении цели
