extends Node

## Использование синглтона для использования сохраненных переменных
## Если меняете начальные состояния, то их аналогично нужно изменить в функции restart_parameters()

enum State {
	LEFT, 
	RIGHT, 
	UP, 
	DOWN,
	}

var state_player = State.DOWN # Начальное состояние игрока, также используется для сохранения
var position_player := Vector2(0, 350) # Начальная позиция игрока у входа к дому, также используется для сохранения

# Начальные состояния состояния дверей экстерьера, true - открыт, также используются для сохранения
var house_open_1 := false 
var house_open_2 := true
var house_open_3 := false

# ХАРАКТЕРИСТИКИ ИГРОКА
var max_HP: int = 10 # максимальное здоровье игрока, также используется для сохранения
var actual_HP: int = 10 # нынешнее здоровье игрока, также используется для сохранения
var count_key_bag: int = 0 # кол-во ключей у игрока, также используется для сохранения

var items_in_main_scene := [] # собранные предметы из главной сцены
var items_in_house_1 := [] # собранные предметы из 1 дома
var items_in_house_2 := [] # собранные предметы из 2 дома
var items_in_house_3 := [] # собранные предметы из 3 дома

var main_scene: PackedScene = preload("res://Scenes/Game/game.tscn")

func restart_parameters(): # сброс параметров по умолчанию
	state_player = State.DOWN
	position_player = Vector2(0, 350)
	house_open_1 = false
	house_open_2 = true
	house_open_3 = false
	max_HP = 10
	actual_HP = 10
	count_key_bag = 0
	items_in_main_scene = []
	items_in_house_1 = []
	items_in_house_2 = []
	items_in_house_3 = []

func game_restart():
	restart_parameters()
	get_tree().change_scene_to_packed(main_scene)
