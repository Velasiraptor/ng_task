extends Sprite2D

@export var text_item: String ## Текст отображаемый при нажатии на "E"

func _on_detector_player_area_body_entered(body):
	body.player_in_object = true

func _on_detector_player_area_body_exited(body):
	body.player_in_object = false

func change_text():
	get_tree().call_group("HUD", "changing_the_text", text_item)
