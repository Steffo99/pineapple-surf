extends Control


signal play_pressed()


func play():
	print("Play button was pressed.")
	emit_signal("play_pressed")


func _on_text_edit_text_changed():
	Singletons.username = $Content/Inputs/NameInput.text
