extends Node3D
class_name CropTile


signal on_planted()
signal on_complete()


@onready var growth_timer: Timer = $GrowthTimer
@onready var sprout_mesh: MeshInstance3D = $Plant/Sprout
@onready var pop_sound: AudioStreamPlayer3D = $Pop
@onready var producer: Node3D = $Producer
@onready var plant_shape: CollisionShape3D = $Plant/PlantableArea

@export var produce_scene: PackedScene = preload("res://island/Pineapple.tscn")

@export var debug_growth: bool = false
@export var debug_growth_offset: float = 0.0;


func plant():
	if growth_timer.is_stopped():
		growth_timer.start()
		emit_signal("on_planted")


func complete():
	pop_sound.play_with_random_pitch()
	producer.produce_with_random_force()
	emit_signal("on_complete")
	if debug_growth:
		plant()
	else:
		plant_shape.disabled = true
		await get_tree().create_timer(1).timeout
		queue_free()


func _process(_delta):
	var scale_factor = 0
	if not growth_timer.is_stopped():
		scale_factor = 0.10 + 0.90 * (1 - growth_timer.time_left / growth_timer.wait_time)
	sprout_mesh.scale = Vector3(scale_factor, scale_factor, scale_factor)


func _ready():
	if debug_growth:
		growth_timer.start(growth_timer.wait_time - debug_growth_offset)
