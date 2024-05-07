extends Node2D

@onready var animation = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("default")

#on area entered (by player) add 10 to their coin counter and play a noise
func _on_area_2d_area_entered(area):
	GameManager.gain_coins(10)
	SoundFx.gemCollect()
	queue_free()
