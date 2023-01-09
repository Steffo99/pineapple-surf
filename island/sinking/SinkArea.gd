extends Area3D
class_name SinkArea


## A node fell in the water.
## Triggers after CanSink.sunk .
signal has_sunk(sinkable: CanSink)


func _on_body_entered(body: Node3D):
	var sinkables = body.find_children("*", "CanSink", false, false)
	for sinkable in sinkables:
		sinkable.sink()
		emit_signal("has_sunk", sinkable)
