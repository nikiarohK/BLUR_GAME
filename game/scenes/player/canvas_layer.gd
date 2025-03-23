extends CanvasLayer

# Ссылка на персонажа (передайте его через редактор или код)
@export var character: NodePath

# Функция для отображения/скрытия интерфейса
func toggle_interface():
	$Panel.visible = not $Panel.visible

# Обработка нажатий на кнопки
func _on_button_pressed(button_index: int):
	var character_node = get_node(character)
	if character_node:
		character_node.set_projectile(button_index)  # Вызов функции персонажа
	toggle_interface()  # Скрыть интерфейс после выбора

# Подключение сигналов кнопок
func _ready():
	$Panel/Button1.connect("pressed", self._on_button_pressed.bind(1))
	$Panel/Button2.connect("pressed", self._on_button_pressed.bind(2))
	$Panel/Button3.connect("pressed", self._on_button_pressed.bind(3))
	$Panel/Button4.connect("pressed", self._on_button_pressed.bind(4))
	$Panel/Button5.connect("pressed", self._on_button_pressed.bind(5))
