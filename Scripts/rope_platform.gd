extends Node2D

@onready var rope = $Rope
@onready var ropeline = $Platformline
@onready var platform = $Platform
@onready var platformjoint = $PlatformJoint
@onready var pivot = $Pivot

# Called when the node enters the scene tree for the first time.
func _ready():
	ropeline.top_level=true
	ropeline.visible=true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rope.node_b=(platform.get_path())
	ropeline.start_pos=pivot.global_position
	ropeline.end_pos=platformjoint.global_position
