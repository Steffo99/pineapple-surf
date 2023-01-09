extends Node
class_name CanSink


## This fell in the water.
## Triggers before SinkArea.has_sunk .
signal sank()


func sink():
	$SplashSound.play()
	emit_signal("sank")
