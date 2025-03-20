extends Node2D

func _ready():
	# Подключаем сигнал таймера к функции
	$Timer.timeout.connect(_on_Timer_timeout)

func _on_Timer_timeout():
	# Удаляем объект или делаем его невидимым
	queue_free()  # Удаляет объект из сцены
	# Или, если хотите сделать объект невидимым:
	# visible = false
