extends Node

var current_checkpoint : Checkpoint

var player : Player

signal gained_coins(int)
var coins = 0

#respawns the player at the current checkpoint
func respawn_player():
	if current_checkpoint != null:
		player.position = current_checkpoint.position

#adds coins to the player's counter
func gain_coins(coins_gained:int):
	coins += coins_gained
	emit_signal("gained_coins", coins_gained)
