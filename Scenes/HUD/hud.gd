extends Control

@onready var hp = %HP
@onready var keys = %Keys
@onready var text_hud = %text_HUD
@onready var timer_text = %Timer_text
@onready var key_menu = %Key_menu

var house_parent # Используется для правильного использования открытия дверей


func _ready():
	restart()


func restart(): # Для сброса
	text_hud.visible = false
	key_menu.visible = false
	get_hp()
	get_key()


func get_hp(): # Обновляет параметры здоровья в HUD
	hp.text = "HP " + str(Globals.actual_HP) + "/" + str(Globals.max_HP)


func get_key(): # Обновляет параметры ключей в HUD
	keys.text = "Ключи " + str(Globals.count_key_bag)


func _on_button_exit_pressed(): # Кнопка выхода
	get_tree().quit()


func _on_button_restart_pressed(): # Кнопка перезапуска
	Globals.game_restart()


func changing_the_text(text_item: String): # Изменение текста в HUD
	text_hud.text = text_item

func visible_text_HUD():
	timer_text.stop()
	text_hud.visible = true
	timer_text.start()


func _on_timer_text_timeout(): # Таймер для скрытия текста
	text_hud.visible = false


func visible_key_menu(house): # Включение меню выбора "потратить ли ключ", принимает узел дома, в которого входит
	key_menu.visible = true
	house_parent = house


func not_visible_key_menu(): # Выключение меню выбора "потратить ли ключ"
	key_menu.visible = false


func _on_button_yes_pressed(): # Используем ключ
	get_tree().call_group("House", "open_door", house_parent)


func _on_button_no_pressed(): # Не используем ключ
	key_menu.visible = false
