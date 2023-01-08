extends Node3D


signal splashed(splasher: CanSplash)


func splash(splasher: CanSplash):
	var splash_sound = splasher.get_node("SplashSound")
	splash_sound.play()
	splasher.emit_signal("splashed")
	emit_signal("splashed", splasher)


func _on_splash_area_body_entered(body: Node3D):
	var splashers: Array[Node] = body.find_children("*", "CanSplash", false, false)
	for splasher in splashers:
		splash(splasher)
