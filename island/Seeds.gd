extends RigidBody3D


@export var value = 5


func _on_collectible_by_player_collected():
	var ps: PeaShooter = Singletons.player.get_node("Head/OnHand/PeaShooter")
	ps.remaining += value
