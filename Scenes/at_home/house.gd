extends StaticBody2D

## Экстерьер.
## Выбрав сцену для 'interior' в инспекторе, 
## подходя к входу и имея ключ - игрок переносится в выбранную сцену. 

@export var interior: PackedScene = load("res://Scenes/at_home/interior_1/interior_house_1.tscn") ## Выбираем один из интерьеров
@export var number_house: int = 1 ## Нужно выбрать от 1 до 3 дома, для правильного сохранения состояния двери

var open := false # Флаг для входа в дом

@onready var player_position = %Player_position
@onready var door = %Door


func _ready():
	restart()

func restart(): # Для сброса
	# Берем сохраненное состояние двери
	if number_house == 1:
		open = Globals.house_open_1
	elif number_house == 2:
		open = Globals.house_open_2
	elif number_house == 3:
		open = Globals.house_open_3
	
	# Меняем спрайт двери на соответствующий
	if open:
		door.play("open")
	else:
		door.play("close")


func _on_detecter_player_body_entered(body): # Детектор на вход игрока в выбранный интерьер
	if open: # Если открыт
		Globals.position_player = player_position.global_position # Присваиваем игроку новую позицию при выходе
		get_tree().change_scene_to_packed.bind(interior).call_deferred()
	else:
		if Globals.count_key_bag > 0:
			get_tree().call_group("HUD", "visible_key_menu", $".")


func _on_detecter_player_body_exited(body): # Выход от экстерьера
	get_tree().call_group("HUD", "not_visible_key_menu")


func open_door(house_parent): # Открытие двери ключем, принимает узел актуального дома
	if house_parent == $".":
		if Globals.count_key_bag > 0:
			# Берем сохраненное состояние двери
			if house_parent.number_house == 1:
				Globals.house_open_1 = true
				Globals.count_key_bag -= 1
				open = true
			elif house_parent.number_house == 2:
				Globals.house_open_2 = true
				Globals.count_key_bag -= 1
				open = true
			elif house_parent.number_house == 3:
				Globals.house_open_3 = true
				Globals.count_key_bag -= 1
				open = true
			Globals.position_player = house_parent.player_position.global_position # Присваиваем игроку новую позицию при выходе
			get_tree().change_scene_to_packed.bind(house_parent.interior).call_deferred()


func close_door(): # Меняем состояние дома 'закрыто'
	open = false
	door.play("close")
