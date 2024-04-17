extends CharacterBody3D

@export var SPEED: int = 2
@export var ACCEL: int = 10

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

@onready var target = $"../Target"

var ready_to_navegate: bool = false

func _physics_process(delta):
	if !ready_to_navegate: return
	
	nav_agent.target_position = target.global_position
	
	if position != nav_agent.target_position and !nav_agent.is_navigation_finished():
		var direction = Vector3()
		
		direction = nav_agent.get_next_path_position() - global_position
		direction = direction.normalized()
		
		velocity = velocity.lerp(direction * SPEED, ACCEL * delta)
		move_and_slide()

func _ready():
	call_deferred("setup_navegation")

func setup_navegation():
	await get_tree().physics_frame
	
	nav_agent.target_position = global_position
	
	ready_to_navegate = true
