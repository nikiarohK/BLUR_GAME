extends CharacterBody2D
var direction: Vector2 = Vector2()
@export var speed = 100.0
@export var range = 200.0
@export var dash_speed: float = 600.0  # Скорость рывка
@export var dash_duration: float = 0.2  # Длительность рывка
@export var dash_cooldown: float = 1.0  # Кулдаун рывка
@export var reload_time: float = 0.5  # Время перезарядки
@export var projectile_type = 1

var can_shoot: bool = true  # Может ли персонаж стрелять
var is_dashing: bool = false
var can_dash: bool = true
var is_ui:bool = true
var dash_direction: Vector2 = Vector2.ZERO

@onready var reload_timer: Timer = $prjct_rel


func set_projectile(value: int):
	projectile_type = value
	print("Выбрано значение: ", projectile_type)




func _ready():
	reload_timer.wait_time = reload_time
	
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	if multiplayer.get_unique_id() == $MultiplayerSynchronizer.get_multiplayer_authority():
		$Camera2D.make_current()
	else:
		$Camera2D.enabled = false
		

func _enter_tree():
	set_multiplayer_authority(name.to_int())
	
func ui_toggle():
	$Panel.visible = not $Panel.visible
	is_ui = not is_ui

func read_input():
	velocity = Vector2()
	if Input.is_action_just_pressed('projectile_chose'):
		ui_toggle()
	if Input.is_action_just_released('projectile_chose'):
		ui_toggle()
	if Input.is_action_pressed('right'):
		velocity.x += 1
		direction = Vector2(1,0)
	if Input.is_action_pressed('left'):
		velocity.x -= 1
		direction = Vector2(-1,0)
	if Input.is_action_pressed('down'):
		velocity.y += 1
		direction = Vector2(0,1)
	if Input.is_action_pressed('up'):
		velocity.y -= 1
		direction = Vector2(0,-1)
	if Input.is_action_just_pressed('dash') and can_dash and direction != Vector2.ZERO:
		start_dash(direction)
	if is_dashing:
		velocity = dash_direction * dash_speed
	else:
		velocity = velocity.normalized() * speed
	
	
	
	
	if Input.is_action_pressed('shoot'):
		if is_ui:
			var max_range = range
			var mouse_position = get_global_mouse_position()
			var player_position = global_position
			var direction = (mouse_position - global_position).normalized()
			var distance = player_position.distance_to(mouse_position)
			if distance <= max_range:
				shoot.rpc(direction, distance)
			else:
				shoot.rpc(direction, max_range)
		else:
			pass
	
	
	
@rpc("any_peer", "call_local")
func shoot(direction: Vector2, distance: float) -> void:
	if not can_shoot:
		return
	if multiplayer.is_server():
		spawn_bullet.rpc(direction, distance, global_position)

	start_reload()
@rpc("any_peer", "call_local")
func spawn_bullet(direction: Vector2, distance: float, position: Vector2) -> void:
	var bullet = preload("res://scenes/test scene/prjctle/poison/projectile1.tscn").instantiate()
	match projectile_type:
		1:
			bullet = preload("res://scenes/test scene/prjctle/fire/fire_prjct.tscn").instantiate()
		2:
			bullet = preload("res://scenes/test scene/prjctle/ice/ice_prjct.tscn").instantiate()
		_:
			bullet = preload("res://scenes/test scene/prjctle/poison/projectile1.tscn").instantiate()
			
	bullet.direction = direction.normalized()  # Устанавливаем направление
	bullet.max_distance = distance  # Устанавливаем дальность
	bullet.position = global_position  # Позиция выстрела (например, позиция игрока)
	get_parent().add_child(bullet)  # Добавляем снаряд на сцену
	
func start_reload() -> void:
	can_shoot = false
	reload_timer.start()

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		read_input()
	move_and_slide()

func _on_prjct_rel_timeout() -> void:
	can_shoot = true

func _process(delta: float) -> void:
	if not can_shoot:
		update_reload_indicator()

func update_reload_indicator() -> void:
	var time_left = reload_timer.time_left
	var progress = 1.0 - (time_left / reload_time)  # Прогресс от 0 до 1
	
func start_dash(direction: Vector2):
	is_dashing = true
	can_dash = false
	dash_direction = direction
	# Запускаем таймер длительности рывка
	await get_tree().create_timer(dash_duration).timeout
	end_dash()

	# Запускаем таймер кулдауна
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true

func end_dash():
	is_dashing = false
	velocity = Vector2.ZERO  # Сбрасываем скорость после рывка
	


func _on_button_1_pressed() -> void:
	projectile_type = 1


func _on_button_2_pressed() -> void:
	projectile_type = 2


func _on_button_3_pressed() -> void:
	projectile_type = 3


func _on_button_4_pressed() -> void:
	pass # Replace with function body.


func _on_button_5_pressed() -> void:
	pass # Replace with function body.
