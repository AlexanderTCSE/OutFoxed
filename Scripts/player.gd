extends RigidBody2D
class_name Player

var tension = 0.01

#giant block of onready vars for important stuff
#is there a better way to do this? maybe.
#do I know it? no.
@onready var player = self
@onready var rope = $Grapple #the spring that acts as a grapple hook
@onready var ray = $RayCast2D #the aiming ray
@onready var hook = $Hook #anchor point
@onready var aimhook = $AimHook #simulated aiming hook
@onready var hooksprite = $Hook/Sprite2D #the hook tip
@onready var aimsprite = $AimHook/Sprite2D #transparent aiming hook
@onready var ropeline = $Rope #the line that gets drawn on screen
@onready var groundcheck = $GroundCheck #ray that checks for the floor
@onready var sprite = $AnimatedSprite2D #player sprite
@onready var animation = $AnimatedSprite2D #player animation controller
@onready var crosshair = $Crosshair #player crosshair
@onready var pause_menu = $Camera2D/PauseMenu #pause menu

#more utilitarian variables like move speed and speed limits
@onready var walkspeed = Vector2(200,0) #walk speed x accel
@onready var jumpheight = Vector2(0,-300) #jump speed y accel
@onready var speed_max = 200 #max speed so we don't zoom forever
@onready var jumps = 2 #double jump limiter
@onready var paused = false #starts the game unpaused, can be toggled

func _ready():
	GameManager.player = self

#this is called every physics frame, so everything in here is updated once per frame
#this MAY tank performance, but I'm really not sure
#¯\_(ツ)_/¯
func _physics_process(delta):
	crosshair.play("default") #this can probably be in the update_animation func but I'm lazy rn
	process_input() #handle player input
	set_jumps() #set no. of jumps
	update_animation() #update player sprite animation
	if position.y >= 600:
		die()

#since I'm not using a characterbody anymore, this is what checks if we're on the ground
func set_jumps():
	if groundcheck.is_colliding(): #there is a very short ray under the player, if that collides reset jumps
		jumps = 2 #double jump variable

func process_input():
	
	#aims a ray and crosshair wherever the mouse is looking
	ray.look_at(get_global_mouse_position())
	if ray.is_colliding():
		aimhook.top_level = true
		aimhook.look_at(player.global_position)
		aimsprite.visible = true
		aimsprite.play("default")
		aimhook.global_position = ray.get_collision_point()
	else:
		aimsprite.visible = false
	crosshair.global_position = get_global_mouse_position()

	#if the player clicks M1, handle grappling
	if Input.is_action_just_pressed("M1"):
		if ray.is_colliding(): #if the ray is colliding with something
			hook.top_level = true #make the hook top level, otherwise its position will be relative to parent
			hooksprite.visible = true #draw the hook sprite
			hook.global_position = ray.get_collision_point() #set the anchor to the collision point
			var ropelength = (self.position).distance_to(hook.position) #set length to distance
			rope.length = ropelength #assign length to spring
			rope.global_rotation_degrees = ray.global_rotation_degrees - 90 #adjust rotation
			rope.rest_length = ropelength * tension #assign resting length, this is what makes it act like a spring
			ropeline.start_pos = hook.global_position #set point A of drawn line
			rope.node_b = hook.get_path() #node B of spring is set to the hook's position
	if Input.is_action_pressed("M1"):
		aimsprite.visible = false
		if rope.node_a != rope.node_b:
			hooksprite.look_at(player.global_position)
			ropeline.top_level = true #make the line top level, same positioning issue
			ropeline.visible = true #make the line visible
			ropeline.end_pos = self.global_position #set point B to the player's position
	if not Input.is_action_pressed("M1"):
		ropeline.top_level = false #make the line not top level
		ropeline.visible = false #make the line invisible
		hooksprite.visible = false #erase the hook sprite
		rope.node_b = rope.node_a #set node b of grapple to node a
	
	if Input.is_action_pressed("Left") and self.linear_velocity.x < speed_max:
		sprite.scale.x = abs(sprite.scale.x) #if left, flip sprite and move player
		player.set_axis_velocity(-walkspeed)
	if Input.is_action_pressed("Right") and self.linear_velocity.x > -speed_max:
		sprite.scale.x = abs(sprite.scale.x) * -1 #if right, flip sprite the other way and move player
		player.set_axis_velocity(walkspeed)
	if Input.is_action_just_pressed("Jump") and (jumps > 0):
		jumps = jumps-1 #subtract from double jump
		player.set_axis_velocity(jumpheight) #boost y velocity
		
	if Input.is_action_just_pressed("Esc"): #esc pauses the game
		pauseMenu()
	

func pauseMenu():
	if paused: #basically a toggle switch
		pause_menu.hide() #if paused, esc hides the menu and starts time
		Engine.time_scale = 1
	else:
		pause_menu.show() #if unpaused, esc shows the menu and stops time
		Engine.time_scale = 0
	
	paused = !paused #swap value

func update_animation():
	if Input.is_action_pressed("Right") or Input.is_action_pressed("Left"): #if a or d are pressed, walk
		animation.play("Walk")
	if !Input.is_anything_pressed(): #if nothing is pressed, idle
		animation.play("Idle")
	if player.linear_velocity.y >= 1: #if y velocity is affected at all, jump
		animation.play("Jump")

func die():
	SoundFx.characterDeath()
	GameManager.respawn_player()
