extends Node2D

# Punto de conexion
var peer = ENetMultiplayerPeer.new()
# Puerto para la partida
var _port = 25565

# Prefab del jugador
@export var player_scene: PackedScene

# El boton del host. Se crea el servidor con el puerto. 
func _on_btn_host_pressed():
	peer.create_server(_port)
	multiplayer.multiplayer_peer = peer
	# Cada vez que se conecte un cliente, se ejecuta esa funcion.
	multiplayer.peer_connected.connect(_add_player)
	# Para que el host aparezca, se necesita llamar igualmente a la funcion.
	_add_player()

# Funcion para agregar nuevos jugadores. Por defecto, el host tiene el 1.
# De forma aleatoria, da un ID xd.
func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)

# El boton del cliente.
func _on_btn_join_pressed():
	peer.create_client("localhost", _port)
	multiplayer.multiplayer_peer = peer
