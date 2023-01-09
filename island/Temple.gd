extends Node3D


@export var size_per_prayer = 0.05
@export var pitch_per_prayer = 0.02

@onready var player: Player = Singletons.player
@onready var prayer_area: Area3D = $PrayerArea
@onready var pineglasses: MeshInstance3D = $Pineglasses
@onready var pineglasses_sound: AudioStreamPlayer3D = $Pineglasses/Growth


func _physics_process(_delta):
	if prayer_area.overlaps_body(player):
		if player.collected_fruit > 0:
			if not pineglasses_sound.playing:
				pineglasses_sound.play()
			player.collected_fruit -= 1
			Singletons.score += 1
			pineglasses.scale += Vector3(size_per_prayer, size_per_prayer, size_per_prayer)
			pineglasses_sound.pitch_scale += pitch_per_prayer
		else:
			if pineglasses_sound.playing:
				pineglasses_sound.stop()
	else:
		if pineglasses_sound.playing:
			pineglasses_sound.stop()
