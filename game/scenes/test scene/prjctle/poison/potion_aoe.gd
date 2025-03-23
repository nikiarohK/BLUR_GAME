extends Node2D
@export var duartion = 1.0
@onready var reload_timer: Timer = $Timer
func _ready():
	# Подключаем сигнал таймера к функции
	reload_timer.wait_time = duartion
	reload_timer.start()
	$Timer.timeout.connect(_on_Timer_timeout)
func _on_Timer_timeout():
	# Удаляем объект или делаем его невидимым
	queue_free()  # Удаляет объект из сцены
	# Или, если хотите сделать объект невидимым:
	# visible = false


func _on_potion_aoe_area_entered(area: Area2D) -> void:
	if area.is_in_group('fireAOE'):
		var aoe = preload("res://scenes/test scene/prjctle/fire/fire_AOE.tscn").instantiate()
		aoe.position = global_position
		get_parent().add_child(aoe)
		queue_free()
	if area.is_in_group('iceAOE'):
		var aoe = preload("res://scenes/test scene/prjctle/ice/ice_AOE.tscn").instantiate()
		aoe.position = global_position
		get_parent().add_child(aoe)
		queue_free()
