extends CharacterBody2D

var _speed = 300

var _accel = 7

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var ready_to_navegate: bool = false

func _physics_process(delta):
	if !ready_to_navegate: return
	
	if Input.is_action_just_pressed("set_location"):
		nav_agent.target_position = get_global_mouse_position()
	
	# -- Desplazamiento del navegationAgent2D segun la posicion del raton en su pulsacion --
	# Para evitar que el muñecajo tiemble en el sitio, se usa la segunda condicion.
	if position != nav_agent.target_position and !nav_agent.is_navigation_finished():
		var direction = Vector3()
		
		direction = nav_agent.get_next_path_position() - global_position
		direction = direction.normalized()
	
		velocity = velocity.lerp(direction * _speed, _accel * delta)
	
		move_and_slide()
		

# Para evitar errores de inicializacion.
func _ready():
	call_deferred("setup_navegation")

# Se espera al siguiente frame de la fisica del motor.
func setup_navegation():
	await get_tree().physics_frame
	
	nav_agent.target_position = global_position
	
	ready_to_navegate = true
