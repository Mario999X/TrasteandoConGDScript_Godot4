extends RigidBody2D

func _ready():
	# Obtenemos los nombre de todas las animaciones que tenga el enemigo y ejecutamos una de forma random.
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])

'''
La verdad es que viniendo de Unity esto puede resultar raro, el movimiento del enemigo es iniciado en esta funcion.

Si bien en Unity este tipo de funciones deberian de pasar si o si por un Update o FixedUpdate, aqui no es necesario.
El propio motor se encarga de ello. 
Mas especificamente, linear_velocity. Es un elemento exclusivo de RigidBody.

En las ultimas lineas de la clase, dejo una equivalencia con Unity
'''
func set_direction_and_speed(direction):
	direction += randf_range(-PI / 4, PI / 4)
	rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	linear_velocity = velocity.rotated(direction)
	#velocity.x += 1 # En caso de querer comparar a modificar la linear_velocity

# Seleccionando el componente VisibleOnScreen y en su inspector, en la pestaña Node, 
# enlazamos la funcion screen_exited()
func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free() # Lo liberamos de la memoria.

# Codigo en Unity de desplazamiento de enemigos.
'''
private Vector3 velocity;

	void Start()
	{
		SetDirectionAndSpeed();
	}

	void SetDirectionAndSpeed()
	{
		float direction = Random.Range(-Mathf.PI / 4, Mathf.PI / 4);
		transform.rotation = Quaternion.Euler(0, 0, direction * Mathf.Rad2Deg);
		
		float speed = Random.Range(150.0f, 250.0f);
		velocity = new Vector3(speed, 0, 0);
		velocity = Quaternion.Euler(0, 0, direction * Mathf.Rad2Deg) * velocity;
	}

	void Update()
	{
		transform.position += velocity * Time.deltaTime;
	}
'''
