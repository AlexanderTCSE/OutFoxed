extends Node2D

func _on_area_2d_area_entered(area):
	GameManager.coins=0
	get_tree().change_scene_to_file("res://Scenes/victory_screen.tscn")
