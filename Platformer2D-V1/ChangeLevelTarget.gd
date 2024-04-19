extends Area2D

@export var level: PackedScene

# Al hacer un call_deferred, evitamos problemas de fisica al cargar la nueva escena.
func _on_body_entered(body):
	if body.name == "Player":
		call_deferred("change_level")

func change_level():
	get_tree().change_scene_to_file(level.resource_path)
