extends CharacterBody2D

@export var speed = 350
@export var jump_force = 500
@export var gravity = 15

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_force
	
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	
	velocity.x = horizontal_direction * speed
	
	move_and_slide()
