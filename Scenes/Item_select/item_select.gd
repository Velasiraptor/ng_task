extends Sprite2D

## Выбираем ТОЛЬКО ОДИН флаг предмета в инспекторе, сделанно, чтобы не создавать 6 сцен,
## Эффект будет срабатывать в зависимости от флага
## Также в редакторе сцены переносим нужный спрайт для предмета, также сделано чтобы не создавать 6 сцен
## Спрайты находятся в 'res://Sprites/Item_select/'

@export var apple := false
@export var key := false
@export var orange := false
@export var chilli := false
@export var olives := false
@export var alarm_potion := false

@onready var item_name_label = %item_name_label


func _ready(): # для того, чтобы не создавать 6 отдельных сцен
	if apple: 
		item_name_label.text = "Яблоко"
	
	elif key:
		item_name_label.text = "Ключ"
	
	elif orange:
		item_name_label.text = "Апельсин"
	
	elif chilli:
		item_name_label.text = "Перец чили"
	
	elif olives:
		item_name_label.text = "Оливки"
	
	elif alarm_potion:
		item_name_label.text = "Зелье сигнализации"


func _on_item_select_body_entered(body): # Эффекты от предметов
	if apple: # +1 хп
		get_tree().call_group("Player", "plus_actual_hp")
	
	elif key: # +1 ключ
		get_tree().call_group("Player", "plus_key")
	
	elif orange: # +1 хп, + 1 макс хп
		get_tree().call_group("Player", "plus_max_1_hp")
	
	elif chilli: # -1 хп
		get_tree().call_group("Player", "minus_actual_hp")
	
	elif olives: # -10 макс хп
		get_tree().call_group("Player", "may_be_die")
	
	elif alarm_potion: # запирание всех дверей домов
		get_tree().call_group("House", "close_door")
		Globals.house_open_1 = false
		Globals.house_open_2 = false
		Globals.house_open_3 = false
	
	# добавляем предмет в список взятых
	get_parent().get_parent().change_item_delete(get_parent().get_child(get_index()).name) 
	queue_free() # удаляем предмет
