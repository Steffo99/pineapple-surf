extends Node


@export_node_path(CharacterBody3D) var target_path: NodePath
@export var splash_threshold: float = 0.0

@onready var target: CharacterBody3D = get_node(target_path)
@onready var spawn_point: Vector3 = target.position
@onready var splash_sound: AudioStreamPlayer = $SplashSound


signal splashed()


func splash():
	splash_sound.play()
	target.position = spawn_point
	target.velocity = Vector3.ZERO
	emit_signal("splashed")


func _process(_delta):
	if target.position.y < splash_threshold:
		splash()
