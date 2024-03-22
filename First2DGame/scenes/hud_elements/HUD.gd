extends CanvasLayer

signal start_game # Se usara para avisar al script de MainLevel de que se pulso el boton de Start

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Mission failed we'll get 'em next time")
	# Esperamos hasta que el contador de MessageTimer haya terminado
	await $MessageTimer.timeout
	
	$Message.text = "Dale Don Dale!"
	$Message.show()
	
	# Es posible crear contadores de 0, y usarlos para realizar esperas.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	

func update_score(score):
	$ScoreLabel.text = str(score) # Casteamos de un numero a un string. Equivalente a ToString


func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout():
	$Message.hide()
