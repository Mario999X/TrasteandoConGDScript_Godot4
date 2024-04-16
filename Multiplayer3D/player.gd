extends CharacterBody3D

# Las señales pueden tener variables
signal health_changed(health_value)

#Variables unicas que ya estan instanciadas desde un principio
@onready var camera = $Camera3D
@onready var animation_player = $AnimationPlayer
@onready var raycast = $Camera3D/RayCast3D

var health = 3

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Funcion por defecto. Se asigna el nombre del cliente.
func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

# Uso del primer if para no manejar al resto de jugadores.
func _ready():
	if not is_multiplayer_authority(): return
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.current = true

func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.005) # Mover el modelado + camara
		camera.rotate_x(-event.relative.y * 0.005) # Mover solo camara, hacia todas las direcciones
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2) # Limitar el movimiento en las x (?)  

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("shoot") \
	and animation_player.current_animation != "shoot":
		play_shoot_effects.rpc()
		
		if raycast.is_colliding():
			var hit_player = raycast.get_collider()
			hit_player.receive_damage.rpc_id(hit_player.get_multiplayer_authority())

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()

# Esta funcion la ejecuta el jugador que hace daño, pero se tiene que reflejar en el jugador objetivo.
@rpc("any_peer")
func receive_damage():
	health -= 1
	
	if health <= 0:
		health = 3
		position = Vector3.ZERO
	
	health_changed.emit(health)

# Esta funcion es ejecutada cuando se hace la animacion de disparo. Se le agrega el "call_local" para que
# todos los jugadores puedan verla.
@rpc("call_local")
func play_shoot_effects():
	animation_player.stop()
	animation_player.play("shoot")
