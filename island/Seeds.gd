extends RigidBody3D


@export var value = 5

@onready var player := Singletons.player


func _on_collectible_by_player_collected():
	var ps: PeaShooter = player.get_node("Head/OnHand/PeaShooter")
	ps.remaining += value
