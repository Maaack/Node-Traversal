extends Control


signal start_game

func _on_StartGame_pressed():
	emit_signal("start_game")
	hide()
