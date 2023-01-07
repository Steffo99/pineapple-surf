extends Control


signal play_pressed()


func play():
	print("Play button was pressed.")
	emit_signal("play_pressed")
