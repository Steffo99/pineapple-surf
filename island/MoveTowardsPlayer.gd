extends Node


@export var force_multiplier: float
@export_node_path(RigidBody3D) var target_path: NodePath
@export var is_magnetized := false

@onready var target: RigidBody3D = get_node(target_path)

signal magnetized()


func magnetize():
	is_magnetized = true
	emit_signal("magnetized")


func _physics_process(delta):
	if is_magnetized and target != null:
		var direction = Singletons.player.position - target.position
		var force = direction.normalized() * force_multiplier * delta
		target.apply_force(force)


func _on_magnet_area_body_entered(body: Node3D):
	if body is Player:
		magnetize()
