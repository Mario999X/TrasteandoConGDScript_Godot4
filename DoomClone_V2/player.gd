extends CharacterBody3D

@onready var gun_animation = $CanvasLayer/GunBase/GunAnimation
@onready var ray_cast_3d = $Camera3D/RayCast3D
@onready var shoot_audio = $ShootAudio
@onready var camera = $Camera3D

const SPEED = 5.0
const MOUSE_SENS = 0.002

var can_shoot: bool
var dead: bool

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	can_shoot = true
	dead = false

func _input(event):
	if event is InputEventMouseMotion and !dead:
		rotate_y(-event.relative.x * MOUSE_SENS) # Mover el modelado + camara
		camera.rotate_x(-event.relative.y * MOUSE_SENS) # Mover solo camara, hacia todas las direcciones
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2) # Limitar el movimiento en las x (?)  

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	if dead:
		return
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	

# Movimiento basico del jugador.
func _physics_process(delta):
	if dead:
		return
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()

# Funcion principal de disparo
func shoot():
	if !can_shoot:
		return
	else:
		can_shoot = false
		gun_animation.play("shoot")
		shoot_audio.play()
		
		if ray_cast_3d.is_colliding() and ray_cast_3d.get_collider().has_method("kill"):
			ray_cast_3d.get_collider().kill()

# Cuando termine la animacion de disparar, se puede volver a disparar
func _on_gun_animation_animation_finished():
	can_shoot = true

# Funcion para la moricion del jugador.
func kill():
	dead = true
	$CanvasLayer/GunBase.hide()
	$CanvasLayer/Point.hide()
	$CanvasLayer/DeathScreen.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# Boton para recargar la escena
func _on_restart_btn_pressed():
	get_tree().reload_current_scene()
