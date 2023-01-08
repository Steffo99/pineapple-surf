extends Node3D


@export_node_path(RigidBody3D) var target_path: NodePath
@onready var sound: AudioStreamPlayer3D = $CollectSound
var is_collected := false

@onready var target: RigidBody3D = get_node(target_path)

signal collected()


func collect():
	is_collected = true
	target.visible = false
	sound.play()
	emit_signal("collected")
	await get_tree().create_timer(1).timeout
	target.queue_free()


func _on_collect_area_body_entered(body: Node3D):
	if body is Player and not is_collected:
		collect()

