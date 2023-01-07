extends Node3D


signal on_planted()
signal on_complete()


@onready var growth_timer: Timer = $GrowthTimer
@onready var sprout_mesh: MeshInstance3D = $Plant/Sprout


func plant():
	if growth_timer.is_stopped():
		growth_timer.start()
		emit_signal("on_planted")


func complete():
	if not growth_timer.is_stopped():
		growth_timer.stop()
		emit_signal("on_complete")


func _process(_delta):
	var scale_factor = 1 - (growth_timer.time_left / growth_timer.wait_time)
	sprout_mesh.scale = Vector3(scale_factor, scale_factor, scale_factor)
