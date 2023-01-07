extends Node
class_name BaseWeapon

enum WeaponSlot {
	ONE,
	TWO,
	THREE
}

@export_range(0,1) var MOUSE_MOVEMENT_BOB_AMOUNT := 0.5

var player: Player
var weaponSlot: WeaponSlot = WeaponSlot.ONE
var mouse_movement := Vector2.ZERO

func on_switch_in():
	pass

func on_switch_out():
	pass

func bob_weapon(node: Node3D, delta: float):
	node.position = Vector3.ZERO.lerp(Vector3(
		0,
		self.mouse_movement.x*0.05,
		-self.mouse_movement.y*0.05,
	), delta / MOUSE_MOVEMENT_BOB_AMOUNT)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var vec = event.relative
		self.mouse_movement = Vector2(vec.y, vec.x)
