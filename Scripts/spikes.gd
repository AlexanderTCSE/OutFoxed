extends Node2D

#gets the parent of the area that enters it, if the parent is the player, kill them with hammers
func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		area.get_parent().die()
