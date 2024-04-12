extends Node

@export var mob_scene_prefab: PackedScene

func _ready():
	$HUD/Retry.hide()

func _on_mob_timer_timeout():
	# Nueva instancia del bicho, pero sin instanciarse todavia
	var mob = mob_scene_prefab.instantiate()
	
	# Obtenemos una posicion aleatoria del Path que preparamos en la escena
	var mob_spawn_location = $SpawnPath/SpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# La posicion del jugador cuando termine el contador
	var player_position = $Player.position
	
	# Usamos la funcion principal del enemigo
	mob.start_movement_enemy(mob_spawn_location.position, player_position)
	
	# Spawneamos al bicho en la escena
	add_child(mob)
	
	# Forma de conectar una señal del prefab de mob
	mob.squashed.connect($HUD/ScoreText._score_increased.bind())


func _on_player_hit():
	$HUD/Retry/ScoreTextObtained.text = "Puntuación obtenida: " + str($HUD/ScoreText.get_score())
	$HUD/Retry.show()
	$MobTimer.stop()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $HUD/Retry.visible:
		# Reiniciamos la escena directamente
		get_tree().reload_current_scene()
