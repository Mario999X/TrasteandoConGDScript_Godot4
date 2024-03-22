extends Node

@export var mob_scene: PackedScene # PackedScene junto al export permite que desde el inspector podamos seleccionar una escena
var score

func _on_player_hit_game_over():
	$Music.stop()
	$DeathSound.play()
	
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	$Hud.show_game_over()

func new_game():
	# Preparamos tremenda musica de fondo
	$Music.play()
	# Comprobamos que no queden enemigos, si no, son eliminados
	get_tree().call_group("mobs", "queue_free") # Hacemos uso de los grupos, parecido a los tags de Unity
	
	score = 0
	$Hud.update_score(score)
	$Hud.show_message("Better Call Saul!")
	
	$Player.start($StartPositionPlayer.position)
	$StartTimer.start()

func _on_mob_timer_timeout():
	# Instanciamos al enemigo. Recordemos que las escenas funcionan como prefabs.
	var mob = mob_scene.instantiate()
	
	# Escogemos un punto aleatorio para su posicion inicial
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	
	# Preparamos su direccion, rotacion y velocidad
	var direction = mob_spawn_location.rotation + PI / 2
	mob.set_direction_and_speed(direction)
	
	# Finalmente, lo agregamos como hijo de la escena principal
	add_child(mob)

func _on_score_timer_timeout():
	score += 1
	$Hud.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

# Cuando se emita la señal de new game desde la interfaz, se ejecuta la funcion new game del nivel
func _on_hud_start_game():
	new_game()
