extends CharacterBody3D

signal hit

# La velocidad del jugador
@export var speed = 14
# La aceleracion al caer y estar en el aire. En metros por segundo al cuadrado.
@export var gravity = 75
# Impulso del salto
@export var jump_impulse = 20
# Cuando se salta en un enemigo, se rebota.
@export var bounce_umpulse = 16

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		
		# Rotamos el Pivot (modelo) a la direccion del movimiento
		$Pivot.basis = Basis.looking_at(direction)
	
	# Velocidad en el suelo o por defecto
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# Velocidad en el aire, gravedad
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (gravity * delta)
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	
	_get_collisions()
	
	velocity = target_velocity
	move_and_slide()

func _get_collisions():
	# Iteramos en todas las colisiones de ese frame en concreto
	for index in range (get_slide_collision_count()):
		var collision = get_slide_collision(index)
		# Si la colision es con el suelo, continuamos
		if collision.get_collider() == null:
			continue
		# Si la colision es de un enemigo del grupo mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			# Comprobamos que el golpe o colision sea desde arriba
			if  Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()
				target_velocity.y = bounce_umpulse
				break # Con el break prevenimos llamadas duplicadas

func _die():
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(body):
	_die()
