extends Control

@onready var main = $"../../"

func _on_resume_pressed():
	SoundFx.buttonClick()
	main.pauseMenu()

func _on_quit_pressed():
	SoundFx.buttonBack()
	get_tree().quit()
