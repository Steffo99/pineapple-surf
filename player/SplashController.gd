extends Node


@onready var player: Node3D = $".."
@onready var spawn_point: Vector3 = player.position
@onready var splash_sound: AudioStreamPlayer = $SplashSound


func _process(_delta):
	if player.position.y < 0:
		splash_sound.play()
		player.position = spawn_point
