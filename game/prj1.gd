extends Area2D  # или Area3D для 3D

# Параметры снаряда
@export var speed: float = 200  # Скорость движения
var direction: Vector2 = Vector2.RIGHT  # Направление движения
var max_distance: float = 500  # Максимальная дальность
var traveled_distance: float = 0  # Пройденное расстояние

@rpc("call_local", "any_peer")
func destroy() -> void:
	var aoe = preload("res://scenes/test scene/potion_aoe.tscn").instantiate()
	aoe.position = global_position
	get_parent().add_child(aoe)
	queue_free()

func _process(delta: float) -> void:
	# Движение снаряда
	var movement = direction * speed * delta
	position += movement
	traveled_distance += movement.length()

	# Уничтожение снаряда при достижении максимальной дальности
	if traveled_distance >= max_distance:
		destroy()  # Удаляем снаряд
