extends AudioStreamPlayer3D


var rng: RandomNumberGenerator


func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()


func play_with_random_pitch():
	pitch_scale = rng.randf_range(0.3, 1.0)
	play()
