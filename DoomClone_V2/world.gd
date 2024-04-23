extends Node

const ENEMIES_LIMIT = 15

@export var enemy_scene: PackedScene 

var spawn_positions: Array

var score = 0

var current_enemies = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	obtain_spawn_points()

# Obtenemos todas las posiciones de los spawns repartidos por el mapa y
# comenzamos con las apariciones de los enemigos.
func obtain_spawn_points():
	for s in get_node("SpawnPoints").get_children():
		spawn_positions.append(s.position)
	
	$SpawnTimer.start()

# Funcion para spawnear enemigos
func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	
	enemy.position = spawn_positions.pick_random()
	
	add_child(enemy)
	
	enemy.hit.connect(increase_score.bind())

func _on_spawn_timer_timeout():
	if current_enemies == ENEMIES_LIMIT:
		return
	
	if $Player.dead:
		$MusicLevel.stop()
		$EndGameMusic.play()
		
		$SpawnTimer.stop()
	else:
		current_enemies += 1
		spawn_enemy()

func increase_score():
	current_enemies -= 1
	score += 1
	$CanvasLayer/HUD/ScoreText.text = "Score: " + str(score)
