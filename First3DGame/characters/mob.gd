extends CharacterBody3D

signal squashed

@export var min_speed = 10

@export var max_speed = 18

func _physics_process(delta):
	move_and_slide()

func start_movement_enemy(start_position, player_position):
	# El enemigo mira al jugador
	look_at_from_position(start_position, player_position, Vector3.UP)
	# Rotamos al enemigo ligeramente para que no vaya en linea recta al jugador
	rotate_y(randf_range(-PI / 4, PI / 4)) # Entre -45 y 45 grados
	
	# Damos un numero entero aleatorio
	var random_speed = randi_range(min_speed, max_speed)
	# Calculamos la velocidad en linea recta
	velocity = Vector3.FORWARD * random_speed
	# Y tenemos en cuenta la direccion del enemigo
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func squash():
	squashed.emit()
	queue_free()

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
