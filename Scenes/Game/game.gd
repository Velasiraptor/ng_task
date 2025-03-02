extends Node2D

## Для настройки начальных значений игрока и домов, зайдите в скрипт "Globals", в папке "Scripts"
## Для расставления интерактивных предметов, дублируйте их через редактор сцены в родителе Items_select

@onready var player = %Player
@onready var house_1 = %house_1
@onready var house_2 = %house_2
@onready var house_3 = %house_3

# Используемые предметы ОБЯЗАТЕЛЬНО добавляь к данному узлу как дочерние
@onready var items_select = %Items_select


func _ready():
	restart()


func restart(): # для сброса
	player.position = Globals.position_player # Принимает "сохраненную" позицию
	
	# принимают сохраненные состояния дверей домов
	house_1.open = Globals.house_open_1
	house_2.open = Globals.house_open_2
	house_3.open = Globals.house_open_3
	
	for i in items_select.get_children(): # пересчитывает все предметы
		if i.name in Globals.items_in_main_scene: # если есть в списке ранее взятых, то удаляет
			i.queue_free()


func change_item_delete(name_delete_item): # добавление предметов в список уже примененных
	Globals.items_in_main_scene.append(name_delete_item)
