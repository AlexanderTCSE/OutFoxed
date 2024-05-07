extends Control

func _ready():
	SoundFx.victoryMusic()

func _on_new_game_pressed():
	GameManager.coins=0
	SoundFx.newGame()
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_quit_pressed():
	GameManager.coins=0
	SoundFx.buttonBack()
	get_tree().quit()
