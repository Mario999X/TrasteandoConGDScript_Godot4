extends CharacterBody2D

const SPEED = 400

func _physics_process(delta):
	# Para mover al muñeco del cliente en especifico.
	if is_multiplayer_authority():
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED
		move_and_slide()

# Funcion propia de Godot. Se le asigna un nombre.
func _enter_tree():
	set_multiplayer_authority(name.to_int())
