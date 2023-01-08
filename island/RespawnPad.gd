extends Node3D


@export var spawn_on_ready: bool
@export var spawn_scene: PackedScene

@onready var respawn_timer: Timer = $RespawnTimer
@onready var produce_container: Node3D = get_tree().root.find_child("Produce", true, false)

var current_node: Node = null


signal spawned(node)
signal collected()


func spawn():
	if current_node == null:
		var node = spawn_scene.instantiate()
		node.position = global_position
		current_node = node
		produce_container.add_child(node)
		node.connect("tree_exiting", _on_collect)
		emit_signal("spawned", node)


func _on_collect():
	current_node = null
	respawn_timer.start()
	emit_signal("collected")


func _on_respawn_timeout():
	spawn()


func _ready():
	if spawn_on_ready:
		spawn()
	else:
		respawn_timer.start()
