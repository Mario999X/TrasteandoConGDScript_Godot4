extends Label

var score = 0

func _score_increased():
	score += 1
	text = str(score)
	

func get_score():
	return score
