extends CharacterBody3D

signal hit

@onready var animated_sprite_3d = $AnimatedSprite3D

@export var move_speed: float = 2.0
@export var attack_range: float = 2.0

@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("player")

var dead: bool

func _ready():
	dead = false

func _physics_process(delta):
	if dead:
		return
	if player == null:
		return
	
	var dir = player.global_position - global_position
	dir.y = 0.0
	dir = dir.normalized()
	
	velocity = dir * move_speed
	
	look_at(player.global_position, Vector3.UP)
	
	move_and_slide()
	attempt_to_kill_player()

# Funcion para la moricion del enemigo.
func kill():
	dead = true
	$DeathSound3D.play()
	animated_sprite_3d.play("death")
	$CollisionShape3D.disabled = true
	
	hit.emit()
	
	$DeathTimer.start()

# Funcion para matar al jugador. Si se acerca demasiado, lo mata.
# Se realiza una consulta, lanzando un raycast y, si el resultado esta vacio, no hay obstaculos de por medio.
# Se mata al jugador.
func attempt_to_kill_player():
	var distance_to_player = global_position.distance_to(player.global_position)
	if distance_to_player > attack_range:
		return
	
	var eye_line = Vector3.UP * 1.5
	var query = PhysicsRayQueryParameters3D.create(global_position + eye_line, player.global_position + eye_line, 1)
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	
	if result.is_empty():
		player.kill()
	


func _on_death_timer_timeout():
	queue_free()
