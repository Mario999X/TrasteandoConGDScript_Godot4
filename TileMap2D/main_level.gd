extends Node2D

@export var player_scene: PackedScene

@export var initial_respawn: Vector2i

# Instanciamos al jugador dandole una posicion inicial
func _ready():
	var player = player_scene.instantiate()
	
	player.global_position = initial_respawn
	add_child(player)
	
