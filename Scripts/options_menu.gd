extends Control

func _on_options_back_pressed():
	SoundFx.buttonBack()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
