extends CharacterBody2D

@export var speed = 350
@export var jump_force = 500
@export var gravity = 15

var zoom_activated = false

var initial_position = 0

@onready var camera: Camera2D = $Camera2D

func _ready():
	initial_position = global_position

func _physics_process(delta):
	if Input.is_action_just_pressed("zoom_camera"):
		zoom_activated = !zoom_activated
		check_zoom()
	
	if !is_on_floor():
		velocity.y += gravity
	
	if is_on_floor() and Input.is_action_just_pressed("jump") and !zoom_activated:
		velocity.y = -jump_force
	
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	
	velocity.x = horizontal_direction * speed
	
	move_and_slide()
	

func check_zoom():
	if !zoom_activated:
		camera.zoom = Vector2(1, 1)
	else: camera.zoom = Vector2(0.5, 0.5)

func reset_position():
	global_position = initial_position
