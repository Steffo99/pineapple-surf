extends RigidBody3D


@onready var player := Singletons.player


func _on_collectible_by_player_collected():
	player.collected_fruit += 1
