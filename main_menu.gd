extends Control

func _ready():
	# Connect button signals safely
	var play_btn = $PlayButton
	var how_to_play_btn = $HowToPlayButton
	
	if not play_btn.pressed.is_connected(_on_play_button_pressed):
		play_btn.pressed.connect(_on_play_button_pressed)
	
	if not how_to_play_btn.pressed.is_connected(_on_how_to_play_button_pressed):
		how_to_play_btn.pressed.connect(_on_how_to_play_button_pressed)

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://story_intro.tscn")

func _on_how_to_play_button_pressed():
	get_tree().change_scene_to_file("res://how_to_play.tscn")
