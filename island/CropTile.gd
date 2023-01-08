extends Node3D


signal on_planted()
signal on_complete()


@onready var growth_timer: Timer = $GrowthTimer
@onready var sprout_mesh: MeshInstance3D = $Plant/Sprout
@onready var pop_sound: AudioStreamPlayer3D = $Pop
@export var debug_growth: bool = false
@export var debug_growth_offset: float = 0.0;


func plant():
	if growth_timer.is_stopped():
		growth_timer.start()
		emit_signal("on_planted")


func complete():
	if not growth_timer.is_stopped():
		growth_timer.stop()
		pop_sound.play_with_random_pitch()
		emit_signal("on_complete")
	if debug_growth:
		plant()


func _process(_delta):
	var scale_factor = 1 - (growth_timer.time_left / growth_timer.wait_time)
	sprout_mesh.scale = Vector3(scale_factor, scale_factor, scale_factor)


func _ready():
	if debug_growth:
		growth_timer.start(growth_timer.wait_time - debug_growth_offset)
