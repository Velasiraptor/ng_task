extends CharacterBody2D

enum State {
	LEFT, 
	RIGHT, 
	UP, 
	DOWN,
	START,
	}

const SPEED: int = 300.0

var state = State.DOWN

# Если не добавить данную переменную и не вызвать
# стартовую анимацию, то будет проскакивать один ненужный кадр
var start_frame := ["left", "right", "up", "down"] 
var player_in_object := false

@onready var player_sprite = %player_sprite
@onready var ray_casts = %RayCasts # Детектор предметов
@onready var ray_cast_item = %RayCast_item
@onready var ray_cast_item_2 = %RayCast_item2
@onready var ray_cast_item_3 = %RayCast_item3
@onready var fall = %Fall
@onready var label_e = %Label_E


func _ready():
	restart()

func _process(delta):
	if fall.visible == false:
		# Изменение состояния, в зависимости от нажатой клавиши
		if Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
			change_state(State.LEFT)
		
		elif Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
			change_state(State.RIGHT)
		
		elif Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_up"):
			change_state(State.DOWN)
		
		elif Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down"):
			change_state(State.UP)
		
		state_machine() # МАШИНА СОСТОЯНИЙ
		move() # ДВИЖЕНИЕ
		take_static_item() # обнаружение предметов


func restart():
	fall.visible = false
	## Если раскомментировать код ниже, 
	##то и направление персонажа не будет сбрасываться при входе в интерьер
	#player_sprite.play(start_frame[Globals.state_player]) # стартовый кадр
	#state = Globals.state_player # стартовое состояние
	
	# сброс взгляда при входе в интерьер, нужно закомментировать, если код выше включен
	change_state(State.START) 


func move(): # ДВИЖЕНИЕ
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * SPEED
	move_and_slide()


func change_state(new_state: State): # ПЕРЕКЛЮЧЕНИЕ СОСТОЯНИЯ
	state = new_state 
	Globals.state_player = new_state


func state_machine(): # МАШИНА СОСТОЯНИЙ
	match state:
		# Состояние когда смотрит навлево
		State.LEFT: 
			player_sprite.play("left")
			ray_casts.rotation_degrees = 90
		# Состояние когда смотрит направо
		State.RIGHT:
			player_sprite.play("right")
			ray_casts.rotation_degrees = -90
		# Состояние когда смотрит вверх
		State.UP:  
			player_sprite.play("up")
			ray_casts.rotation_degrees = 180
		# Состояние когда смотрит вниз
		State.DOWN:  
			player_sprite.play("down")
			ray_casts.rotation_degrees = 0
		# Стартовое состояние, смотрит вниз
		State.START:
			player_sprite.play("down")
			ray_casts.rotation_degrees = 0


func plus_actual_hp(): # + 1 текущее здоровье
	if Globals.actual_HP < Globals.max_HP:
		Globals.actual_HP += 1
		get_tree().call_group("HUD", "get_hp") # Меняем пареметры здоровья в HUD


func plus_max_1_hp(): # + 1 текущее и + 1 макс здоровье
	Globals.max_HP += 1
	Globals.actual_HP += 1
	get_tree().call_group("HUD", "get_hp") # Меняем пареметры здоровья в HUD


func minus_actual_hp(): # - 1 текущее здоровье
	if Globals.actual_HP <= Globals.max_HP:
		Globals.actual_HP -= 1
		get_tree().call_group("HUD", "get_hp") # Меняем пареметры здоровья в HUD
	if Globals.actual_HP == 0:
		fall.visible = true
		get_tree().call_group("HUD", "get_hp") # Меняем пареметры здоровья в HUD
		await get_tree().create_timer(2.0).timeout
		Globals.game_restart()


func may_be_die(): # эффект от оливок
	if Globals.max_HP <= 10: 
		Globals.actual_HP = 0
		Globals.max_HP -= 10
		fall.visible = true
		get_tree().call_group("HUD", "get_hp") # Меняем пареметры здоровья в HUD
		await get_tree().create_timer(2.0).timeout
		Globals.game_restart()
	else:
		var remains: int
		remains = Globals.max_HP - Globals.actual_HP
		Globals.actual_HP = 10 - remains
		Globals.max_HP -= 10
		if Globals.actual_HP <= 0: # Если нынешнее здоворье ниже или равно нулю
			fall.visible = true
			get_tree().call_group("HUD", "get_hp") # Меняем пареметры здоровья в HUD
			await get_tree().create_timer(2.0).timeout
			Globals.game_restart()
		if Globals.actual_HP > Globals.max_HP: # Если нынешнее здоворье вышло больше чем максимальное
			Globals.actual_HP = Globals.max_HP
			get_tree().call_group("HUD", "get_hp") # Меняем пареметры здоровья в HUD


func plus_key(): # эффект ключа
	Globals.count_key_bag += 1
	get_tree().call_group("HUD", "get_key") # Меняем пареметры ключей в HUD


func take_static_item():
	if ray_cast_item.is_colliding():
		ray_cast_name(ray_cast_item)
	elif ray_cast_item_2.is_colliding():
		ray_cast_name(ray_cast_item_2)
	elif ray_cast_item_3.is_colliding():
		ray_cast_name(ray_cast_item_3)
	else:
		label_e.visible = false


# использование детектора на интерактивные предметы
#сделан для добавления любого кол-ва лучей
func ray_cast_name(ray):
	if player_in_object == true:
		if ray.get_collider().get_parent().has_method("change_text"):
			label_e.visible = true
			if Input.is_action_just_pressed("take_object"):
				ray.get_collider().get_parent().change_text()
				get_tree().call_group("HUD", "visible_text_HUD")
				player_in_object = false
				await get_tree().create_timer(0.1).timeout
				player_in_object = true
