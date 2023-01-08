extends Node

@export var force_multiplier: float
@export var target: RigidBody3D

# Must be BELOW the player node to work!
@onready var magnet_area: Area3D = $MagnetArea
@onready var player: CharacterBody3D = get_tree().root.find_child("Player", true, false)


var captured = false


func capture():
	captured = true


func _physics_process(delta):
	if captured:
		var direction = player.position - target.position
		var force = direction.normalized() * force_multiplier * delta
		target.apply_force(force)


func _on_magnet_area_body_entered(body: Node3D):
	if body.name == "Player":
		print("Player captured pickup!")
		capture()
