extends Area2D

signal hit

@export var speed = 400 # Equivalente al [SerializeField] de Unity
var screen_size 

# Equivalente al Awake
func _init():
	hide()

# Called when the node enters the scene tree for the first time. Equivalente a Start
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame. Equivalente a Update
func _process(delta):
	var velocity = Vector2.ZERO # El vector de movimiento del jugador.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2DPlayer.play() # Equivalente a get_node("AnimatedSprite2DPlayer").play()
	else:
		$AnimatedSprite2DPlayer.stop() # Tambien equivalente a GetComponent() de Unity pero solo dentro de una misma escena.
	
	if velocity.x != 0:
		$AnimatedSprite2DPlayer.animation = "walk"
		$AnimatedSprite2DPlayer.flip_v = false;
		$AnimatedSprite2DPlayer.flip_h = velocity.x < 0 
	elif velocity.y != 0:
		$AnimatedSprite2DPlayer.animation = "up"
		$AnimatedSprite2DPlayer.flip_v = velocity.y > 0
	
	# Actualizamos la posicion del jugador. Aplicamos clamp para que no salga de la pantalla.
	# Delta es usado para que el movimiento sea consistente si el frame rate cambia.
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

# Equivalente al OnCollisionEnter(RigidBody body)
func _on_body_entered(body):
	# Escondemos al jugador, emitimos la señal de hit.
	hide()
	hit.emit()
	# Para evitar problemas, desactivamos la hitbox. En esta clase de funciones debemos usar deferred.
	$CollisionShape2DPlayer.set_deferred("disabled", true)

# Establecemos la posicion del jugador, lo mostramos y activamos su hitbox.
func start(pos):
	position = pos
	show()
	$CollisionShape2DPlayer.disabled = false;
