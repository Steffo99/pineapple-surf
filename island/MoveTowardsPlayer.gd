extends Node

@export var force_multiplier: float
@export var target: RigidBody3D
@export var capture_radius: float = 1.5

@onready var magnet_area: Area3D = $MagnetArea
@onready var capture_area: Area3D = $CaptureArea
@onready var pop: AudioStreamPlayer3D = $"../Pop"
@onready var mesh: MeshInstance3D = $"../PineappleMesh"

var captured = false


func capture():
	captured = true


func _physics_process(delta):
	if captured:
		var direction = Singletons.player.position - target.position
		var force = direction.normalized() * force_multiplier * delta
		target.apply_force(force)


func _on_magnet_area_body_entered(body: Node3D):
	if body is Player:
		print("Player captured pickup!")
		capture()


func _on_capture_area_body_entered(body: Node3D) -> void:
	mesh.visible = false
	pop.play()
	await get_tree().create_timer(1).timeout
	target.queue_free()
