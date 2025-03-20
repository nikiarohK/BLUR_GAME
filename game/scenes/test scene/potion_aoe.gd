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
