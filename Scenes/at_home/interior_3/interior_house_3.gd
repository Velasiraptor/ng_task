extends StaticBody2D

var main_scene: PackedScene = load("res://Scenes/Game/game.tscn") # Главная сцена - улица

@onready var player = %Player

# используемые предметы обязательно добавляь к данному узлу как дочерние
@onready var items_select = %Items_select 


func _ready():
	player.state = Globals.state_player
	for i in items_select.get_children(): # пересчитывает все предметы
		if i.name in Globals.items_in_house_3: # если есть в списке ранее взятых, то удаляет
			i.queue_free()


func _on_detecter_player_body_entered(body):  # выход из дома
	get_tree().change_scene_to_packed.bind(main_scene).call_deferred()


func change_item_delete(name_delete_item): # добавление предметов в список уже примененных
	Globals.items_in_house_3.append(name_delete_item)
