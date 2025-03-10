extends CharacterBody2D
var direction: Vector2 = Vector2()
const speed = 300.0

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	if multiplayer.get_unique_id() == $MultiplayerSynchronizer.get_multiplayer_authority():
		$Camera2D.make_current()
	else:
		$Camera2D.enabled = false
		

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func read_input():
	velocity = Vector2()
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
	velocity = velocity.normalized() * speed
func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		read_input()
	move_and_slide()
