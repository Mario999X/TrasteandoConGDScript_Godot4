extends Node

# Variables ya instanciadas
@onready var main_menu = $CanvasLayer/MainMenu
@onready var address_line_edit = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressIP
@onready var hud = $CanvasLayer/HUD
@onready var health_bar = $CanvasLayer/HUD/HealthBar

# Constantes
const PLAYER = preload("res://player.tscn")
const PORT = 25565 # El puerto del minecra
var enet_peer = ENetMultiplayerPeer.new()

# Funcion por defecto, usada para cerrar el juego.
func _unhandled_input(event):
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()

# Funcion para empezar una partida como Host.
# Importante, las funciones peer_connected y peer_disconnected.
# Se ejecutan cuando un cliente se conecta o desconecta.
# El host no cuenta en el connected, por eso se ejecuta la funcion de spawn.
func _on_btn_host_pressed():
	main_menu.hide()
	hud.show()
	
	enet_peer.create_server(PORT)
	
	multiplayer.multiplayer_peer = enet_peer
	
	multiplayer.peer_connected.connect(spawn_player)
	
	multiplayer.peer_disconnected.connect(remove_player)
	
	spawn_player(multiplayer.get_unique_id())

# Se genera un cliente en base al peer. Se le pasa la direccion de conexion y el puerto.
func _on_btn_join_pressed():
	if(!address_line_edit.text.strip_edges().is_empty()):
		main_menu.hide()
		
		enet_peer.create_client(address_line_edit.text, PORT)
		
		hud.show()
		multiplayer.multiplayer_peer = enet_peer

# Se le pasa un id especifico como identificador. Funcion usada al unirse a la partida.
# Como el HUD esta en esta escena, se conecta la señal de la clase player de la barra de vida.
func spawn_player(player_peer_id):
	var player = PLAYER.instantiate()
	player.name = str(player_peer_id)
	
	add_child(player)
	
	# Codigo para el servidor
	if player.is_multiplayer_authority():
		player.health_changed.connect(update_health_bar)

# Funcion usada para eliminar a un cliente cuando cierre la partida.
func remove_player(player_peer_id):
	var player = get_node_or_null(str(player_peer_id))
	if player:
		player.queue_free()

# Funcion para actualizar la barra de vida de forma individual.
func update_health_bar(health_value):
	health_bar.value = health_value

# Código para el cliente
func _on_multiplayer_spawner_spawned(node):
	if node.is_multiplayer_authority():
		node.health_changed.connect(update_health_bar)
