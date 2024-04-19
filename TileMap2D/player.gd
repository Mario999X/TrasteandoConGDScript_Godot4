extends Node2D

var tile_map: TileMap

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if tile_map == null: 
		return
	
	if Input.is_action_just_pressed("up"):
		move(Vector2.UP)
	elif Input.is_action_just_pressed("down"):
		move(Vector2.DOWN)
	elif Input.is_action_just_pressed("right"):
		move(Vector2.RIGHT)
	elif Input.is_action_just_pressed("left"):
		move(Vector2.LEFT)

func move(direction: Vector2):
	# Celda actual del jugador
	var current_tile = tile_map.local_to_map(global_position)
	# Celda a la que se intenta desplazar
	var target_tile = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y
	)
	# Obtenemos la informacion de la celda a la que tratamos de acceder
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	# Verificamos que sea una celda en la que se pueda caminar
	if tile_data.get_custom_data("walkable") == false:
		return
	# Asignamos la posicion y desplazamos al jugador
	global_position = tile_map.map_to_local(target_tile)

# Si el tilemap siempre se llama igual, esto permite obtener el mapa siempre
# que se cambie de escena
func _enter_tree():
	tile_map = get_parent().get_node("TileMap")
