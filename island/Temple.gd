extends Node3D


var score: int = 0
var time: float = 0.0
var exploded: bool = false

@export var size_per_prayer: float = 0.05
@export var pitch_per_prayer: float = 0.02
@export var explode_at: int = 150
@export var explosion_scene: PackedScene = preload("res://island/FunnyExplosion.tscn")

@onready var player: Player = Singletons.player
@onready var prayer_area: Area3D = $PrayerArea
@onready var pineglasses: MeshInstance3D = $Pineglasses
@onready var pineglasses_sound: AudioStreamPlayer3D = $Pineglasses/Growth


func try_to_collect_fruit():
	if prayer_area.overlaps_body(player):
		if player.collected_fruit > 0:
			if not pineglasses_sound.playing:
				pineglasses_sound.play()
			player.collected_fruit -= 1
			score += 1
			pineglasses.scale += Vector3(size_per_prayer, size_per_prayer, size_per_prayer)
			pineglasses_sound.pitch_scale += pitch_per_prayer
		else:
			if pineglasses_sound.playing:
				pineglasses_sound.stop()
	else:
		if pineglasses_sound.playing:
			pineglasses_sound.stop()


# "is it gonna explode tho"
# --Ichi
func try_to_explode():
	if not exploded and score >= explode_at:
		exploded = true
		var explosion = explosion_scene.instantiate()
		var explosion_sound = explosion.get_node("ExplosionSound")
		explosion.position = pineglasses.position + Vector3.UP
		explosion.scale = pineglasses.scale
		explosion_sound.connect("finished", win)
		add_child(explosion)


func win():
	print("YOU WIN!")
	print("Time: ", time)
	queue_free()


func _process(delta):
	if not exploded:
		time += delta


func _physics_process(_delta):
	try_to_collect_fruit()
	try_to_explode()
