extends Area2D

var enter = false

func _on_body_entered(body):
	if body.name == "Player" and !enter:
		enter = true
		$MeshInstance2D.hide()
		$CollisionShape2D.hide()
		$"../TroliadoPut0".play()
