extends Line2D

var start_pos = Vector2(0,0)
var end_pos = Vector2(0,0)

func _process(delta):
	add_point(start_pos)
	add_point(end_pos, 1)
	remove_point(0)
