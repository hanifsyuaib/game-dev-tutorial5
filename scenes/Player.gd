extends CharacterBody2D

@export var gravity = 500.0
@export var walk_speed = 200
@export var jump_speed = -300
@export var dash_speed = 500  
@export var dash_duration = 0.5  
@export var dash_cooldown = 1 
@export var crouch_speed = 100

var jump_count = 0
var max_jumps = 2

var is_dashing = false
var dash_time_left = 0
var dash_direction = 0
var last_input = ""
var last_input_time = 0
var double_tap_time = 0.3

var is_crouching = false

@onready var sprite = $Sprite2D 

func _physics_process(delta):
	velocity.y += delta * gravity
	
	if is_on_floor():
		jump_count = 0  
		
	if Input.is_action_just_pressed('ui_up') and jump_count < max_jumps and not is_crouching:
		velocity.y = jump_speed
		jump_count += 1
	
	if is_dashing:
		dash_time_left -= delta
		if dash_time_left <= 0:
			is_dashing = false 
	
	handle_crouching()
	handle_dash_input()
	
	if is_dashing:
		velocity.x = dash_speed * dash_direction 
	else:
		if is_crouching:
			if Input.is_action_pressed("ui_left"):
				velocity.x = -crouch_speed
				sprite.flip_h = true
			elif Input.is_action_pressed("ui_right"):
				velocity.x =  crouch_speed
				sprite.flip_h = false
			else:
				velocity.x = 0
		else:
			if Input.is_action_pressed("ui_left"):
				velocity.x = -walk_speed
				sprite.flip_h = true
			elif Input.is_action_pressed("ui_right"):
				velocity.x =  walk_speed
				sprite.flip_h = false
			else:
				velocity.x = 0
				
	# "move_and_slide" already takes delta time into account.
	move_and_slide()

func handle_dash_input():
	var current_time = Time.get_ticks_msec() / 1000.0

	if Input.is_action_just_pressed("ui_left"):
		if last_input == "left" and (current_time - last_input_time) < double_tap_time:
			start_dash(-1)
		last_input = "left"
		last_input_time = current_time

	elif Input.is_action_just_pressed("ui_right"):
		if last_input == "right" and (current_time - last_input_time) < double_tap_time:
			start_dash(1)
		last_input = "right"
		last_input_time = current_time

func start_dash(direction):
	if not is_dashing:  
		is_dashing = true
		dash_time_left = dash_duration
		dash_direction = direction

func handle_crouching():
	if Input.is_action_pressed("ui_down") and is_on_floor():
		is_crouching = true
		sprite.texture = preload("res://assets/kenney_platformercharacters/PNG/Zombie/Poses/zombie_duck.png")
	else:
		is_crouching = false
		sprite.texture = preload("res://assets/kenney_platformercharacters/PNG/Zombie/Poses/zombie_stand.png")
