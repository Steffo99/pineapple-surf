extends Node3D


@export var produce_scene: PackedScene = preload("res://island/Pineapple.tscn")

var rng: RandomNumberGenerator


func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()


func produce_with_random_force():
	# TODO: Not sure it's a good idea attaching produce to the crop
	var produce: RigidBody3D = produce_scene.instantiate()
	add_child(produce)
	produce.apply_impulse(Vector3.UP * rng.randf_range(15.0, 25.0))
